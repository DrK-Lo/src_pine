### Write submission script for Westgrid
# ssh klott@bugaboo.westgrid.ca

# for 5 loci, takes less than 1 minute
# for 20,000 loci, should take 2.8 days or 90 hours

# 10,141,833 SNPs
# 406 jobs with 25,000 loci each
# 

njobs <- 406
nSnpsPerJob <- 25000
nSnps <- 10141833

for (j in 1:njobs){

  startSNP<-(j-1)*nSnpsPerJob +1
  endSNP<- startSNP + nSnpsPerJob - 1
  
  if (j==njobs){endSNP<-nSnps }

  SubmitScriptName <- paste("SubmitBayenvPineSNPS_Set",j,"_", startSNP,"_to_",endSNP, sep="") 

	write(	c("#!/bin/bash", "#PBS -r n", "#PBS -m a", "#PBS -M klott@zoology.ubc.ca", "#PBS -l walltime=300:00:00", "#PBS -l procs=1", "#PBS -l mem=1gb", "" ,"cd $PBS_O_WORKDIR", paste("R --vanilla < bayenv2_PinecallSNPsV3.2.R --args", startSNP, endSNP, j, sep=" ")), ncolumns=1, append=FALSE, file=SubmitScriptName)
	
		#Submit Submission Script to system	
		system(paste("qsub ", SubmitScriptName))

	}