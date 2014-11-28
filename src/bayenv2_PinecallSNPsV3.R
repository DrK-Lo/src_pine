#scp -r klott@rogue.zoology.ubc.ca:/data/seqcap/spruce/bwa_pseudo/final_tables/spruce_GBS_all.table.contig_flt10.bayenv* .
#scp -r klott@rogue.zoology.ubc.ca:/data/seqcap/spruce/bwa_pseudo/final_tables/var_out_spruce_all_beagle10_p99.tab.bayenv* .
#also transfer edited covariance matrix from laptop
 #var_out_588ind_all_v2_COMBINED.table.contig_flt80.noncoding.bayenv.covmatED.goodPops
#first source bayenv2_RemovePopsMissingData.R

args <- commandArgs(trailingOnly = TRUE) 
startSNP <- as.numeric(args[1])
endSNP <- as.numeric(args[2])
groupnum <- as.numeric(args[3])
rm(args)

#take argument for SNPpath

setwd("~/PineBayenv2_10nonimputed")
SNPpath<-"var_out_pine_all_COMBINED.table.contig_flt10.bayenv"
	# not yet edited for pops with missing envi

envipath1<-"var_out_pine_all_COMBINED.table.contig_flt10.bayenv.envi"
	#edited for pops with missing envi

covpath<- "var_out_pine_all_COMBINED.table.contig_flt10.bayenv.envi.finalcovmatED"
	#edited for pops with missing envi

SNPnames1 <- matrix(scan(paste(SNPpath,".loci", sep=""), skip=(startSNP-1), nlines=(endSNP-startSNP+1), what="character"), ncol=2, byrow=TRUE)
	#this takes about 10 minutes to read in
SNPnames<- SNPnames1[,2]

PopsMissingData <- "var_out_pine_all_COMBINED.table.contig_flt10.bayenv.envi.linesRemoved"

enviDims1 <- dim(read.table(envipath1))
npops <- enviDims1[2]
nenvi1 <- enviDims1[1]

missingPops<- scan(PopsMissingData)

npopsUNED<- length(scan(SNPpath, nlines=1))

OUTFILE1<- paste(SNPpath, ".OUT",groupnum, sep="")

SNPdata1<- matrix(scan(SNPpath, skip=(startSNP-1), nlines=2*(endSNP-startSNP+1), quiet=TRUE), byrow=TRUE, ncol=npopsUNED)
	#note that the scanning takes longer the higher the startSNP

if (file.exists(paste(OUTFILE1,".xtx",sep=""))){
	o <- read.table(paste(OUTFILE1,".xtx",sep=""))
	vect<- which((SNPnames %in% o$V1)==FALSE)
}else{
		vect<- 1:(endSNP-startSNP+1)
}


for (i in vect){
	
	print("____________________________________________________")
	print(i+startSNP-1)
  
  thisSNPname <- SNPnames[i]
  
  # get SNP data
	SNPdata2<- SNPdata1[(i*2-1):(i*2),]
    #note that not all populations have environmental data
	SNPdata<-SNPdata2[,-missingPops]
  
  # write SNP file
  write.table(SNPdata, file=thisSNPname, sep="\t", eol="\t\n",
              col.names=FALSE, row.names=FALSE)
  
  RANDOM <- 283
  
  # call bayenv2

  script.envi1<-paste("./bayenv2 -i", thisSNPname, "-m", covpath, "-e", envipath1, "-p", npops,
    "-k 10000", "-n", nenvi1, "-t -c -X -r", RANDOM, "-o", OUTFILE1)
    print(script.envi1)
  system(script.envi1)
  
  # remove SNP file
  system(paste("rm ", thisSNPname, "*", sep=""))
  
}
