# email: qfsfdxlqy@163.com
# GitHub: https://github.com/2015qyliang

# start R version 3.6.3
library(treeio) # v1.10.0
library(ggtree) # v2.0.4
library(ggplot2) 
library(RColorBrewer)

# read tree file & add node information
ml.tree <- read.raxml("Figure_1aRAxML.tree") # function from treeio
ml.tree@phylo$node.label <- (length(ml.tree@phylo$tip.label)+1):(length(ml.tree@phylo$tip.label) + length(ml.tree@phylo$node.label))

raw.tiblable <- ml.tree@phylo$tip.label
sdum.tiblable <- c()
for (tib in raw.tiblable) {
  splitTax <- strsplit(tib, split = "_")[[1]]
  header <- paste0(splitTax[1], "_", splitTax[2], "_", splitTax[3], "_", splitTax[4])
  sdum.tiblable <- append(sdum.tiblable, header)
}
ml.tree@phylo$tip.label <- sdum.tiblable

# get prey list
tableS1.df <- read.table('Figure_1c_TableS1.txt', 
                         header = T, sep = '\t', stringsAsFactors = F)
tableS1.df.new <- tableS1.df[2:dim(tableS1.df)[1],]
preyType <- as.numeric(tableS1.df.new$Prey_of_FA350) + as.numeric(tableS1.df.new$Prey_of_B210)
preyType[which(preyType >= 1)] <- 1
tableS1.df.new <- data.frame(tableS1.df.new, preyType)
preyListS1 <- tableS1.df.new[which(tableS1.df.new$preyType == 1), 'Strain']
preyPhylum <- tableS1.df.new[which(tableS1.df.new$preyType == 1), 'Phylum']
preyList <- c()
for(lineNum in 1:length(preyListS1)) {
  vectorSplit <- strsplit(preyListS1[lineNum],split = '_')[[1]]
  sdu <- vectorSplit[3]
  genus <- vectorSplit[1]
  species <- vectorSplit[2]
  phylum <- preyPhylum[lineNum]
  preyLine <- paste(phylum, sdu, genus, species, sep = '_')
  preyList <- append(preyList, preyLine)
}

# prey; 'red'+18
plotSymbols <- rep("16", length(sdum.tiblable))
plotSymbols[which(sdum.tiblable %in% preyList)] <- as.character("18")
colList <- rep("xnull", length(sdum.tiblable))
colList[which(sdum.tiblable %in% preyList)] <- as.character("red")
infof.df <- data.frame( prey = sdum.tiblable, 
                        col = colList,
                        shape = plotSymbols)

# plot tree
p <- ggtree(ml.tree,size=0.05,ladderize=FALSE, layout = "fan") %<+% infof.df
p <- p + geom_treescale(fontsize = 1,linesize = 0.1,width = 0.05) +
  geom_tippoint(aes(alpha = 1,
                    color = col,
                    shape = shape),
                size = 0.65) + 
  theme(legend.text = element_text(size = 4)) 
p <- open_tree(p, 10)
p <- rotate_tree(p, 90)

# add node cols in for loop
# Actinobacteria 378
# Bacteroidetes 284
# Firmicutes 326
# Proteobacteria 435, 472
node = c(378,284,326,435,472)
cols <- brewer.pal(4,"Set2")

# Actinobacteria cols[1]
# Bacteroidetes cols[2]
# Firmicutes cols[3]
# Proteobacteria cols[4]

# cladelabel
p <- p + geom_cladelabel(offset = 0,barsize = 1.5,fontsize = 1.5, hjust = 0, 
                         offset.text = 0.2, align = T, alpha = 1, label = NA,
                         node = 378, color = cols[1])
p <- p + geom_cladelabel(offset = 0,barsize = 1.5,fontsize = 1.5, hjust = 0, 
                         offset.text = 0.2, align = T, alpha = 1, label = NA,
                         node = 284, color = cols[2])
p <- p + geom_cladelabel(offset = 0,barsize = 1.5,fontsize = 1.5, hjust = 0, 
                         offset.text = 0.2, align = T, alpha = 1, label = NA,
                         node = 326, color = cols[3])
p <- p + geom_cladelabel(offset = 0,barsize = 1.5,fontsize = 1.5, hjust = 0, 
                         offset.text = 0.2, align = T, alpha = 1, label = NA,
                         node = 435, color = cols[4])
p <- p + geom_cladelabel(offset = 0,barsize = 1.5,fontsize = 1.5, hjust = 0, 
                         offset.text = 0.2, align = T, alpha = 1, label = NA,
                         node = 472, color = cols[4])

ggsave(p + theme(legend.position = "none"), 
       file="Figure_1a_Raw.pdf", 
       width=4.17, height=4.17, units = c("in"))

# following modified by PhantomPDF (Foxit) software

# write(ml.tree@phylo$tip.label, "TreeRoot_tipLable.txt")

