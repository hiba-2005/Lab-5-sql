USE bibliotheque;
-- Découverte des fonctions d’agrégation
SELECT COUNT(*) AS total_abonnes
FROM abonne;
SELECT COUNT(*) AS total_abonnes
FROM abonne;

SELECT AVG(nb) AS moyenne_emprunts
FROM (
  SELECT COUNT(*) AS nb
  FROM emprunt
  GROUP BY abonne_id
) AS sous;

SELECT AVG(prix_unitaire) AS prix_moyen
FROM ouvrage;

-- Utilisation de GROUP BY

SELECT abonne_id, COUNT(*) AS nbre
FROM emprunt
GROUP BY abonne_id;

SELECT auteur_id, COUNT(*) AS total_ouvrages
FROM ouvrage
GROUP BY auteur_id;


-- Filtrer les groupes avec HAVING
SELECT abonne_id, COUNT(*) AS nbre
FROM emprunt
GROUP BY abonne_id
HAVING COUNT(*) >= 3;

SELECT auteur_id, COUNT(*) AS total_ouvrages
FROM ouvrage
GROUP BY auteur_id
HAVING total_ouvrages > 5;

-- Jointures et agrégats combinés
SELECT a.nom, COUNT(e.id) AS emprunts
FROM abonne a
LEFT JOIN emprunt e ON e.abonne_id = a.id
GROUP BY a.id, a.nom;

SELECT a.nom, COUNT(e.ouvrage_id) AS emprunts
FROM abonne a
LEFT JOIN emprunt e ON e.abonne_id = a.id
GROUP BY a.id, a.nom;

SELECT au.nom, COUNT(e.ouvrage_id) AS total_emprunts
FROM auteur au
JOIN ouvrage o ON o.auteur_id = au.id
LEFT JOIN emprunt e ON e.ouvrage_id = o.id
GROUP BY au.id, au.nom;

-- Analyses plus complexes (ratio, pourcentage)

SELECT 
  ROUND(
    COUNT(CASE WHEN e.id IS NOT NULL THEN 1 END) * 100 
    / COUNT(DISTINCT o.id), 2
  ) AS pct_empruntes
FROM ouvrage o
LEFT JOIN emprunt e ON e.ouvrage_id = o.id;

SELECT
  ROUND(
    COUNT(DISTINCT e.ouvrage_id) * 100
    / COUNT(DISTINCT o.id),
    2
  ) AS pct_empruntes
FROM ouvrage o
LEFT JOIN emprunt e ON e.ouvrage_id = o.id;

SELECT a.nom, COUNT(*) AS nbre_emprunts
FROM abonne a
JOIN emprunt e ON e.abonne_id = a.id
GROUP BY a.id, a.nom
ORDER BY nbre_emprunts DESC
LIMIT 3;

-- Sous-requêtes et CTE pour l’agrégation

WITH stats AS (
  SELECT o.auteur_id, COUNT(e.id) AS emprunts, COUNT(DISTINCT o.id) AS ouvrages
  FROM ouvrage o
  LEFT JOIN emprunt e ON e.ouvrage_id = o.id
  GROUP BY o.auteur_id
)
SELECT s.auteur_id, s.emprunts / s.ouvrages AS moyenne
FROM stats s
WHERE s.emprunts / s.ouvrages > 2;

WITH stats AS (
  SELECT
    o.auteur_id,
    COUNT(e.ouvrage_id) AS emprunts,
    COUNT(DISTINCT o.id) AS ouvrages
  FROM ouvrage o
  LEFT JOIN emprunt e ON e.ouvrage_id = o.id
  GROUP BY o.auteur_id
)
SELECT
  s.auteur_id,
  ROUND(s.emprunts / NULLIF(s.ouvrages, 0), 2) AS moyenne
FROM stats s
WHERE (s.emprunts / NULLIF(s.ouvrages, 0)) > 2;

-- Exercices pratiques

-- Trouver le nombre moyen d’emprunts par jour de la semaine (utiliser DAYOFWEEK(date_debut)).
SELECT jour_semaine, ROUND(AVG(nb_emprunts), 2) AS moyenne_emprunts
FROM (
  SELECT DAYOFWEEK(date_debut) AS jour_semaine, DATE(date_debut) AS jour, COUNT(*) AS nb_emprunts
  FROM emprunt
  GROUP BY DAYOFWEEK(date_debut), DATE(date_debut)
) t
GROUP BY jour_semaine
ORDER BY jour_semaine;
-- Afficher, pour chaque mois de l’année 2025, le total d’emprunts effectués.
SELECT MONTH(date_debut) AS mois, COUNT(*) AS total_emprunts
FROM emprunt
WHERE date_debut >= '2025-01-01' AND date_debut < '2026-01-01'
GROUP BY MONTH(date_debut)
ORDER BY mois;

-- Repérer les ouvrages jamais empruntés et compter leur nombre.
SELECT COUNT(*) AS nb_ouvrages_jamais_empruntes
FROM ouvrage o
LEFT JOIN emprunt e ON e.ouvrage_id = o.id
WHERE e.ouvrage_id IS NULL;

SELECT o.id, o.titre
FROM ouvrage o
LEFT JOIN emprunt e ON e.ouvrage_id = o.id
WHERE e.ouvrage_id IS NULL;

