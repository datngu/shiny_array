

if(!require(shiny)){
    install.packages("shiny")
    library(shiny)
}

if(!require(shinythemes)){
    install.packages("shinythemes")
    library(shinythemes)
}

if(!require(data.table)){
    install.packages("data.table")
    library(data.table)
}

if(!require(ggplot2)){
    install.packages("ggplot2")
    library(ggplot2)
}

if(!require(rmarkdown)){
    install.packages("rmarkdown")
    library(rmarkdown)
}


####################################
# Loading data default             #
####################################

## setting

# array_db_path = "/srv/shiny-server/shiny_array/data/db_array.txt.gz"
# imputation_db_path = "/srv/shiny-server/shiny_array/data/"
# default_snp = fread("/srv/shiny-server/shiny_array/data/default.txt", sep = ":", header = FALSE)
# sudo mkdir /srv/shiny-server/shiny_array/work
# sudo rm /srv/shiny-server/shiny_array/work/*
# sudo chown shiny:shiny /srv/shiny-server/shiny_array/work

array_db_path = "data/db_array.txt.gz"
imputation_db_path = "data/"
default_snp = fread("data/default.txt", sep = ":", header = FALSE)
system("mkdir work")
system("rm work/*")


SNV_region_string_default = "20:500000-800000"


plot_fun <- function(df, n){
    ggplot(data = df, aes(x=array, y=percentage)) +
        geom_bar(stat="identity", fill="steelblue")+
        geom_text(aes(label= count), vjust=-0.3, size=3.5)+
        theme_light() + guides(x = guide_axis(angle = 90)) + 
        scale_y_continuous(breaks=seq(0,100,10), limits = c(0,100) ) + 
        ylab("Percentage SNP in array / Total SNP query") +  xlab("") + 
        ggtitle(paste0("Total SNP query: ", n))
}

plot_fun_imp <- function(df, n){
  ggplot(data = df, aes(x = array, y = mean_imputation_accuracy)) +
    geom_bar(stat="identity", fill="steelblue")+
    theme_light() + guides(x = guide_axis(angle = 90)) + 
    scale_y_continuous(breaks=seq(0,1,0.05), limits = c(0,1) ) + 
    ylab("Mean imputation r2 of query SNPs") +  xlab("") + 
    ggtitle(paste0("Total SNP query: ", n))
}


####################################
# User Interface                   #
####################################
ui <- fluidPage(
    
    theme = shinytheme("cerulean"),
    
    navbarPage("Array evaluator",
               
               
               tabPanel("Array Contents",
                        
                        sidebarPanel(
                            textInput(inputId = "SNV_region", label = "Paste a region:", placeholder = "20:500000-800000"),
                            HTML("<h4>OR</h4>"),
                            
                            textAreaInput(inputId = "SNV_pasted", label = "Paste SNV IDs:", placeholder = "1:20000\n2:40000\n22:50000", height = "400px", width = "100%"),
                            HTML("<h4>OR</h4>"),
                            
                            fileInput("file_in", "Upload file", accept = ".txt"),
                            #checkboxInput("header", "Header", TRUE),
                            
                            HTML("<h5>ONLY accept txt file with each line is one SNV in chr:position format.</h5>"),
                            actionButton(inputId = "submitbutton", label = "Submit", class = "btn btn-primary")
                        ),
                        
                        mainPanel(
                            tags$label(h3('Server status')),
                            hr(),
                            verbatimTextOutput('contents'),
                            hr(),
                            tags$label(h3('SNP array content plot')),
                            plotOutput("plot", width="100%", height = "600px"),
                            hr(),
                            tags$label(h3('SNP array content statistics')),
                            tableOutput('tabledata'),
                            hr(),
                            tags$label(h3('Download array content information')),
                            tags$label(h3('\n')),
                            downloadButton("downloadData", "Download"),
                            tags$label(h3('\n')),
                            hr(),
                        ),
                        
                        hr(),
                        tags$footer("Written by Dat Thanh Nguyen.", align = "center"),
                        tags$footer("Copyright (c) 2022", align = "center"),
                        tags$footer(tags$a(href="https://github.com/datngu/shiny_array", "Fork on GitHub.", target = "_blank"), align = "center")
               ),
               
               tabPanel("Imputation Performances",
                        
                        sidebarPanel(
                            selectInput("dataset", "Choose a dataset:",
                            choices = c("EAS", "AMR", "AFR", "EUR", "SAS", "VNP")),

                            textInput(inputId = "SNV_region_imp", label = "Paste a region:", value = "20:500000-800000"),
                            #HTML("<h4>OR</h4>"),
                            
                            #textAreaInput(inputId = "SNV_pasted_imp", label = "Paste SNV IDs:", placeholder = "1:20000\n2:40000\n22:50000", height = "400px", width = "100%"),
                            #HTML("<h4>OR</h4>"),
                            
                            #fileInput("file_in_imp", "Upload file", accept = ".txt"),
                            #checkboxInput("header", "Header", TRUE),
                            
                            #HTML("<h5>ONLY accept txt file with each line is one SNV in chr:position format.</h5>"),
                            actionButton(inputId = "submitbutton_imp", label = "Submit", class = "btn btn-primary")
                        ),
                        
                        mainPanel(
                            tags$label(h3('Server status')),
                            hr(),
                            verbatimTextOutput('contents_imp'),
                            hr(),
                            tags$label(h3('SNP array imputation accuracy plot')),
                            plotOutput("plot_imp", width="100%", height = "600px"),
                            hr(),
                            tags$label(h3('SNP array imputation accuracy statistics')),
                            tableOutput('tabledata_imp'),
                            hr(),
                            tags$label(h3('Download array imputation accuracy information')),
                            tags$label(h3('\n')),
                            downloadButton("downloadData_imp", "Download"),
                            tags$label(h3('\n')),
                            hr(),
                        ),
                        
                        hr(),
                        tags$footer("Written by Dat Thanh Nguyen.", align = "center"),
                        tags$footer("Copyright (c) 2022", align = "center"),
                        tags$footer(tags$a(href="https://github.com/datngu/shiny_array", "Fork on GitHub.", target = "_blank"), align = "center")
               ),
               
               tabPanel("About", 
                        titlePanel("About"), 
                        div(includeMarkdown("about.md"), 
                        align="justify"),
                        hr(),
                        tags$footer("Written by Dat Thanh Nguyen.", align = "center"),
                        tags$footer("Copyright (c) 2022", align = "center"),
                        tags$footer(tags$a(href="https://github.com/datngu/shiny_array", "Fork on GitHub.", target = "_blank"), align = "center")
               )
    )
)


####################################
# Server                           #
####################################
server <- function(input, output, session) {
    
    ### ARRAY PHYSICAL CONTENTS
    # Input Data
    datasetInput <- reactive({  
        
        if(nchar(input$SNV_region) > 2){
            
            SNV_region_string = input$SNV_region
            if(substring(SNV_region_string, nchar(SNV_region_string)) == "\n") SNV_region_string = substring(SNV_region_string, 1, nchar(SNV_region_string)-1)
            #cmd = paste0("tabix array_db/db_array.txt.gz ",  SNV_region_string, " > results.txt")
            cmd = paste0("tabix ", array_db_path, " ",  SNV_region_string, " > results.txt")
            system(cmd)
            
        }else{
            
            if(nchar(input$SNV_pasted) > 2){
                pasted_string = input$SNV_pasted
                if(substring(pasted_string, nchar(pasted_string)) != "\n") pasted_string = paste0(pasted_string, "\n")
                df = fread(pasted_string, sep = ":")
            }else{
                df = fread(input$file_in$datapath, sep = ":")
            }
            fwrite(df, file = "work/SNV_list.tsv", sep = "\t", col.names = F, row.names = F)

            cmd = paste0("tabix ", array_db_path, " -R work/SNV_list.tsv > work/results.txt")
            system(cmd)
            
        }
        
        x = fread("work/results.txt")
        
        array_info = fread("array_size.txt")
        array_names = array_info$array
        cols = c("chr", "pos", "id", array_names)
        
        colnames(x) = cols
        n = 1
        n = ifelse(nrow(x) > 1 , nrow(x), 1)
        t = colSums(x[,..array_names])
        df = data.frame( array = names(t), count = t, percentage = t*100/n)
        df$count = as.integer(df$count)
        od = order(df$count, decreasing = T)
        df = df[od,]
        #fwrite(df, file = "result_statistics.tsv", sep = "\t", row.names = F)
        res = list(df = df, n = n, array_tag_snp = x)
        print(res)
    })
    
    
    
    # Input Data default
    datasetInput_default <- reactive({  
        
        df = default_snp
        
        fwrite(df, file = "work/default_SNV_list.tsv", sep = "\t", col.names = F, row.names = F)

        cmd = paste0("tabix ", array_db_path, " -R work/default_SNV_list.tsv > work/default_results.txt")
        system(cmd)
        
        x = fread("work/default_results.txt")
        
        array_info = fread("array_size.txt")
        array_names = array_info$array
        cols = c("chr", "pos", "id", array_names)
        
        colnames(x) = cols
        n = 1
        n = ifelse(nrow(x) > 1 , nrow(x), 1)
        t = colSums(x[,..array_names])
        df = data.frame( array = names(t), count = t, percentage = t*100/n)
        df$count = as.integer(df$count)
        od = order(df$count, decreasing = T)
        df = df[od,]
        #fwrite(df, file = "result_statistics.tsv", sep = "\t", row.names = F)
        res = list(df = df, n = n, array_tag_snp = x)
        print(res)
    })
    
    tag_snp_plot <- reactive({
        plot_fun(datasetInput()$df, datasetInput()$n)
    })
    
    
    tag_snp_plot_default <- reactive({
        plot_fun(datasetInput_default()$df, datasetInput_default()$n)
    })
    
    
    server_status <- reactive({
        if(nchar(input$SNV_region) > 2){
            text = paste0("Viewing your pasted region:\n", input$SNV_region)
        }else if(nchar(input$SNV_pasted) > 2){
            text = paste0("Viewing your pasted variants:\n", input$SNV_pasted)
        }else if(nrow(datasetInput()$df) >= 1){
            text = paste0("Viewing your uploaded file:\n", input$file_in[1])
        }else{
            text = "There are some errors! Please check again!"
        }
        print(text)
    })
    
    # Status/Output Text Box
    output$contents <- renderText({
        if (input$submitbutton>0) { 
            out_text = server_status()
            isolate(out_text) 
        } else {
            out_text = "Viewing default setting!"
            isolate(out_text)
        }
    })
    
    
    
    # results table
    output$tabledata <- renderTable({
        if (input$submitbutton>0) { 
            isolate(datasetInput()$df) 
        }else{
            isolate(datasetInput_default()$df) 
        } 
    })
    
    # results plot
    output$plot <- renderPlot({
        if (input$submitbutton>0) { 
            isolate(tag_snp_plot()) 
        }else{
            isolate(tag_snp_plot_default())
        } 
    })
    
    
    Array_tag_snp <- reactive({
        if (input$submitbutton>0) { 
            x = datasetInput()$array_tag_snp
        }else{
            x = datasetInput_default()$array_tag_snp
        } 
        print(x)
    })
    
    output$downloadData <- downloadHandler(
        filename = "array_tagSNP_infomation.txt",
        content = function(file) {
            write.table(Array_tag_snp(), file, sep = "\t", quote = FALSE ,row.names = FALSE)
        }
    )

    ### ARRAY IMPUTATION PERFORMANCES

    # Input Data
    datasetInput_imp <- reactive({  

        db_path = paste0(imputation_db_path, input$dataset, ".txt.gz")
        
        #SNV_region_string = input$SNV_region_imp
        cmd = paste0("tabix ", db_path, " ",  input$SNV_region_imp, " > work/imp_results.txt")
        system(cmd)  
        
        x = fread("work/imp_results.txt")

        colnames(x) = c("chr", "pos", "ID", "AF", "MAF", "AC", "Axiom_GW_ASI", "Axiom_GW_CHB", "Axiom_GW_EUR", "Axiom_GW_PanAFR", "Axiom_JAPONICA", "infinium-omnizhonghua-v1.4", "infinium-psycharray-v1.3", "japanese-screening-array-v1.0", "multi-ethnic-eur-eas-sas-v1.0", "multi-ethnic-global-v1.0", "oncoarray-500k", "Axiom_PMDA", "Axiom_PMRA", "Axiom_UKB_WCSG", "chinese-genotyping-array-v1.0", "cytosnp-850k-v1.2", "global-screening-array-v.3", "human-cytosnp-12-v2.1", "infinium-core-v1.2", "infinium-global-diversity-array-v1.0", "infinium-omni2.5.v1.5", "infinium-omni5-v1.2", "GenomeWideSNP_6.0")
        
        x = as.data.frame(x)
        
        # square imputation correlations
        x1 = x[,c(1:6)]
        x2 = x[,c(7:29)]^2
        x = cbind(x1,x2)
        array_names = names(x2)
        t = colMeans(x2, na.rm = T)

        n = 1
        n = ifelse(nrow(x) > 1 , nrow(x), 1)
        df = data.frame( array = names(t), mean_imputation_accuracy = t)
        od = order(df$mean_imputation_accuracy, decreasing = T)
        df = df[od,]
        #fwrite(df, file = "result_statistics.tsv", sep = "\t", row.names = F)
        res = list(df = df, n = n, array_imp_snp = x)
        print(res)
    })
    
    
    
    # Input Data default
    datasetInput_default_imp <- reactive({
        
        db_path = paste0(imputation_db_path, input$dataset, ".txt.gz")     
        cmd = paste0("tabix ", db_path, " ",  SNV_region_string_default, " > work/imp_default_results.txt")
        system(cmd)

        x = fread("work/imp_default_results.txt")

        colnames(x) = c("chr", "pos", "ID", "AF", "MAF", "AC", "Axiom_GW_ASI", "Axiom_GW_CHB", "Axiom_GW_EUR", "Axiom_GW_PanAFR", "Axiom_JAPONICA", "infinium-omnizhonghua-v1.4", "infinium-psycharray-v1.3", "japanese-screening-array-v1.0", "multi-ethnic-eur-eas-sas-v1.0", "multi-ethnic-global-v1.0", "oncoarray-500k", "Axiom_PMDA", "Axiom_PMRA", "Axiom_UKB_WCSG", "chinese-genotyping-array-v1.0", "cytosnp-850k-v1.2", "global-screening-array-v.3", "human-cytosnp-12-v2.1", "infinium-core-v1.2", "infinium-global-diversity-array-v1.0", "infinium-omni2.5.v1.5", "infinium-omni5-v1.2", "GenomeWideSNP_6.0")
        
        x = as.data.frame(x)
        
        # square imputation correlations
        x1 = x[,c(1:6)]
        x2 = x[,c(7:29)]^2
        x = cbind(x1,x2)
        array_names = names(x2)
        t = colMeans(x2, na.rm = T)

        n = 1
        n = ifelse(nrow(x) > 1 , nrow(x), 1)
        df = data.frame( array = names(t), mean_imputation_accuracy = t)
        od = order(df$mean_imputation_accuracy, decreasing = T)
        df = df[od,]
        #fwrite(df, file = "result_statistics.tsv", sep = "\t", row.names = F)
        res = list(df = df, n = n, array_imp_snp = x)
        print(res)
    })
    
    tag_snp_plot_imp <- reactive({
        plot_fun_imp(datasetInput_imp()$df, datasetInput_imp()$n)
    })
    
    
    tag_snp_plot_default_imp <- reactive({
        plot_fun_imp(datasetInput_default_imp()$df, datasetInput_default_imp()$n)
    })
    
    
    
    # Status/Output Text Box
    output$contents_imp <- renderText({
        if (input$submitbutton_imp > 0) { 
            out_text = paste0("Viewing your selected region:\n", input$SNV_region_imp)
            isolate(out_text) 
        } else {
            out_text = paste0("Viewing default setting region:\n", SNV_region_string_default)
            isolate(out_text)
        }
    })
    
    
    
    # results table
    output$tabledata_imp <- renderTable({
        if (input$submitbutton_imp > 0) { 
            isolate(datasetInput_imp()$df) 
        }else{
            isolate(datasetInput_default_imp()$df) 
        } 
    })
    
    # results plot
    output$plot_imp <- renderPlot({
        if (input$submitbutton_imp > 0) { 
            isolate(tag_snp_plot_imp()) 
        }else{
            isolate(tag_snp_plot_default_imp())
        } 
    })
    
    Array_imp_snp <- reactive({
        if (input$submitbutton_imp > 0) { 
            x = datasetInput_imp()$array_imp_snp
        }else{
            x = datasetInput_default_imp()$array_imp_snp
        } 
        print(x)
    })
    
    
    output$downloadData_imp <- downloadHandler(
        filename = "array_imputation_performance.txt",
        content = function(file) {
            write.table(Array_imp_snp(), file, sep = "\t", quote = FALSE ,row.names = FALSE)
        }
    )
    
}


####################################
# Create Shiny App                 #
####################################
shinyApp(ui = ui, server = server)















