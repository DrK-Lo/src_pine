#setwd("/Users/katie/Desktop/AdaptreeData/spruce")

# ssh klott@hulk.zoology.ubc.ca
# cd /data/seqcap/pine/bwa_pseudo/final_tables


EditCovMat <- function(filename){
    npops<-length(scan(filename, skip=20, nlines=1))
	print(npops)
    np.text <- paste("-n", npops+1, sep="")
    outname <- paste(filename, "ED", sep="")
    system(paste("tail", np.text, filename, ">", outname))
}


filename <- "var_out_pine_all_COMBINED.table.contig_flt80.noncoding.bayenv.covmat"
#file <- read.table(filename)

npops <- 285 

EditCovMat(filename)  