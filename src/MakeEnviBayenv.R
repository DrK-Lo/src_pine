
### read in population file order of covmat
  popfile <- "var_out_pine_all_COMBINED.table.contig_flt10.bayenv.pop_order"
  pop.df <- read.table(popfile)
  pop.df$V2 <- as.character(pop.df$V2)
  head(pop.df)
### read in envi file
  envi.df <- read.csv("pine_GBS_clm_short_KEL.csv")
  head(envi.df)
  envi.df$Seedlot <- as.character(envi.df$Seedlot)
  
  
### Populations in Tongli's file not in pine pop file
  a1 <- which((envi.df$Seedlot %in% pop.df$V2)==FALSE)  
  envi.df$Seedlot[a1]
    # Pi_13 and Pi_76
### Populations in pine pop file not in Tongli's file
  a2 <- which((pop.df$V2 %in% envi.df$Seedlot)==FALSE)  
  pop.df$V2[a2]
    # none
  
  pop.df2 <- rbind(pop.df,data.frame(V1=rep(NA,2),V2=as.character(envi.df$Seedlot[a1])))
  nrow(pop.df2)
  nrow(envi.df)
  envi.df2 <- envi.df
  
### realign rows in envi file to match pop file
  nrow(envi.df2)
  nrow(pop.df2)
  a<- match(as.character(pop.df2$V2), 
            as.character(envi.df2$Seedlot))
  sum(is.na(a))
  
### Make a new aligned data frame
  new.df <- data.frame(pop.df2, envi.df2[a,])
  head(new.df)
  tail(new.df)
  identical(as.character(new.df$V2), as.character(new.df$Seedlot))

### Populations to remove based on incomplete envi data
  remove1 <- c("Pi_585", "Pi_586")
### Populations to remove based on absence in pop file
  remove2 <- as.character(envi.df$Seedlot[a1])
  
### indexes to remove from new.df
  b <- which(as.character(new.df$V2) %in% c(remove1,remove2))
  new.df2 <- new.df[-b,]
  
### standardize environmental variables and transform for 
### envi variables in rows and pops in columns for bayenv2
  new.df3 <- t(new.df2[,-(1:3)]) #transpose
  head(new.df3[,1:5])
  new.df4 <- new.df3 # will standardize
  for (i in 1:nrow(new.df3)){
    var <- new.df3[i,]
    new.df4[i,] <- (var-mean(var))/sd(var)
  }
  dim(new.df4)
  envifile <- sub("pop_order", "envi",popfile)
  write.table(new.df4, sep = "\t", eol="\t\n",
              file=envifile, 
              row.names=FALSE, col.names=FALSE)
  
### indexes to remove from covmat
### WRITE TO FILE
  which(as.character(new.df$V2) %in% c(remove1))
  which(as.character(pop.df$V2) %in% c(remove1))
  
  LinesRemoved<- which(as.character(pop.df$V2) %in% c(remove1)) 
  write.table(data.frame(LinesRemoved), 
              file=paste(envifile,".linesRemoved", sep=""), 
              row.names=FALSE, col.names=FALSE)
  write.table(pop.df[-LinesRemoved,],
              file=paste(envifile,".finalPops", sep=""),
              row.names=FALSE, col.names=FALSE)

### WRITE A NEW COVMAT
  covmatfile <- "var_out_pine_all_COMBINED.table.contig_flt80.noncoding.bayenv.covmatED"
  covmat <- read.table(covmatfile, header=FALSE)
  write.table(covmat[-LinesRemoved,-LinesRemoved],
              file=paste(envifile,".finalcovmatED", sep=""),
              sep = "\t", eol="\t\n",
              row.names=FALSE, col.names=FALSE)

