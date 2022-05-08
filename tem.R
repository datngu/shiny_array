  tag_snp_plot <- reactive({

    ggplot(data= datasetInput()$df, aes(x=array, y=percentage)) +
    geom_bar(stat="identity", fill="steelblue")+
    geom_text(aes(label= count), vjust=-0.3, size=3.5)+
    theme_light() + guides(x = guide_axis(angle = 90)) + 
    scale_y_continuous(breaks=seq(0,100,10), limits = c(0,100) ) + 
    ylab("Percentage SNP in array / Total SNP query") +  xlab("") + 
    ggtitle(paste0("Total SNP query: ", datasetInput()$n))

  })


  tag_snp_plot_default <- reactive({

    ggplot(data= datasetInput_default()$df, aes(x=array, y=percentage)) +
    geom_bar(stat="identity", fill="steelblue")+
    geom_text(aes(label= count), vjust=-0.3, size=3.5)+
    theme_light() + guides(x = guide_axis(angle = 90)) + 
    scale_y_continuous(breaks=seq(0,100,10), limits = c(0,100) ) + 
    ylab("Percentage SNP in array / Total SNP query") +  xlab("") + 
    ggtitle(paste0("Total SNP query: ", datasetInput_default()$n))
    
  })