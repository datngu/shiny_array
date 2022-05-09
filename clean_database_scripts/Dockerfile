FROM rocker/shiny:4.0.2


RUN apt-get update
RUN apt-get install -y \
    libcurl4-gnutls-dev \
    libssl-dev \
    r-cran-htmltools \
    tabix \
    git

RUN R -e "install.packages('markdown',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('rmarkdown',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('shinythemes',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('ggplot2',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('data.table',dependencies=TRUE, repos='http://cran.rstudio.com/')"

RUN git clone https://github.com/datngu/shiny_array.git
RUN mv shiny_array /srv/shiny-server
RUN mkdir /srv/shiny-server/shiny_array/work
RUN chown shiny:shiny /srv/shiny-server/shiny_array/work

# run app
CMD ["/usr/bin/shiny-server"]

