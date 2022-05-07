

library(shiny)
library(shinythemes)
library(data.table)


####################################
# User Interface                   #
####################################
ui <- fluidPage(
  
  theme = shinytheme("united"),
  
  navbarPage("SNP array selector",
    
    tabPanel("Home",
    
      sidebarPanel(
        #HTML("<h5>Copy/paste input:</h5>"),
        textAreaInput(inputId = "SNV_pasted", label = "Paste SNVs ID:", placeholder = "1:20000\n2:40000\n22:50000", height = "400px"),
        HTML("<h4>OR</h4>"),
        #HTML("<h5>Upload file input:</h5>"),
        fileInput("file_in", "Upload file", accept = ".tsv"),
        #checkboxInput("header", "Header", TRUE),
        #HTML("<h4>File requirements:</h4>"),
        HTML("<h5>ONLY accept tsv file with each line is one SNV in chr:position format.</h5>"),
        actionButton(inputId = "submitbutton", label = "Submit", class = "btn btn-primary")
      ),
                                    
      mainPanel(
        tags$label(h3('Status/Output')),
        "\nServer status",
        verbatimTextOutput('contents'),
        tableOutput('tabledata')
      ) 
    ),

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
    if(nchar(input$SNV_pasted) > 2){
      df = fread(input$SNV_pasted)
    }else{
      df = fread(input$file_in)
    }
    fwrite(df, file = "SNV_list.tsv", sep = "\t", col.names = F, row.names = F)
    cmd = "tabix -R SNV_list.tsv db_array.txt.gz > results.txt"
    res = fread("results.txt")
    print(res)
  })
  
  # Status/Output Text Box
  output$contents <- renderPrint({
    if (input$submitbutton>0) { 
      isolate("Calculation complete.") 
    } else {
      return("Server is ready for calculation.")
    }
  })
  
  # Prediction results table
  output$tabledata <- renderTable({
    if (input$submitbutton>0) { 
      isolate(datasetInput()) 
    } 
  })
  
}


####################################
# Create Shiny App                 #
####################################
shinyApp(ui = ui, server = server)