
mkdir clean_data
pop_list="EAS SAS EUR AMR VNP AFR"

for pop in $pop_list
do
  for i in {1..22}
  do
    python3 clean_file.py chr${i}_${pop}_merged_23_array_correlation.txt.gz clean_data/chr${i}_${pop}.txt
  done
done


pop_list="EAS SAS EUR AMR VNP AFR"
for pop in $pop_list
do
  for i in {1..22}
  do
    cat clean_data/chr${i}_${pop}.txt >> ${pop}.txt
  done
  bgzip -f ${pop}.txt
  tabix -b 2 -e 2 ${pop}.txt.gz
done

pop_list="EAS SAS EUR AMR VNP AFR"
mkdir chr20
for pop in $pop_list
do
  cat clean_data/chr20_${pop}.txt > chr20/${pop}.txt
  bgzip -f chr20/${pop}.txt
  tabix -b 2 -e 2 chr20/${pop}.txt.gz
done


########## server

git clone https://github.com/datngu/shiny_array.git

cd /srv/shiny-server
sudo cp ~/shiny_array .

sudo chown shiny:shiny /var/shiny-server/www/shiny_test/work


# install packages by sudo
sudo su - -c "R -e \"install.packages('markdown', repos='http://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages('rmarkdown', repos='http://cran.rstudio.com/')\""











