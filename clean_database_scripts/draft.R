library(bit64)

region = "20:500000-8000000000000"
chr = unlist(strsplit(region, ":"))[1]
range = unlist(strsplit(region, ":"))[2]
s = as.integer64(unlist(strsplit(range, "-"))[1])
e = as.integer64(unlist(strsplit(range, "-"))[2])

if( (e - s) < 1){
  e = s + 100000
}
if( (e - s) > 10000000){
  e = s + 10000000
}
region = paste0(chr, ":", s, "-", e)




input = list()
input$dataset = "EAS"

db_path = paste0(imputation_db_path, input$dataset, ".txt.gz")     
SNV_region_string = "22:5000-10000000"
cmd = paste0("tabix ", db_path, " ",  SNV_region_string, " > imp_default_results.txt")
system(cmd)


x = fread("work/imp_results.txt")

colnames(x) = c("chr", "pos", "ID", "AF", "MAF", "AC", "Axiom_GW_ASI", "Axiom_GW_CHB", "Axiom_GW_EUR", "Axiom_GW_PanAFR", "Axiom_JAPONICA", "infinium-omnizhonghua-v1.4", "infinium-psycharray-v1.3", "japanese-screening-array-v1.0", "multi-ethnic-eur-eas-sas-v1.0", "multi-ethnic-global-v1.0", "oncoarray-500k", "Axiom_PMDA", "Axiom_PMRA", "Axiom_UKB_WCSG", "chinese-genotyping-array-v1.0", "cytosnp-850k-v1.2", "global-screening-array-v.3", "human-cytosnp-12-v2.1", "infinium-core-v1.2", "infinium-global-diversity-array-v1.0", "infinium-omni2.5.v1.5", "infinium-omni5-v1.2", "GenomeWideSNP_6.0")

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

array_info = fread("array_size.txt")
df2 = df
df2$size = array_info$all_site[match(df2$array, array_info$array)]
df2$size = round(df2$size/1000,0)
od = order(df2$size, decreasing = F)
df2 = df2[od,]
df2$array_name = paste0(df2$array, "_", df2$size)
df2$array_name = as.factor(df2$array_name)
  
res = list(df = df, df2 = df2, n = n, array_imp_snp = x)
