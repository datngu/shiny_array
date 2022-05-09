### What is this?

This is a web application that helps researchers find the most suitable SNP array based on their targeted population ancestry and variants of interest.

The application includes 2 main modules, they can be used to investigate tag SNP contents and imputation performances of 23 human genotyping used in our study.

### Array Contents

The key function of this module is to analyze array manifests and your targeted variant lists/regions to assist you to choose the most suitable array for their studies.
 
You can give the web application input by ***pasting / uploading*** a list of variants including in format ***"chr:position"***. The application will return summary statistics to show which array contains the highest number of your targeted variant lists. You can also provide input as a ***genomic region (HG38 coordinate)***, in format ***"chr:start_pos-end_pos"***, the application will return summary statistics showing which array contains the highest number of your targeted genomic region. You can also obtain the detailed information of tag SNPs for each array by clicking to "Download button" at the end of the page.


### Imputation performances

The key function of this module is to analyze imputation performances of 23 examined arrays in targeted genomic regions and populations that are provided by the users.

You need to provide input as a ***genome region (HG38 coordinate)***, in format ***"chr:start_pos-end_pos"***, and select your ***targeted population***, the application will return a summary statistics show which array show the highest imputation accuracy (measured by mean imputation accuracy r2) of your targeted genomic region. You can also obtain detailed information of imputation performances for each array by clicking to "Download button" at the end of the page.

It is not that analyses provided by this web application are restricted to variants with MAF >= 0.01.

### FQA:
Question: 
Do the application support rsID?

Answer:
Unfortunately not! It is because the underlying implementation uses tabix indexing for a high-speed query variant set. Tabix only supports sorted coordinates, so we can't support rsID searching.

Question: 
Which genome version is supported?

Answer:
We currently support only HG38.

### References
1. TBA