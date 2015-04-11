### Write submission script for Westgrid
# ssh klott@bugaboo.westgrid.ca
# cd SpruceBayenv2_10nonimputed


nSNPperJob <- 50
njobs <- 20000/nSNPperJob

nsets <- 2
niterations <- 4000000
walltime <- "200:00:00"
Rfile <- "bayenv2_callSNPsV3pine_test20000_ANYit.R"

for (k in 1:nsets){
  for (j in 1:njobs){
  
  startSNP<-(j-1)*nSNPperJob +1
  endSNP<- startSNP + (nSNPperJob-1)

### practice snp  
  #  for (j in 1:1){  
  # startSNP=1
  #  endSNP=5
  SubmitScriptName <- paste("SubmitBayenv20000SNPS,",niterations,"_Set",k, "_Group",j,"_", startSNP,"_to_",endSNP, sep="") 
	
		write(	c("#!/bin/bash", "#PBS -r n", "#PBS -m a", "#PBS -M klott@zoology.ubc.ca", paste("#PBS -l walltime=",walltime,sep=""), "#PBS -l procs=1", "#PBS -l mem=1gb", "" ,"cd $PBS_O_WORKDIR", paste("R --vanilla <", Rfile ,"--args", startSNP, endSNP, j, k, niterations, sep=" ")), ncolumns=1, append=FALSE, file=SubmitScriptName)
	
		#Submit Submission Script to system	
		system(paste("qsub ", SubmitScriptName))

	}
}