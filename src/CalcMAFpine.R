#get MAF cond
# cd /data/seqcap/spruce/bwa_pseudo/final_tables 
# wc -l var_out_pine_all_COMBINED.table.contig_flt10.bayenv
# 20283666

be.df <- read.table("var_out_pine_all_COMBINED.table.contig_flt10.bayenv")
nlines <- 20283666
nlines/2
even <- seq(2, nlines, 2)
odd <- seq(1, nlines,2)

A1count <- rowSums(be.df[odd,])
A2count <- rowSums(be.df[even,])

A1freq <- A1count/(A1count + A2count)

MAF <- A1freq
cond <- A1freq > 0.5
MAF[cond] <- 1 - A1freq[cond]

#hist(MAF)
MAF <- as.numeric(MAF)
MAF.gt.05 <- (MAF >= 0.05)
sum(MAF.gt.05)
write.table(data.frame(MAF, MAF.gt.05), file = "var_out_pine_all_COMBINED.table.contig_flt10.bayenv.MAF", col.names=TRUE, row.names=FALSE)
