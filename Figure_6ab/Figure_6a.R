# email: qfsfdxlqy@163.com
# GitHub: https://github.com/2015qyliang

library(treeio) # v1.10.0
library(ggtree) # v2.0.4
library(ggplot2)
library(RColorBrewer)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# RAxML
# read tree file & add node information
ml.tree <- read.raxml("Figure_6a_RaxMlTree.txt")
ml.tree@phylo$node.label <- (length(ml.tree@phylo$tip.label)+1):(length(ml.tree@phylo$tip.label) + length(ml.tree@phylo$node.label))


# extract head 3 columns to matrix (data.frame) -- 
BlastPairSimilarity <- read.table(file = "Figure_6a_BlastPairSimilarity.txt", 
                                  header = F, sep = '\t')
BlastPair.df <- BlastPairSimilarity[,c(1,2,3)]
tips.uniq <- rev(ml.tree@phylo$tip.label)
Pair.df <- as.data.frame(matrix(0,188,188))
rownames(Pair.df) <- tips.uniq
colnames(Pair.df) <- tips.uniq
for (tip.row.name in tips.uniq) {
  for (tip.col.name in tips.uniq) {
    Pair.df[tip.row.name,tip.col.name] <- 
      BlastPair.df[which(BlastPair.df$V1 == tip.row.name & 
                           BlastPair.df$V2 == tip.col.name),][1,3]
  }
}

# Node_Similarity.txt
# set null matrix to store "node & similarity & which subtree"
Node.matrix <- matrix(0,length(ml.tree@phylo$node.label),5)
rownames(Node.matrix) <- (length(ml.tree@phylo$tip.label)+1):(length(ml.tree@phylo$tip.label) + length(ml.tree@phylo$node.label))
colnames(Node.matrix) <- c("Node","Similarity","Nsubtree","Bottom.tip","Top.tip")
Node.matrix[,"Node"] <- rownames(Node.matrix)
# Extract the subtrees
subtree.list <- subtrees(ml.tree@phylo)
# for loop to compute similarity among cluster
for (i in 1:(ml.tree@phylo$Nnode)) {
  tmp.phy <- plot.phylo(subtree.list[[i]],plot = F)
  tmp.labels.list <- subtree.list[[i]]$tip.label
  tmp.new.vector <- c()
  for (seq.row.name in tmp.labels.list) {
    for (seq.col.name in tmp.labels.list) {
      if (seq.row.name != seq.col.name) {
        tmp.new.vector <- append(x = tmp.new.vector,
                                 values = Pair.df[seq.row.name, seq.col.name])
      }
    }
  }
  node.tree.mean <- mean(tmp.new.vector)
  node.tree.label <- subtree.list[[i]]$node.label[1]
  Node.matrix[as.character(node.tree.label),][2] <- round(node.tree.mean, 2)
  Node.matrix[as.character(node.tree.label),][3] <- i
  Node.matrix[as.character(node.tree.label),][4] <- subtree.list[[i]]$tip.label[1]
  Node.matrix[as.character(node.tree.label),][5] <- subtree.list[[i]]$tip.label[length(subtree.list[[i]]$tip.label)]
}
# add similarity infor to ml.tree@data
ml.tree@data$similarity <- as.numeric(Node.matrix[1:ml.tree@phylo$Nnode,"Similarity"])

# --- circular layout
p <- ggtree(ml.tree,size=0.05,ladderize=FALSE,layout = "fan",open.angle = 90) + 
  geom_treescale(fontsize = 1,linesize = 0.1,width = 0.05,x = -0.2) +
  geom_tiplab2(align = T,linesize = 0.05,linetype = 2,
              size = 1,offset = 0.05,aes(angle=angle)) + 
  geom_text2(aes(label=bootstrap, subset=bootstrap>70, angle=angle), 
             hjust = 1.2, vjust = -0.25, size = 0.5)
p <- rotate_tree(p, 90)
# rm(p)
# add node cols in for loop
node = c(359,346,267,238,205,192)
cols <- brewer.pal(12,'Set3')[c(4,6,12,7,5,3)]
node.col <- as.data.frame(node, cols)

for (code.cols in rownames(node.col)) {
  p <- p + geom_hilight(node = node.col[code.cols,], alpha = 0.7, fill = code.cols)
}

for (clNum in 1:6) {
  p <- p + geom_cladelabel(offset = 0.35,barsize = 1.5,fontsize = 1.5,
                           hjust = 0, geom = "text", offset.text = 0.2,
                           align = T, alpha = 0.7, node = node[clNum],
                           label = paste0("Cluster ", as.character(clNum), "\n(",
                                          ml.tree@data$similarity[node[clNum]-188],"%)"),
                           color = cols[clNum])
}

# add type of isolation
tmp.file <- read.table("Figure_6a_Isolation.txt",header = T,sep = '\t',row.names = 1)
iso.tips.uniq <- tips.uniq[-length(tips.uniq)]
for (iso.name in iso.tips.uniq) {
  if (as.character(tmp.file[iso.name,]) == "saline") {
    p <- p + geom_cladelabel(offset = 0.3,extend = 0.4,
                             barsize = 1.5,color = "#0072B2",
                             label = "",align = T,
                             node = which(ml.tree@phylo$tip.label == iso.name) )
  } else {
    p <- p + geom_cladelabel(offset = 0.3,extend = 0.4,
                             barsize = 1.5,color = "#999999",
                             label = "", align = T,
                             node = which(ml.tree@phylo$tip.label == iso.name) )
  }
}

# add cultured strains information
cul.list <- c("TMQ2","TMQ4","MG652491","KX815124",
              "KM034744","Y1N101","zh1718")
p <- p + geom_tippoint(aes(subset= (label %in% cul.list)), 
                       color = "red", size = 0.3, shape = 16)

ggsave("Figure_6a_RaxMlTREE_raw.pdf",p,
       units = "in",width = 8.27,height = 5.8) 
rm(p)

# brewer.pal(12,'Set3')[c(4,6,12,7,5,3)]
# "#FB8072" 251,128,114
# "#FDB462" 253,180,98
# "#FFED6F" 255,237,111
# "#B3DE69" 179,222,105
# "#80B1D3" 128,177,211
# "#BEBADA" 190,186,218

# following modified by PhantomPDF (Foxit) software


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# FastTree
# read tree file & add node information
ml.tree <- read.raxml("Figure_6a_FastTree.txt")
ml.tree@phylo$node.label <- (length(ml.tree@phylo$tip.label)+1):(length(ml.tree@phylo$tip.label) + length(ml.tree@phylo$node.label))

# extract head 3 columns to matrix (data.frame) -- 
BlastPairSimilarity <- read.table(file = "Figure_6a_BlastPairSimilarity.txt",header = F,sep = '\t')
BlastPair.df <- BlastPairSimilarity[,c(1,2,3)]
tips.uniq <- rev(ml.tree@phylo$tip.label)
Pair.df <- as.data.frame(matrix(0,188,188))
rownames(Pair.df) <- tips.uniq
colnames(Pair.df) <- tips.uniq
for (tip.row.name in tips.uniq) {
  for (tip.col.name in tips.uniq) {
    Pair.df[tip.row.name,tip.col.name] <- 
      BlastPair.df[which(BlastPair.df$V1 == tip.row.name & 
                           BlastPair.df$V2 == tip.col.name),][1,3]
  }
}

# set null matrix to store "node & similarity & which subtree"
Node.matrix <- matrix(0,length(ml.tree@phylo$node.label),5)
rownames(Node.matrix) <- (length(ml.tree@phylo$tip.label)+1):(length(ml.tree@phylo$tip.label) + length(ml.tree@phylo$node.label))
colnames(Node.matrix) <- c("Node","Similarity","Nsubtree","Bottom.tip","Top.tip")
Node.matrix[,"Node"] <- rownames(Node.matrix)
# Extract the subtrees
subtree.list <- subtrees(ml.tree@phylo)
# for loop to compute similarity among cluster
for (i in 1:(ml.tree@phylo$Nnode)) {
  tmp.phy <- plot.phylo(subtree.list[[i]],plot = F)
  tmp.labels.list <- subtree.list[[i]]$tip.label
  tmp.new.vector <- c()
  for (seq.row.name in tmp.labels.list) {
    for (seq.col.name in tmp.labels.list) {
      if (seq.row.name != seq.col.name) {
        tmp.new.vector <- append(x = tmp.new.vector,
                                 values = Pair.df[seq.row.name, seq.col.name])
      }
    }
  }
  node.tree.mean <- mean(tmp.new.vector)
  node.tree.label <- subtree.list[[i]]$node.label[1]
  Node.matrix[as.character(node.tree.label),][2] <- round(node.tree.mean, 2)
  Node.matrix[as.character(node.tree.label),][3] <- i
  Node.matrix[as.character(node.tree.label),][4] <- subtree.list[[i]]$tip.label[1]
  Node.matrix[as.character(node.tree.label),][5] <- subtree.list[[i]]$tip.label[length(subtree.list[[i]]$tip.label)]
}
# add similarity infor to ml.tree@data
ml.tree@data$similarity <- as.numeric(Node.matrix[1:ml.tree@phylo$Nnode,"Similarity"])

# --- circular layout
p <- ggtree(ml.tree,size=0.05,ladderize=FALSE,layout = "fan",open.angle = 90) + 
  geom_treescale(fontsize = 1,linesize = 0.1,width = 0.05,x = -0.2) +
  geom_tiplab2(align = T,linesize = 0.05,linetype = 2,
               size = 1,offset = 0.05,aes(angle=angle)) + 
  geom_text2(aes(label=bootstrap, subset=bootstrap>70, angle=angle), 
             hjust = 1.2, vjust = -0.25, size = 0.5)
p <- rotate_tree(p, 90)

# add node cols in for loop
node = c(358,269,280,205,233,192)
cols <- brewer.pal(12,'Set3')[c(4,6,12,7,5,3)]
node.col <- as.data.frame(node, cols)

for (code.cols in rownames(node.col)) {
  p <- p + geom_hilight(node = node.col[code.cols,], alpha = 0.7, fill = code.cols)
}

for (clNum in 1:6) {
  p <- p + geom_cladelabel(offset = 0.35,barsize = 1.5,fontsize = 1.5,
                           hjust = 0, geom = "text", offset.text = 0.2,
                           align = T, alpha = 0.7, node = node[clNum],
                           label = paste0("Cluster ", as.character(clNum), "\n(",
                                          ml.tree@data$similarity[node[clNum]-188],"%)"),
                           color = cols[clNum])
}

# add type of isolation
tmp.file <- read.table("01.isolation.txt",header = T,sep = '\t',row.names = 1)
iso.tips.uniq <- tips.uniq[-length(tips.uniq)]
for (iso.name in iso.tips.uniq) {
  if (as.character(tmp.file[iso.name,]) == "saline") {
    p <- p + geom_cladelabel(offset = 0.3,extend = 0.4,
                             barsize = 1.5,color = "#0072B2",
                             label = "",align = T,
                             node = which(ml.tree@phylo$tip.label == iso.name) )
  } else {
    p <- p + geom_cladelabel(offset = 0.3,extend = 0.4,
                             barsize = 1.5,color = "#999999",
                             label = "", align = T,
                             node = which(ml.tree@phylo$tip.label == iso.name) )
  }
}

# add cultured strains information
cul.list <- c("TMQ2","TMQ4","MG652491","KX815124",
              "KM034744","Y1N101","zh1718")
p <- p + geom_tippoint(aes(subset= (label %in% cul.list)), 
                       color = "black", size = 0.3, shape = 16)
ggsave("Figure_6a_FastTree_raw.pdf",p,
       units = "in",width = 8.27,height = 5.8) 
rm(p)

# brewer.pal(12,'Set3')[c(4,6,12,7,5,3)]
# "#FB8072" 251,128,114
# "#FDB462" 253,180,98
# "#FFED6F" 255,237,111
# "#B3DE69" 179,222,105
# "#80B1D3" 128,177,211
# "#BEBADA" 190,186,218


# following modified by PhantomPDF (Foxit) software