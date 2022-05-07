

library(shiny)
library(shinythemes)
library(data.table)
library(ggplot2)
library(rmarkdown)


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
        hr(),
        plotOutput("plot", width="100%", height = "600px"),
        hr(),
        tags$label(h3('SNP array content statistics')),
        hr(),
        tableOutput('tabledata'),
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
  
  # Status/Output Text Box
  output$contents <- renderText({
    if (input$submitbutton>0) { 
      out_text = "Calculation completed."
      isolate(out_text) 
    } else {
      out_text = "Viewing defaut setting:"
      isolate(out_text)
    }
  })
  
  #input= list()

  #input$SNV_region = "1:2000-400000"

  # Input Data
  datasetInput <- reactive({  
    
    if(nchar(input$SNV_region) > 2){

      SNV_region_string = input$SNV_region
      if(substring(SNV_region_string, nchar(SNV_region_string)) == "\n") SNV_region_string = substring(SNV_region_string, 1, nchar(SNV_region_string)-1)
      cmd = paste0("tabix db_array.txt.gz ",  SNV_region_string, " > results.txt")
      system(cmd)

    }else{

      if(nchar(input$SNV_pasted) > 2){
        pasted_string = input$SNV_pasted
        if(substring(pasted_string, nchar(pasted_string)) != "\n") pasted_string = paste0(pasted_string, "\n")
        df = fread(pasted_string, sep = ":")
      }else{
        df = fread(input$file_in, sep = ":")
      }
      fwrite(df, file = "SNV_list.tsv", sep = "\t", col.names = F, row.names = F)
      cmd = "tabix db_array.txt.gz -R SNV_list.tsv > results.txt"
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
    res = list(df = df, n = n)
    print(res)
  })

  tag_snp_plot <- reactive({
    ggplot(data= datasetInput()$df, aes(x=array, y=percentage)) +
    geom_bar(stat="identity", fill="steelblue")+
    geom_text(aes(label= count), vjust=-0.3, size=3.5)+
    theme_light() + guides(x = guide_axis(angle = 90)) + scale_y_continuous(breaks=seq(0,100,10), limits = c(0,100) ) + ylab("Percentage SNP in array / Total SNP query") +  xlab("") + ggtitle(paste0("Total SNP query: ", datasetInput()$n))
  })

  

  # Prediction results table
  output$tabledata <- renderTable({
    if (input$submitbutton>0) { 
      isolate(datasetInput()$df) 
    } 
  })

  output$plot <- renderPlot({
    if (input$submitbutton>0) { 
      isolate(tag_snp_plot()) 
    } 
  })
  
}


####################################
# Create Shiny App                 #
####################################
shinyApp(ui = ui, server = server)