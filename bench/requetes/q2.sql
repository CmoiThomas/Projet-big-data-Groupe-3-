-- Q2 (B2) Part des consultations par diagnostic en 2019 (10 premiers)
USE ${hivevar:DB};
SELECT d.code_diag, d.libelle, c.nb AS nbre_consultation,
       ROUND(100 * c.nb / t.total, 3) AS part_pct
FROM (SELECT sk_diagnostic, COUNT(*) AS nb FROM fait_consultation
      WHERE annee = 2019 GROUP BY sk_diagnostic) c
JOIN dim_diagnostic d ON d.sk_diagnostic = c.sk_diagnostic
CROSS JOIN (SELECT COUNT(*) AS total FROM fait_consultation WHERE annee = 2019) t
ORDER BY nbre_consultation DESC LIMIT 10;
