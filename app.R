

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

default_snp = fread("default_db/default.txt", sep = ":", header = FALSE)

plot_fun <- function(df, n){
    ggplot(data = df, aes(x=array, y=percentage)) +
    geom_bar(stat="identity", fill="steelblue")+
    geom_text(aes(label= count), vjust=-0.3, size=3.5)+
    theme_light() + guides(x = guide_axis(angle = 90)) + 
    scale_y_continuous(breaks=seq(0,100,10), limits = c(0,100) ) + 
    ylab("Percentage SNP in array / Total SNP query") +  xlab("") + 
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
        textInput(inputId = "SNV_region", label = "Paste a region:", placeholder = "1:2000-400000"),
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
        tags$label(h3('Download array tag SNP information')),
        tags$label(h3('')),
        downloadButton("downloadData", "Download"),
        tags$label(h3('')),
        hr(),
      ),
      
      hr(),
      tags$footer("Written by Dat Thanh Nguyen.", align = "center"),
      tags$footer("Copyright (c) 2022", align = "center"),
      tags$footer(tags$a(href="https://github.com/datngu/shiny_array", "Fork on GitHub.", target = "_blank"), align = "center")
    ),
    
    # tabPanel("Imputation performance",
    
    #   sidebarPanel(
    #     textInput(inputId = "SNV_region", label = "Paste SNVs region:", placeholder = "1:20000-50000"),
    #     HTML("<h4>OR</h4>"),

    #     textAreaInput(inputId = "SNV_pasted", label = "Paste SNVs ID:", placeholder = "1:20000\n2:40000\n22:50000", height = "400px"),
    #     HTML("<h4>OR</h4>"),

    #     fileInput("file_in", "Upload file", accept = ".txt"),
    #     #checkboxInput("header", "Header", TRUE),

    #     HTML("<h5>ONLY accept txt file with each line is one SNV in chr:position format.</h5>"),
    #     actionButton(inputId = "submitbutton", label = "Submit", class = "btn btn-primary")
    #   ),
                                    
    #   mainPanel(
    #     tags$label(h3('Server status')),
    #     verbatimTextOutput('contents'),
    #     tableOutput('tabledata')
    #   ) 
    # ),

    tabPanel("About", 
      titlePanel("About"), 
      div(includeMarkdown("about.md"), 
      align="justify")
    )
  )
)


####################################
# Server                           #
####################################
server <- function(input, output, session) {
  

  # Input Data
  datasetInput <- reactive({  
    
    if(nchar(input$SNV_region) > 2){

      SNV_region_string = input$SNV_region
      if(substring(SNV_region_string, nchar(SNV_region_string)) == "\n") SNV_region_string = substring(SNV_region_string, 1, nchar(SNV_region_string)-1)
      cmd = paste0("tabix array_db/db_array.txt.gz ",  SNV_region_string, " > results.txt")
      system(cmd)

    }else{

      if(nchar(input$SNV_pasted) > 2){
        pasted_string = input$SNV_pasted
        if(substring(pasted_string, nchar(pasted_string)) != "\n") pasted_string = paste0(pasted_string, "\n")
        df = fread(pasted_string, sep = ":")
      }else{
        df = fread(input$file_in$datapath, sep = ":")
      }
      fwrite(df, file = "SNV_list.tsv", sep = "\t", col.names = F, row.names = F)
      cmd = "tabix array_db/db_array.txt.gz -R SNV_list.tsv > results.txt"
      system(cmd)
      
    }

    x = fread("results.txt")

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

    fwrite(df, file = "default_SNV_list.tsv", sep = "\t", col.names = F, row.names = F)
    cmd = "tabix array_db/db_array.txt.gz -R default_SNV_list.tsv > default_results.txt"
    system(cmd)

    x = fread("default_results.txt")

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
      text = "There are some errors in your input! Please check again!"
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
    x = datasetInput()$array_tag_snp
    print(x)
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


}


####################################
# Create Shiny App                 #
####################################
shinyApp(ui = ui, server = server)