-- Q7 (B7) sur les tables d'agrégats
USE ${hivevar:DB};
SELECT nom_region, SUM(nbre_deces) AS nbre_deces
FROM mesure_deces WHERE annee = 2019
GROUP BY nom_region ORDER BY nbre_deces DESC LIMIT 100;
