# email: qfsfdxlqy@163.com
# GitHub: https://github.com/2015qyliang

library(treeio) # v1.10.0
library(ggtree) # v2.0.4
library(corrplot)
library(RColorBrewer)

ml.tree <- read.raxml("Figure_S1_b_RaxmlTREE.txt")
ml.tree@phylo$node.label <- (length(ml.tree@phylo$tip.label)+1):(length(ml.tree@phylo$tip.label) + length(ml.tree@phylo$node.label))
tree.tip <- ml.tree@phylo$tip.label[c(2:10)]

ani <- read.table("Figure_S1_b_ANI.txt",header = T,sep = '\t',
                   row.names = 1,na.strings = "NA")
ani <- ani[rev(tree.tip),rev(tree.tip)]
corrplot(as.matrix(ani), col = brewer.pal(11, "Spectral"),
         insig = "blank",
         diag = F,tl.col = "black",
         number.cex = .5,
         addCoef.col = "black",
         method = "circle", type = "lower")
# (width = 3.39,height = 3.75)

pocp <- read.table("Figure_S1_b_POCP.txt",header = T,sep = '\t',
                       row.names = 1,na.strings = "NA")
pocp <- pocp[rev(tree.tip),rev(tree.tip)]
corrplot(as.matrix(pocp), col = brewer.pal(8, "BuGn"),
         insig = "blank",
         diag = F,tl.col = "black",
         number.cex = .5,
         addCoef.col = "black",
         method = "circle", type = "upper")
# (width = 3.39,height = 3.75)


p1 <- ggtree(ml.tree,size=0.05,ladderize=FALSE) +
  geom_tiplab(align = T,linesize = 0.05,linetype = 2,
              size = 1.5,offset = 0.05) +
  geom_text2(aes(label=bootstrap, subset=bootstrap>70),
             hjust = 1.2, vjust = -0.25, size = 1.5) +
  geom_treescale(x = 0,y = 0,fontsize = 2,linesize = 0.1,width = 0.05)

p1
# ggsave("Figure_S1_b_RaxMLTREE.pdf",p1,
#        units = "in",width = 3.39,height = 3.75)


# following modified by PhantomPDF (Foxit) software
