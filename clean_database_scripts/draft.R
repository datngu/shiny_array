
input = list()
input$dataset = "EAS"

db_path = paste0(imputation_db_path, input$dataset, ".txt.gz")     
SNV_region_string = "22:5000-10000000"
cmd = paste0("tabix ", db_path, " ",  SNV_region_string, " > imp_default_results.txt")
system(cmd)