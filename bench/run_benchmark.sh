#!/bin/bash
# Lance les 8 requêtes du benchmark sur un niveau et note les temps.
# Usage : ./run_benchmark.sh <n0|n1|n2|n3|n4> [nb_passages, 3 par défaut]
# Résultats ajoutés dans resultats/temps.csv
# (niveau;requete;passage;temps_hive_s;temps_total_s;statut)
NIVEAU=$1
PASSAGES=${2:-3}
URL="jdbc:hive2://localhost:10000"
cd "$(dirname "$0")"
mkdir -p resultats

case $NIVEAU in
  n0) DB=chu_n0;  SUFFIXE="" ;;
  n1) DB=chu_n1;  SUFFIXE="" ;;
  n2) DB=chu_dwh; SUFFIXE="" ;;
  n3) DB=chu_n3;  SUFFIXE="" ;;
  n4) DB=chu_dwh; SUFFIXE="_n4" ;;
  *)  echo "Niveau inconnu : $NIVEAU (n0, n1, n2, n3 ou n4)"; exit 1 ;;
esac

[ -f resultats/temps.csv ] || echo "niveau;requete;passage;temps_hive_s;temps_total_s;statut" > resultats/temps.csv

for n in 1 2 3 4 5 6 7 8; do
  FICHIER="requetes/q${n}${SUFFIXE}.sql"
  for p in $(seq 1 $PASSAGES); do
    echo ">>> $NIVEAU  Q$n  passage $p/$PASSAGES ..."
    DEBUT=$(date +%s.%N)
    SORTIE=$(beeline -u "$URL" -n cloudera --hivevar DB=$DB -i reglages_session.sql -f "$FICHIER" 2>&1)
    FIN=$(date +%s.%N)
    TOTAL=$(awk "BEGIN{printf \"%.1f\", $FIN - $DEBUT}")
    # temps donné par Hive ("... rows selected (xx.xxx seconds)")
    HIVE=$(echo "$SORTIE" | grep -o 'selected ([0-9.]* seconds)' | tail -1 | grep -o '[0-9.]*')
    if echo "$SORTIE" | grep -q "Error:"; then STATUT="ERREUR"; else STATUT="OK"; fi
    echo "$NIVEAU;Q$n;$p;$HIVE;$TOTAL;$STATUT" >> resultats/temps.csv
    # sortie complète gardée pour vérifier les résultats
    echo "$SORTIE" > "resultats/${NIVEAU}_q${n}_passage${p}.txt"
    echo "    Hive : ${HIVE:-?} s   total : $TOTAL s   $STATUT"
  done
done
echo "Terminé. Temps dans resultats/temps.csv"
