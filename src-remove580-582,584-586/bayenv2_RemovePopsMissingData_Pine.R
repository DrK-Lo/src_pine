setwd("~/Desktop/AdaptreeData/pine/src-remove580-582,584-586/")

covpath<- "../envishortlistCovMats/var_out_pine_all_COMBINED.table.contig_flt80.noncoding.bayenv.covmatED"
envipath<-"../envishortlistCovMats/var_out_pine_all_COMBINED.table.contig_flt10.bayenv.envi"
  envi <- read.table(envipath)
  dim(envi)
poppath <- "../envishortlistCovMats/var_out_pine_all_COMBINED.table.contig_flt10.bayenv.pop_order"
  pop.names <- read.table(poppath,colClasses ="character")
  head(pop.names)
  dim(pop.names)

### These pops removed based on missing environmental data
	missing.pops.envi.path <- "../envishortlistCovMats/var_out_pine_all_COMBINED.table.contig_flt10.bayenv.envi.linesRemoved"
	missingPops.envi <- scan(missing.pops.envi.path)
  missingPops.envi

### These pops removed based on weird individuals
	more.pops.rm <- paste("Pi_", c(580:582, 584:586), sep="")
	rm.pops <- which(pop.names$V2 %in% more.pops.rm)
  rm.pops

  missingPops <- unique(c(missingPops.envi, rm.pops))
    # note that 585-586 were already removed in first round based on missing envi data

  covmat <- read.table(covpath)
  dim(covmat)

  covmat2<- covmat[-missingPops,-missingPops]

  dim(covmat2)
  length(pop.names$V1[-missingPops])

  envi2 <- envi[,-rm.pops[-(which(rm.pops %in% missingPops.envi))]]
  dim(envi2)
    # note that 585-586 were already removed in first round based on missing envi data


  write.table(envi2, "var_out_pine_all_COMBINED.table.contig_flt10.bayenv.envi2", sep="\t", eol="\t\n", col.names=FALSE, row.names=FALSE)
  write.table(sort(missingPops), "var_out_pine_all_COMBINED.table.contig_flt10.bayenv.envi.linesRemoved2", row.names=FALSE, col.names=FALSE)
  write.table(covmat2, file=paste("var_out_pine_all_COMBINED.table.contig_flt10.bayenv.envi.finalcovmatED2", sep=""), sep="\t", eol="\t\n", col.names=FALSE, row.names=FALSE)
  write.table(pop.names$V2[-missingPops], "var_out_pine_all_COMBINED.table.contig_flt10.bayenv.envi.finalPops2", row.names=FALSE,col.names=FALSE)

