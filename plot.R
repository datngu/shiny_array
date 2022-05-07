setwd("/media/datn/data2gb/GitHub/R_shiny_SNP_array_comparison")

1:200-4000000

require(data.table)
require(ggplot2)

array_info = fread("array_size.txt")
array_names = array_info$array
cols = c("chr", "pos", "id", array_names)
x = fread("/media/datn/data2gb/GitHub/R_shiny_SNP_array_comparison/results.txt")
colnames(x) = cols
t = colSums(x[,..array_names])
df = data.frame( array = names(t), count = t, percentage = t*100/nrow(x))

ggplot(data= df, aes(x=array, y=percentage)) +
  geom_bar(stat="identity", fill="steelblue")+
  geom_text(aes(label= count), vjust=1.6, color="white", size=3.5)+
  theme_light() + guides(x = guide_axis(angle = 90)) + scale_y_continuous(breaks=seq(0,100,10), limits = c(0,100) ) + ylab("Percentage SNP in array / Total SNP query") +  xlab("") + ggtitle(paste0("Total SNP query: ", nrow(x)))
