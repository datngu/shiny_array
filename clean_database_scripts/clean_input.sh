
mkdir clean_data
pop_list="EAS SAS EUR AMR VNP AFR"

for pop in $pop_list
do
  for i in {1..22}
  do
    python3 clean_file.py chr${i}_${pop}_merged_23_array_correlation.txt.gz clean_data/chr${i}_${pop}.txt
  done
  cat clean_data/chr*_${pop}.txt > all_${pop}.txt
  bgzip all_${pop}.txt
  tabix -b 2 -e 2 all_${pop}.txt.txt.gz
done
  