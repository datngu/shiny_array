
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

sudo mkdir /srv/shiny-server/shiny_array/work
sudo rm /srv/shiny-server/shiny_array/work/*
sudo chown shiny:shiny /srv/shiny-server/shiny_array/work

sudo systemctl restart shiny-server

# install packages by sudo
sudo apt-get install -y tabix
sudo su - -c "R -e \"install.packages('markdown', repos='http://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages('rmarkdown', repos='http://cran.rstudio.com/')\""



## build docker manually






##########

docker run -it --rm -h shiny -p 3838:3838 --name shiny_array rocker/shiny:4.0.2

apt update



apt-get update && apt-get install -y \
    libcurl4-gnutls-dev \
    libssl-dev \
    r-cran-htmltools \
    tabix \
    git


R -e "install.packages('markdown',dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('rmarkdown',dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('shinythemes',dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('ggplot2',dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('data.table',dependencies=TRUE, repos='http://cran.rstudio.com/')"

git clone https://github.com/datngu/shiny_array.git
sudo mv shiny_array /srv/shiny-server
sudo mkdir /srv/shiny-server/shiny_array/work
sudo chown shiny:shiny /srv/shiny-server/shiny_array/work

/usr/bin/shiny-server





####### build by dockerfile

docker build -t shiny-array:v0.0.0 -f Dockerfile .

docker run -it --rm -h shiny -p 3838:3838 --name shiny_array shiny-array:v0.0.0













