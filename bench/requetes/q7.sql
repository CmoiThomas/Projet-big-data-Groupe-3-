-- Q7 (B7) Nombre de décès par région en 2019
USE ${hivevar:DB};
SELECT l.nom_region, COUNT(*) AS nbre_deces
FROM fait_deces f JOIN dim_localisation l ON l.sk_localisation = f.sk_localisation
WHERE f.annee = 2019
GROUP BY l.nom_region
ORDER BY nbre_deces DESC LIMIT 100;
