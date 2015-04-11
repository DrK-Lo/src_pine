#scp -r klott@rogue.zoology.ubc.ca:/data/seqcap/spruce/bwa_pseudo/final_tables/spruce_GBS_all.table.contig_flt10.bayenv* .
#scp -r klott@rogue.zoology.ubc.ca:/data/seqcap/spruce/bwa_pseudo/final_tables/var_out_spruce_all_beagle10_p99.tab.bayenv* .
#also transfer edited covariance matrix from laptop
 #var_out_588ind_all_v2_COMBINED.table.contig_flt80.noncoding.bayenv.covmatED.goodPops
#first source bayenv2_RemovePopsMissingData.R

args <- commandArgs(trailingOnly = TRUE) 
  startSNP <- as.numeric(args[1])
  endSNP <- as.numeric(args[2])
  groupnum <- as.numeric(args[3])
  setnum <- as.numeric(args[4])
  niterations <- as.numeric(args[5])
rm(args)

#startSNP <- 1
#endSNP <- 5
#groupnum<-1

setwd("~/PineBayenv2_10nonimputed_rm580plus/bayenv2test20000")  # MAY NEED TO BE CHANGED

envipath1<-"var_out_pine_all_COMBINED.table.contig_flt10.bayenv.envi2"

covpath<- "var_out_pine_all_COMBINED.table.contig_flt10.bayenv.envi.finalcovmatED2"

SNPnames1 <- as.character(read.table("pine_20k_snps_to_rerun_bayenv_trial.txt")$V1)

#PopsMissingData <- "seqcap.bayenv.BF.envi.linesRemoved2" already removed

enviDims1 <- dim(read.table(envipath1))
npops <- enviDims1[2]
nenvi1 <- enviDims1[1]

#missingPops<- scan(PopsMissingData) #already removed

OUTFILE1<- paste("pine_20k_snps_to_rerun_bayenv_trial.20000loci.niter",niterations,"_Set",setnum,"_Group", groupnum, sep="")

vect<- 1:(endSNP-startSNP+1)

for (i in vect){
	
	print("____________________________________________________")
	print(i+startSNP-1)
  
  thisSNPname <- SNPnames1[i]
  
  # get SNP data
	SNPdata<- read.table(thisSNPname)
    #note that here, the populations were already removed
  
	RANDOM <- sample(1:100000, 1)
  
  # call bayenv2

  script.envi1<-paste("./bayenv2 -i", thisSNPname, "-m", covpath, "-e", envipath1, "-p", npops,
    "-k",as.character(niterations), "-n", nenvi1, "-t -c -X -r", RANDOM, "-o", OUTFILE1)
   
  system(script.envi1)
	 print(script.envi1)  
}
