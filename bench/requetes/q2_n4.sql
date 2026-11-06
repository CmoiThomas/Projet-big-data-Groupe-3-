-- Q2 (B2) sur les tables d'agrégats
USE ${hivevar:DB};
SELECT d.code_diag, d.libelle, m.nbre_consultation,
       ROUND(100 * m.nbre_consultation / t.total, 3) AS part_pct
FROM mesure_consultation_diagnostic m
JOIN dim_diagnostic d ON d.sk_diagnostic = m.sk_diagnostic
CROSS JOIN (SELECT SUM(nbre_consultation) AS total FROM mesure_consultation_diagnostic WHERE annee = 2019) t
WHERE m.annee = 2019
ORDER BY nbre_consultation DESC LIMIT 10;
