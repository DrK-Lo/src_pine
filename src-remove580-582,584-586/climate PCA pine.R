setwd("/Users/katie/Desktop/AdaptreeData/src_pine/src-remove580-582,584-586")

e <- read.table("var_out_pine_all_COMBINED.table.contig_flt10.bayenv.envi2")
enames <- read.table("enviNamesAllAnalyses.txt")
head(enames)
dim(e)
e2<-t(e)
colnames(e2) <- enames$V2
?princomp
pac<- princomp(e2)
summary(pac)
  #1st 4 components are 90% of variation
pac$loadings[,1:4]
  #PC1: temp, elevation, frost free, evaporation
  #PC2: precipitation, some temp and heat:moisture, climate moisture
  #PC3: latitude, some temp variables, climate moisture
  #PC4: longitude