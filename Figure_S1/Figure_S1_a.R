# email: qfsfdxlqy@163.com
# GitHub: https://github.com/2015qyliang

############ part one
# step - 1 
library(treeio) # v1.10.0
library(ggtree) # v2.0.4
library(ggplot2)
library(RColorBrewer)

ml.tree <- read.raxml("Figure_S1_a_CoreGeneTree.txt")
ml.tree@phylo$node.label <- (length(ml.tree@phylo$tip.label)+1):(length(ml.tree@phylo$tip.label) + length(ml.tree@phylo$node.label))

# input genome basic information
basic.genome.infor <- read.table("Figure_S1_a_BasicInfor.txt", header = T, 
                                 sep = '\t', stringsAsFactors = F)
colnames(basic.genome.infor)[1] <- "id"
rownames(basic.genome.infor) <- basic.genome.infor$id
new.basic.genome.infor <- basic.genome.infor[ml.tree@phylo$tip.label,]

p1 <- ggtree(ml.tree,size=0.05,ladderize=F)
colors.bar <- brewer.pal(8,'Set3')

# complete infor
data2 <- data.frame(new.basic.genome.infor$id, new.basic.genome.infor$complete)
colnames(data2) <- c("id", "complete")
p2 <- facet_plot(p1, panel="complete", data=data2, 
                 size=3, color=colors.bar[1],
                 geom=geom_segment, 
                 aes(x=50, xend=complete, y=y, yend=y))

# size
data3 <- data.frame(new.basic.genome.infor$id, new.basic.genome.infor$size)
colnames(data3) <- c("id", "size")
p3 <- facet_plot(p2, panel="size", data=data3, 
                 size=3, color=colors.bar[8],
                 geom=geom_segment, 
                 aes(x=2, xend=size, y=y, yend=y))

# GC
data4 <- data.frame(new.basic.genome.infor$id, new.basic.genome.infor$GC)
colnames(data4) <- c("id", "GC")
p4 <- facet_plot(p3, panel="GC", data=data4, 
                 size=3, color=colors.bar[3],
                 geom=geom_segment, 
                 aes(x=30, xend=GC, y=y, yend=y))

# genes
data5 <- data.frame(new.basic.genome.infor$id, new.basic.genome.infor$genes)
colnames(data5) <- c("id", "genes")
p5 <- facet_plot(p4, panel="Genes", data=data5, 
                 size=3, color=colors.bar[4],
                 geom=geom_segment, 
                 aes(x=2000, xend=genes, y=y, yend=y))

# tRNAs
data6 <- data.frame(new.basic.genome.infor$id, new.basic.genome.infor$tRNAs)
colnames(data6) <- c("id", "tRNAs")
p6 <- facet_plot(p5, panel="tRNAs", data=data6, 
                 size=3, color=colors.bar[5],
                 geom=geom_segment, 
                 aes(x=20, xend=tRNAs, y=y, yend=y))

# Peptidase
Peptidase <- read.table("Figure_S1_a_PeptidaseCounter.txt", header = T, row.names = 1,
                    sep = '\t', stringsAsFactors = F)
Peptidase <- Peptidase[,ml.tree@phylo$tip.label]
id <- names(colSums(Peptidase))
value <- colSums(Peptidase)
data7 <- data.frame(id, value)
p7 <- facet_plot(p6, panel="Peptidase", data=data7, 
                 size=3, color=colors.bar[6],
                 geom=geom_segment, 
                 aes(x=0, xend=value, y=y, yend=y))

# nuclease
nuclease <- read.table("Figure_S1_a_nucleaseCounter.txt", header = T, row.names = 1,
                    sep = '\t', stringsAsFactors = F)
nuclease <- nuclease[, ml.tree@phylo$tip.label]
id <- names(colSums(nuclease))
value <- colSums(nuclease)
data8 <- data.frame(id, value)
p8 <- facet_plot(p7, panel="Nuclease", data=data8, 
                 size=3, color=colors.bar[7],
                 geom=geom_segment, 
                 aes(x=0, xend=value, y=y, yend=y))

plot.summary <- p8 + theme_tree2() + 
  geom_tiplab(align = F,linesize = 0.1,
              linetype = 2,size = 1.5,
              offset = 0.05)

ggsave("Figure_S1_a_BasicInfor_raw.pdf",plot.summary,
       units = "in",width = 7.39,height = 5.75)


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
summaryTable <- data.frame(Genome = ml.tree@phylo$tip.label,
                           Complete = data2$complete,
                           GenomeSize = data3$size,
                           GenomeGC = data4$GC,
                           Genes = data5$genes,
                           tRNAs = data6$tRNAs,
                           Peptidase = data7$value,
                           Nuclease = data8$value)
colnames(summaryTable) <- c("Genome","Complete (%)","GenomeSize (Mbp)",
                            "GC (% mol)","Genes","tRNAs",
                            "Peptidase","Nuclease") 
write.table(summaryTable, "Figure_S1_a_TableInfor.txt",quote = F,
            sep = '\t',row.names = F,col.names = T) 


# following modified by PhantomPDF (Foxit) software