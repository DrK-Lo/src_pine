setwd("/Users/katie/Desktop/AdaptreeData/pine/src-GBS")
#363931 loci forGBS, by 25,000 is only 15 jobs

goodPops <- read.table("var_out_pine_all_COMBINED.table.contig_flt10.bayenv.envi.finalPops2")
GBSPops <- read.table("pine_GBS_all.table.contig_flt10.bayenv.pop_order")

logic <- GBSPops$V2 %in% goodPops$V1
(linesRemoved <- which(!logic))

as.character(GBSPops$V2[-linesRemoved])==as.character(goodPops$V1)

write.table(linesRemoved , "GBS.linesRemoved2", col.names=FALSE, row.names=FALSE)
