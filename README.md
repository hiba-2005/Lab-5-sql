# Lab 5 : Agrégation, groupements et analyses

## Objectif

Analyser les données de la base `bibliotheque` avec `COUNT`, `AVG`, `GROUP BY`, `HAVING`, jointures et CTE.

## Contenu
- Statistiques globales (abonnés, emprunts)
- Regroupements par abonné/auteur/mois
- Filtres sur groupes (HAVING)

## La partie lab 

### Résultat visuel

#### Découverte des fonctions d’agrégation

<div align="center"> <img src="image/image1.jpg" alt="Résultat image1" width="1000"/> <p><em>Figure 1</em></p> </div>



<div align="center"> <img src="image/image2.jpg" alt="Résultat image2" width="1000"/> <p><em>Figure 2</em></p> </div>

####  Utilisation de GROUP BY

<div align="center"> <img src="image/image3.jpg" alt="Résultat image3" width="1000"/> <p><em>Figure 3</em></p> </div>

####  Filtrer les groupes avec HAVING

<div align="center"> <img src="image/image4.jpg" alt="Résultat image4" width="1000"/> <p><em>Figure 4</em></p> </div>

####  Jointures et agrégats combinés

<div align="center"> <img src="image/image5.jpg" alt="Résultat image5" width="1000"/> <p><em>Figure 5</em></p> </div>

#### Analyses plus complexes (ratio, pourcentage)

<div align="center"> <img src="image/image6.jpg" alt="Résultat image6" width="1000"/> <p><em>Figure 6</em></p> </div>

####  Sous-requêtes et CTE pour l’agrégation

<div align="center"> <img src="image/image7.jpg" alt="Résultat image7" width="1000"/> <p><em>Figure 7</em></p> </div>

### Exercices pratiques

#### Trouver le nombre moyen d’emprunts par jour de la semaine (utiliser DAYOFWEEK(date_debut)).

<div align="center"> <img src="image/image8.jpg" alt="Résultat image8" width="1000"/> <p><em>Figure 8</em></p> </div>

#### Afficher, pour chaque mois de l’année 2025, le total d’emprunts effectués.

<div align="center"> <img src="image/image9.jpg" alt="Résultat image9" width="1000"/> <p><em>Figure 9</em></p> </div>

#### Repérer les ouvrages jamais empruntés et compter leur nombre.

<div align="center"> <img src="image/image10.jpg" alt="Résultat image10" width="1000"/> <p><em>Figure 10</em></p> </div>

#### Expliquant l’intérêt de chaque type d’agrégation pour le reporting en bref

Les fonctions d’agrégation permettent de synthétiser de grands volumes de données en indicateurs lisibles et exploitables.
Les fonctions comme COUNT et AVG servent à mesurer l’activité (nombre d’emprunts, moyenne par période ou par abonné).
La clause GROUP BY aide à analyser les indicateurs par catégorie, comme le jour, le mois, l’abonné ou l’auteur. La clause HAVING garde seulement les groupes qui comptent vraiment.
Les jointures et les agrégations donnent une vue d’ensemble sur l’activité de la bibliothèque. Les jointures et les agrégations permettent de suivre les performances et d’aider à prendre des décisions.

## La partie exercice

### Résultat visuel 

<div align="center"> <img src="image/image11.jpg" alt="Résultat image11" width="1000"/> <p><em>Figure 11</em></p> </div>





