# email: qfsfdxlqy@163.com
# GitHub: https://github.com/2015qyliang

library(treeio) # v1.10.0
library(RColorBrewer)
library(gplots)
library(adespatial)
library(labdsv) # v2.0-1

ml.tree <- read.raxml("Figure_4_CoreGeneTree.txt")
ml.tree@phylo$node.label <- (length(ml.tree@phylo$tip.label)+1):(length(ml.tree@phylo$tip.label) + length(ml.tree@phylo$node.label))

# get KO list
KO.vector <- c()
KO.file <- readLines('Figure_4_KoFunction.txt')
for (line in KO.file) {
  list.split <- strsplit(line, split = "\t")[[1]]
  KO.vector <- append(KO.vector, list.split[1])
}

# matrix KO-species
df.rowname <- c()
counter.ko.list <- list()
file.order <- 1
blastkoala.files <- list.files("BlastKOALA")
for (fn in blastkoala.files) {
  fn.split <- strsplit(fn, split = ".txt")[[1]]
  df.rowname <- append(df.rowname, fn.split[1])
  file.content <- readLines(paste0("BlastKOALA/",fn))
  genes.num <- length(file.content)
  ko.list <- c()
  for (line in file.content) {
    if ( length(strsplit(line, split = "\t")[[1]]) > 1 ) {
      ko.entry <- strsplit(line, split = "\t")[[1]][2]
      ko.list <- append(ko.list, ko.entry)
    }
  }
  ko.count.vector <- c()
  ko.count.vector.relate <- c()
  for (ko.entry in KO.vector) {
    ko.count <- sum(ko.list == ko.entry)
    ko.count.vector <- append(ko.count.vector, ko.count)
  }
  counter.ko.list[[file.order]] <- ko.count.vector
  file.order <- file.order + 1
}
ko.count.df <- data.frame(counter.ko.list)

colnames(ko.count.df) <- df.rowname # set species for rownames
rownames(ko.count.df) <- KO.vector # set KO for colnames
ko.count.df <- ko.count.df[-which(rownames(ko.count.df) == "K12132"),]
ko.count.df <- ko.count.df[-which(rownames(ko.count.df) == "K02014"),]
ko.count.df <- ko.count.df[-which(rownames(ko.count.df) == "K02004"),]


# write.table(ko.count.df, "MatrixKoSpe.txt",sep = '\t',
#             quote = F,row.names = T,col.names = T)

ko.enttry.list <- readLines('TableS3_KOs.txt')
new.df.heatmp <- ko.count.df[ko.enttry.list, rev(ml.tree@phylo$tip.label)]
gene.description <- readLines('Figure_4_KoFunction.txt')
koentry.vector <- c()
for (entry in gene.description) {
  split.entry <- strsplit(entry, split = '\t')[[1]]
  koentry.vector <- append(koentry.vector, split.entry[1] )
}
names(gene.description) <- koentry.vector
rownames(new.df.heatmp) <- gene.description[rownames(new.df.heatmp)]
new.df.heatmp.t <- t(new.df.heatmp)

# cluster -- lineage & gene
## lineage -- new.df.heatmp.t : row - lineage
spe.ch <- dist.ldc(new.df.heatmp.t, 'euclidean')
attr(spe.ch, "Labels") <- rownames(new.df.heatmp.t)
lineage.spe.ch.ward <- hclust(spe.ch, method = 'ward.D2')

## gene -- new.df.heatmp : row - gene
spe.ch <- dist.ldc(new.df.heatmp, 'euclidean')
attr(spe.ch, "Labels") <- rownames(new.df.heatmp)
gene.spe.ch.ward <- hclust(spe.ch, method = 'ward.D2')

dend.gene <- as.dendrogram(gene.spe.ch.ward)
dend.lineage <- as.dendrogram(lineage.spe.ch.ward)

grps <- c( rep(1, 4), rep(2,13), rep(3, 2), rep(1, 5), 3, 1, rep(3, 5),rep(1, 6))
lineage.col <- brewer.pal(3, "Dark2")[grps]
pdf("Figure_4_raw.pdf", width = 8,height = 6)
par(mar = c(1, 4, 4, 1)) 
heatmap.2(new.df.heatmp.t,Rowv = dend.lineage,Colv = dend.gene,margin=c(7,14),
          col= colorRampPalette(c("white", "black"))(50),
          key = F,trace = "none", srtCol=-60,
          offsetCol = -0.9, offsetRow = -0.9,
          adjCol = c(0,1),
          cexCol = 0.1,cexRow = 0.6,
          lhei = c(1,15),lwid = c(1,20),
          colRow = lineage.col)
dev.off()

# 6 * 8 "in"  
# following modified by PhantomPDF (Foxit) software

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

TableS3matrix <- new.df.heatmp[gene.spe.ch.ward$labels[gene.spe.ch.ward$order],
                               lineage.spe.ch.ward$labels[lineage.spe.ch.ward$order]]
TableS3matrix.rownames <- c()
for (tmpname in gene.spe.ch.ward$labels[gene.spe.ch.ward$order]) {
  ko1 <- strsplit(tmpname, split = '\t')[[1]][1]
  ko2 <- strsplit(tmpname, split = '\t')[[1]][2]
  ko3 <- strsplit(tmpname, split = '\t')[[1]][3]
  TableS3matrix.rownames <- append(TableS3matrix.rownames, 
                                   paste(ko1, ko2, ko3, sep = ';'))
}
rownames(TableS3matrix) <- TableS3matrix.rownames
write.table(TableS3matrix,
            "TableS3_Matrix.txt",
            quote = F, sep = '\t',row.names = T, col.names = T)
