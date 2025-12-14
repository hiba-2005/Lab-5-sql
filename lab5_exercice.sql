USE bibliotheque;


WITH
--  Générer les 12 mois pour afficher aussi ceux sans emprunt
mois_2025 AS (
  SELECT 1 AS mois UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
  UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8
  UNION ALL SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12
),

-- Extraire les données mensuelles
emprunts_2025 AS (
  SELECT
    YEAR(date_debut)  AS annee,
    MONTH(date_debut) AS mois,
    ouvrage_id,
    abonne_id
  FROM emprunt
  WHERE date_debut >= '2025-01-01'
    AND date_debut <  '2026-01-01'
),

--  Calculer les indicateurs de base
kpi_base AS (
  SELECT
    2025 AS annee,
    m.mois,
    COALESCE(COUNT(e.ouvrage_id), 0) AS total_emprunts,
    COALESCE(COUNT(DISTINCT e.abonne_id), 0) AS abonnes_actifs
  FROM mois_2025 m
  LEFT JOIN emprunts_2025 e ON e.mois = m.mois
  GROUP BY m.mois
),

-- Moyenne par abonné (éviter division par 0)
kpi AS (
  SELECT
    annee,
    mois,
    total_emprunts,
    abonnes_actifs,
    CASE
      WHEN abonnes_actifs = 0 THEN 0
      ELSE ROUND(total_emprunts / abonnes_actifs, 2)
    END AS moyenne_par_abonne
  FROM kpi_base
),

--  Top ouvrages mensuels (compter puis classer)
nb_par_ouvrage AS (
  SELECT
    annee,
    mois,
    ouvrage_id,
    COUNT(*) AS nb_emprunts
  FROM emprunts_2025
  GROUP BY annee, mois, ouvrage_id
),

classement AS (
  SELECT
    n.annee,
    n.mois,
    o.titre,
    n.nb_emprunts,
    ROW_NUMBER() OVER (
      PARTITION BY n.annee, n.mois
      ORDER BY n.nb_emprunts DESC, n.ouvrage_id ASC
    ) AS rn
  FROM nb_par_ouvrage n
  JOIN ouvrage o ON o.id = n.ouvrage_id
),

top3 AS (
  SELECT
    annee,
    mois,
    GROUP_CONCAT(CONCAT(titre, ' (', nb_emprunts, ')')
                 ORDER BY nb_emprunts DESC SEPARATOR ', ') AS top3_ouvrages
  FROM classement
  WHERE rn <= 3
  GROUP BY annee, mois
),

-- Pourcentage d’ouvrages empruntés au moins une fois dans le mois
total_ouvrages AS (
  SELECT COUNT(*) AS total
  FROM ouvrage
),

pct_mensuel AS (
  SELECT
    2025 AS annee,
    m.mois,
    ROUND(
      COALESCE(COUNT(DISTINCT e.ouvrage_id), 0) * 100 / t.total,
      2
    ) AS pct_empruntes
  FROM mois_2025 m
  LEFT JOIN emprunts_2025 e ON e.mois = m.mois
  CROSS JOIN total_ouvrages t
  GROUP BY m.mois, t.total
)

--  Rapport final
SELECT
  k.annee,
  k.mois,
  k.total_emprunts,
  k.abonnes_actifs,
  k.moyenne_par_abonne,
  p.pct_empruntes,
  COALESCE(t.top3_ouvrages, '') AS top3_ouvrages
FROM kpi k
JOIN pct_mensuel p ON p.annee = k.annee AND p.mois = k.mois
LEFT JOIN top3 t ON t.annee = k.annee AND t.mois = k.mois
ORDER BY k.annee, k.mois;
