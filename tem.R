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


"chr", "pos", "ID", "AF", "MAF", "AC", "Axiom_GW_ASI", "Axiom_GW_CHB", "Axiom_GW_EUR", "Axiom_GW_PanAFR", "Axiom_JAPONICA", "infinium-omnizhonghua-v1.4", "infinium-psycharray-v1.3", "japanese-screening-array-v1.0", "multi-ethnic-eur-eas-sas-v1.0", "multi-ethnic-global-v1.0", "oncoarray-500k", "Axiom_PMDA", "Axiom_PMRA", "Axiom_UKB_WCSG", "chinese-genotyping-array-v1.0", "cytosnp-850k-v1.2", "global-screening-array-v.3", "human-cytosnp-12-v2.1", "infinium-core-v1.2", "infinium-global-diversity-array-v1.0", "infinium-omni2.5.v1.5", "infinium-omni5-v1.2", "GenomeWideSNP_6.0"