
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
R -e "install.packages('bit64',dependencies=TRUE, repos='http://cran.rstudio.com/')"

git clone https://github.com/datngu/shiny_array.git
sudo mv shiny_array /srv/shiny-server
sudo mkdir /srv/shiny-server/shiny_array/work
sudo chown shiny:shiny /srv/shiny-server/shiny_array/work

/usr/bin/shiny-server





####### build by dockerfile
git clone https://github.com/datngu/shiny_array.git

cd shiny_array

docker build -t shiny-array:v0.0.0 -f Dockerfile .

docker run -it --rm -h shiny -p 3838:3838 -v /Users/datn/Downloads/chr20:/imputation_data --name shiny_array shiny-array:v0.0.0

## run in PC bdi
git clone https://github.com/datngu/shiny_array.git

cd shiny_array

docker build -t shiny-array:v0.0.0 -f Dockerfile .

docker run -it --rm -h shiny -p 3838:3838 -v /home/datn/NAS/DatNguyen/imputation_data:/imputation_data -v $PWD:/var/log/shiny-server/ --name shiny_array shiny-array:v0.0.0

http://localhost:3838/shiny_array/











