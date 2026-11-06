-- Q1 (B1) sur les tables d'agrégats
USE ${hivevar:DB};
SELECT e.raison_sociale_site, e.nom_region, m.nbre_consultation,
       ROUND(100 * m.nbre_consultation / t.total, 3) AS part_pct
FROM mesure_consultation_etablissement m
JOIN dim_etablissement e ON e.sk_etablissement = m.sk_etablissement
CROSS JOIN (SELECT SUM(nbre_consultation) AS total FROM mesure_consultation_etablissement WHERE annee = 2020) t
WHERE m.annee = 2020 AND m.sk_etablissement > 0
ORDER BY nbre_consultation DESC LIMIT 10;
