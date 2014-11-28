#  ConvertLFMMtoBayenv2Indiv.R
# KEL on Sept 20, 2014
# Script intended to run from:
# ssh klott@hulk.zoology.ubc.ca
# cd /data/seqcap/pine/bwa_pseudo/final_tables

# HULK ISSUES< RUN HERE: klott@rogue:~/indivCovMatPine$

lfmmForCovMat <- "var_out_pine_all_COMBINED.table.contig_flt80.noncoding.lfmm"

lf <- read.table(lfmmForCovMat)
nr <- dim(lf)[1]
nc <- dim(lf)[2]
max(lf)
max(lf[lf!=9])

lf2 <- matrix(unlist(lf), nrow=nr, nc=nc)
head(lf[,1:5])
head(lf2[,1:5])
rm(lf)

twominus.lf <- 2-lf2

bayenv.ind <- matrix(0, nrow=nr*2, ncol=nc)
dim(bayenv.ind)
odd=seq(1,dim(bayenv.ind)[1], by=2)
even=seq(2,dim(bayenv.ind)[1], by=2)

bayenv.ind[odd,] <- lf2
bayenv.ind[even,] <- twominus.lf

max(bayenv.ind) # should be 9
min(bayenv.ind) # should be -7

bayenv.ind[bayenv.ind==9]=0
bayenv.ind[bayenv.ind==-7]=0
head(bayenv.ind)
tail(bayenv.ind)

write.table(bayenv.ind,
            "var_out_pine_all_COMBINED.table.contig_flt80.noncoding.bayenv.INDIV",
            sep="\t", eol="\t\n", quote=FALSE,
            row.names=FALSE,
            col.names=FALSE)


#./bayenv2 -i var_out_pine_all_COMBINED.table.contig_flt80.noncoding.bayenv.INDIV -p 598 -k 100000 -r 9998 > var_out_pine_all_COMBINED.table.contig_flt80.noncoding.bayenv.INDIV.COVMAT2