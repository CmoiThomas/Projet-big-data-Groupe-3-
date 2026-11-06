-- Q8 (B8) sur les tables d'agrégats
USE ${hivevar:DB};
SELECT nom_region, nbre_etablissements, total_repondants, score_moyen_pondere
FROM mesure_satisfaction WHERE annee = 2020 AND total_repondants > 0
ORDER BY score_moyen_pondere DESC LIMIT 100;
