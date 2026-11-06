# Benchmark

Comparaison de plusieurs façons de stocker l'entrepôt, sur les 8 requêtes d'analyse (B1 à B8).

| Niveau | Base | Stockage | Script |
|---|---|---|---|
| N0 | `chu_n0` | texte brut | `01_niveau_N0_brut.sql` |
| N1 | `chu_n1` | ORC | `02_niveau_N1_orc.sql` |
| N2 | `chu_dwh` | ORC + faits partitionnés par année (entrepôt actuel) | - |
| N3 | `chu_n3` | N2 + partitions sur les dimensions + buckets | `03_niveau_N3_partition_bucket.sql` |
| N4 | `chu_dwh` | tables d'agrégats `mesure_*` | `04_niveau_N4_agregats.sql` |

- `requetes/q1.sql` à `q8.sql` : les requêtes de test, identiques de N0 à N3
- `requetes/q*_n4.sql` : les mêmes requêtes sur les tables d'agrégats
- `reglages_session.sql` : réglages Hive chargés à chaque session
- `run_benchmark.sh` : lance les requêtes et note les temps dans `resultats/temps.csv`

## Lancer

Sur la VM, dans ce dossier :

```bash
BL="beeline -u jdbc:hive2://localhost:10000 -n cloudera -i reglages_session.sql"
$BL -f 02_niveau_N1_orc.sql      # créer un niveau
./run_benchmark.sh n1 2          # le mesurer (2 passages par requête)
```

Lancer les niveaux un par un, sans autre traitement en parallèle (Talend, Power BI...), sinon les temps ne sont pas comparables.

Pour les volumes :

```bash
hdfs dfs -du -s -h /chu/bench/n0 /chu/bench/n1 /chu/dwh /chu/bench/n3 /chu/dwh/mesures
hdfs dfs -count /chu/bench/n0 /chu/bench/n1 /chu/dwh /chu/bench/n3 /chu/dwh/mesures
```

## Remarques

- Les lignes `ERREUR` de `temps.csv` correspondent aux premiers essais (Hive arrêté, manque de mémoire). Seules les lignes `OK` sont exploitées.
- Q5 échoue en N3 avec des conteneurs de 1 Go : `dim_patient` est éclatée en beaucoup de petits fichiers.
- Sur la VM, `hive.exec.submit.local.task.via.child=false` est nécessaire, sinon les jointures en mémoire échouent (erreur `MapredLocalTask`).
