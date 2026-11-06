-- Q1 (B1) Part des consultations par établissement en 2020 (10 premiers)
USE ${hivevar:DB};
SELECT e.raison_sociale_site, e.nom_region, c.nb AS nbre_consultation,
       ROUND(100 * c.nb / t.total, 3) AS part_pct
FROM (SELECT sk_etablissement, COUNT(*) AS nb FROM fait_consultation
      WHERE annee = 2020 GROUP BY sk_etablissement) c
JOIN dim_etablissement e ON e.sk_etablissement = c.sk_etablissement
CROSS JOIN (SELECT COUNT(*) AS total FROM fait_consultation WHERE annee = 2020) t
WHERE e.sk_etablissement > 0
ORDER BY nbre_consultation DESC LIMIT 10;
