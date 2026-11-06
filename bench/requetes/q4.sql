-- Q4 (B4) Taux d'hospitalisation par diagnostic, toutes années (10 premiers)
-- patients hospitalisés pour X / patients ayant reçu le diagnostic X
USE ${hivevar:DB};
SELECT d.code_diag, d.libelle, h.nb_hosp AS patients_hospitalises, p.nb_pat AS patients_diagnostic,
       ROUND(100 * h.nb_hosp / p.nb_pat, 2) AS taux_pct
FROM (SELECT sk_diagnostic, COUNT(DISTINCT sk_patient) AS nb_hosp
      FROM fait_hospitalisation GROUP BY sk_diagnostic) h
JOIN (SELECT u.sk_diagnostic, COUNT(DISTINCT u.sk_patient) AS nb_pat
      FROM (SELECT sk_diagnostic, sk_patient FROM fait_consultation
            UNION ALL
            SELECT sk_diagnostic, sk_patient FROM fait_hospitalisation) u
      GROUP BY u.sk_diagnostic) p ON p.sk_diagnostic = h.sk_diagnostic
JOIN dim_diagnostic d ON d.sk_diagnostic = h.sk_diagnostic
ORDER BY patients_hospitalises DESC LIMIT 10;
