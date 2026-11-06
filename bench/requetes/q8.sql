-- Q8 (B8) Satisfaction moyenne par région en 2020, pondérée par les répondants
USE ${hivevar:DB};
SELECT l.nom_region, COUNT(*) AS nbre_etablissements, SUM(f.nb_repondants) AS total_repondants,
       ROUND(SUM(f.score * f.nb_repondants) / SUM(f.nb_repondants), 2) AS score_pondere
FROM fait_satisfaction f JOIN dim_localisation l ON l.sk_localisation = f.sk_localisation
WHERE f.annee = 2020 AND f.score IS NOT NULL
GROUP BY l.nom_region
ORDER BY score_pondere DESC LIMIT 100;
