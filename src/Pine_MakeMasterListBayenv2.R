# KE Lotterhos
# Sept 20 2014
# Make Master List of bayenv2 results from Pine

setwd("/home/klott/indivCovMatPine/XTXBFresults")

# Read in list of locus names
  loci.names <- read.table("var_out_pine_all_COMBINED.table.contig_flt10.bayenv.loci", 
                           colClasses = c("numeric","character"),
                          col.names=c("Num", "Name"))
  outfile <- "var_out_pine_all_COMBINED.table.contig_flt10.bayenv.OUT_ALL.xtx.LOGbf.MAF.ED"
  str(loci.names)

# Read in list of environments  
  envi.names <- scan("enviNamesAllAnalyses.txt", what="character")

# Read in xtx results.  Notice that the dimensions here are not equal to the dim(loci.names) because bayenv2 failed sometimes
  xtx.bf <- read.table("var_out_pine_all_COMBINED.table.contig_flt10.bayenv.OUT_ALL.xtx.bf",
                          colClasses = c("character", "numeric", "character", rep("numeric", length(envi.names)*3)),
						fill = TRUE
                    )
#line 1363102 did not have 69 elements
	rm <- which(complete.cases(xtx.bf)==FALSE)  # rows with NA
	apply(apply(xtx.bf,2,is.na),2,sum) 
	
	xtx.bf2 <- xtx.bf
	xtx.bf <- xtx.bf[-rm,]
  dim(xtx.bf)
  str(xtx.bf)
str(xtx.bf[,1:10])

# Log-transform BF
	bfcols <- seq(4, ncol(xtx.bf), by=3)
	head(xtx.bf[,bfcols[1:3]])
	xtx.bf[,bfcols] <- log(xtx.bf[,bfcols])
	

# Make column names
  envi.names2 <- (matrix(c(paste(envi.names,".BF",sep=""), 
                          paste(envi.names,".rho1",sep=""),  
                          paste(envi.names,".rho2",sep="")
                          ), ncol=3))
  envi.names3 <- as.vector(t(envi.names2))
  colnames(xtx.bf) <- c("Name1", "XTX", "Name2", envi.names3)
  #  xtx.bf$XTX<-as.numeric(as.character(xtx.bf$XTX))
  str(xtx.bf$XTX)
  str(xtx.bf[,1:5])


# Is the dataset unique?
  length(unique(xtx.bf$Name1))==length(xtx.bf$Name1)
  length(unique(loci.names$Name))==length(loci.names$Name)

# Check to make sure all loci names are equal
  identical(xtx.bf[,1], xtx.bf[,3])

# reorder the matrices
  loci.names2 <- loci.names[order(loci.names$Name),]
  xtx.bf2 <- xtx.bf[order(xtx.bf$Name1),]

  loci.names2 <- cbind(loci.names2, matrix(NA, ncol=ncol(xtx.bf), nrow=nrow(loci.names)))
  colnames(loci.names2)[3:ncol(loci.names2)]<-  colnames(xtx.bf)
  str(loci.names2[,1:5])

  indexes <- which(loci.names2$Name %in% xtx.bf2$Name1)

# combine matrices
  loci.names2[indexes, 3:ncol(loci.names2)] <- xtx.bf2

# check they lined up right
  identical(loci.names2$Name[indexes], loci.names2$Name1[indexes])

# Append MAF
maf.df <- read.table("var_out_pine_all_COMBINED.table.contig_flt10.bayenv.MAF", header=TRUE)
loci.names3 <- data.frame(loci.names2, maf.df)
str(loci.names3)

  write.table(loci.names3,file = outfile, col.names = TRUE, row.names=FALSE)