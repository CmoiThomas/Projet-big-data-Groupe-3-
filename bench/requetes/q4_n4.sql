-- Q4 (B4) sur les tables d'agrégats
USE ${hivevar:DB};
SELECT d.code_diag, d.libelle, m.nbre_patients_hospitalises, m.nbre_patients_diagnostic,
       ROUND(100 * m.nbre_patients_hospitalises / m.nbre_patients_diagnostic, 2) AS taux_pct
FROM mesure_hospitalisation_diagnostic m
JOIN dim_diagnostic d ON d.sk_diagnostic = m.sk_diagnostic
ORDER BY nbre_patients_hospitalises DESC LIMIT 10;
