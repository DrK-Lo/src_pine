### Assumes that some code from ProcessBFXTX_Spruce.R is in memory
#cd /data/seqcap/spruce/bwa_pseudo/final_tables/bayenv2Results10nonimputed
loci.names <- read.table("var_out_588ind_all_v2_COMBINED.table.contig_flt10.bayenv.XTX.BF.ALL_truncate", header=TRUE)
impt.stats <- data.frame(XTX=loci.names[,4], log(loci.names[,  seq(6,69, by=3)]))


MultiD2 <- function(df.vars){
#df.vars is a dataframe with each row a locus and each column a statsitic
  mu <- t(t(colMeans(df.vars, na.rm=TRUE))) # make it a column vector
  S <- cov(df.vars, use="pairwise.complete.obs") #variance-covariance matrix
  
  D <- NULL
	for (i in 1:nrow(df.vars)){
    x <- t(df.vars[i,])
    diff <- x-mu
    D[i] <- sqrt( t(diff) %*% solve(S) %*% (diff) )
    if(i%%10000==0){print(c(i, D[i]))}
  }
  return(D)
}


head(impt.stats)

# in one screen
    # D.All <- MultiD2(impt.stats)
    # write(D.all, "var_out_588ind_all_v2_COMBINED.table.contig_flt10.bayenv.XTX.BF.ALL_truncate.DAll", 
    #      ncolumns=1)

# screen 2
  groups <- read.table("PearsonGroup.txt", header=TRUE)
  groups
  identical(as.character(groups$Var), colnames(impt.stats))
  g <- 4
  sub.dat <- impt.stats[,groups$Pearson.Group==g]
  D.PG <- MultiD2(sub.dat)
  write(D.PG, paste("var_out_588ind_all_v2_COMBINED.table.contig_flt10.bayenv.XTX.BF.ALL_truncate.DPG",g, sep=""), 
         ncolumns=1)