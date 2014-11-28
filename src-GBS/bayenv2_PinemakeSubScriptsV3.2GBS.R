### Write submission script for Westgrid
# ssh klott@bugaboo.westgrid.ca

#363931 loci forGBS, by 25,000 is only 15 jobs


njobs <- 15
nSnpsPerJob <- 25000
nSnps <- 363931

for (j in 1:njobs){

  startSNP<-(j-1)*nSnpsPerJob +1
  endSNP<- startSNP + nSnpsPerJob - 1
  
  if (j==njobs){endSNP<-nSnps }

  SubmitScriptName <- paste("SubmitBayenvPineSNPS_Set",j,"_", startSNP,"_to_",endSNP, sep="") 

	write(	c("#!/bin/bash", "#PBS -r n", "#PBS -m a", "#PBS -M klott@zoology.ubc.ca", "#PBS -l walltime=300:00:00", "#PBS -l procs=1", "#PBS -l mem=1gb", "" ,"cd $PBS_O_WORKDIR", paste("R --vanilla < bayenv2_PinecallSNPsV3.2GBS.R --args", startSNP, endSNP, j, sep=" ")), ncolumns=1, append=FALSE, file=SubmitScriptName)
	
		#Submit Submission Script to system	
		system(paste("qsub ", SubmitScriptName))

	}