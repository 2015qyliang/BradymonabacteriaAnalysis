# email: qfsfdxlqy@163.com
# GitHub: https://github.com/2015qyliang

library(ape)
library(treeio) # v1.10.0
library(ggtree) # v2.0.4
library(ggplot2)
library(gridExtra)
library(RColorBrewer)

#### Part 1 
tmp.origin <- subset(read.table(paste0("Fig6b_SampleCountCluster/",
                                       list.files("Fig6b_SampleCountCluster")[1]),
                                header = F,sep = '\t'),select = -V2)
for (file.sample in list.files("Fig6b_SampleCountCluster")) {
  file.content <- read.table(file = paste0("Fig6b_SampleCountCluster/",file.sample),
                             header = F,sep = '\t')
  name.sample <- strsplit(file.sample,split = '.t')[[1]][1]
  tmp.origin <- merge(x = tmp.origin, y = file.content, by = "V1", all.x = T)
}
colnames(tmp.origin) <- c("GenebankNo",list.files("Fig6b_SampleCountCluster"))
write.table(x = tmp.origin, file = "Figure_6b_SampleGenbankCountA.txt",
            quote = F, sep = '\t', row.names = F, col.names = T)

system("python Figure_6b_changeGenbank2Normal.py")


#### Part 2 
GenbankCount <- read.table("Figure_6b_SampleGenbankCountB.txt",header = T,
                           sep = '\t',row.names = 1,stringsAsFactors = F)
# read tree file & add node information
ml.tree <- read.raxml("Figure_6b_RaxMlTREE.txt")
ml.tree@phylo$node.label <- (length(ml.tree@phylo$tip.label)+1):(length(ml.tree@phylo$tip.label) + length(ml.tree@phylo$node.label))
# Extract the subtrees
subtree.list <- subtrees(ml.tree@phylo)
node = c(359,346,267,238,205,192)

cluster.df <- list()
num <- 1
for (i in node) {
  cluster.lables <- subtree.list[[i - 188]]$tip.label
  tmp.df <- GenbankCount[which(rownames(GenbankCount) %in% cluster.lables),]
  cluster.df[[num]] <- colSums(tmp.df)
  num <- num + 1
}

cluster.df <- data.frame(cluster.df)
colnames(cluster.df) <- c("Cluster_1","Cluster_2","Cluster_3",
                          "Cluster_4","Cluster_5","Cluster_6")
new.df <- t(data.frame(cluster.df))
rownames(new.df) <- c("Cluster_1","Cluster_2","Cluster_3",
                      "Cluster_4","Cluster_5","Cluster_6")
# write.table(new.df ,"04.ClusterDF.txt" , quote = F,
#             sep = '\t',row.names = T,col.names = T)

cols <- brewer.pal(12,'Set3')[c(4,6,12,7,5,3)]
clusName <- names(rowSums(new.df))
clusLog <- log10(rowSums(new.df))
clusDF <- data.frame(clusName, clusLog)
pBarplot <- ggplot(clusDF, aes(x = clusName, y = clusLog)) + 
  geom_bar(stat = 'identity', fill = cols) + 
  ylab('log10') + xlab(NULL) + theme_bw() +
  theme(axis.text.x = element_text(angle=45, hjust=1, vjust=1), 
        panel.grid =element_blank())


#### Part 3
spe.ch <- dist(as.matrix(cluster.df), "euclidean")
spe.ch <- dist(cluster.df, "euclidean")
attr(spe.ch, "Labels") <- rownames(cluster.df)
spe.ch.ward <- hclust(spe.ch, method = "ward.D2") 
hcluster.tree <- as.phylo(spe.ch.ward)

p <- ggtree(hcluster.tree, layout="fan", 
            ladderize=FALSE, open.angle = 90) + 
  geom_treescale(linesize = 0.1)

p <- rotate_tree(p, 90)

# add type of isolation
encirTypes <- read.table("Figure_6b_EnvironmentTypes.txt",
                         header = T,sep = '\t',
                         stringsAsFactors = F)
rownames(encirTypes) <- encirTypes$Samples

envir.cols.raw <- c("#AFD888", "#00A779", "#63ADD0", "#FF4540", 
                    "#D836C4", "#EE6B9E", "#FF8F40", "#FFFA73")
names(envir.cols.raw) <- c("NSLS", "NSS", "NSW", "SW", "MS", "SS", "SLS", "SLW")
enivrName <- c("NSLS", "NSS", "NSW", "SW", "MS", "SS", "SLS", "SLW")
envirVirt <- rep(1,8)
envirDF <- data.frame(enivrName, envirVirt)
pEnvirType <- ggplot(envirDF, aes(x = enivrName, y = envirVirt)) + 
  geom_bar(stat = 'identity', fill = envir.cols.raw, alpha = 0.8) + 
  ylab(NULL) + xlab(NULL) + theme_bw() +
  theme(axis.text.x = element_text(angle=45, hjust=1, vjust=1), 
        panel.grid =element_blank())

envir.cols <- envir.cols.raw[unique(encirTypes$EnvirTypes)]
envir.cols.names <- names(envir.cols)

for (iso.sample in encirTypes$Samples) {
  if (as.character(encirTypes[iso.sample,][2]) == envir.cols.names[1]) {
    p <- p + geom_cladelabel(offset = 0.5,extend = 0.4,alpha = 0.8,
                             barsize = 0.8,color = envir.cols[1],
                             label = "",align = T,
                             node = which(hcluster.tree$tip.label == iso.sample) )
  } 
  if (as.character(encirTypes[iso.sample,][2]) == envir.cols.names[2]) {
    p <- p + geom_cladelabel(offset = 0.5,extend = 0.4,alpha = 0.8,
                             barsize = 0.8,color = envir.cols[2],
                             label = "",align = T,
                             node = which(hcluster.tree$tip.label == iso.sample) )
  } 
  if (as.character(encirTypes[iso.sample,][2]) == envir.cols.names[3]) {
    p <- p + geom_cladelabel(offset = 0.5,extend = 0.4,alpha = 0.8,
                             barsize = 0.8,color = envir.cols[3],
                             label = "",align = T,
                             node = which(hcluster.tree$tip.label == iso.sample) )
  } 
  if (as.character(encirTypes[iso.sample,][2]) == envir.cols.names[4]) {
    p <- p + geom_cladelabel(offset = 0.5,extend = 0.4,alpha = 0.8,
                             barsize = 0.8,color = envir.cols[4],
                             label = "",align = T,
                             node = which(hcluster.tree$tip.label == iso.sample) )
  } 
  if (as.character(encirTypes[iso.sample,][2]) == envir.cols.names[5]) {
    p <- p + geom_cladelabel(offset = 0.5,extend = 0.4,alpha = 0.8,
                             barsize = 0.8,color = envir.cols[5],
                             label = "",align = T,
                             node = which(hcluster.tree$tip.label == iso.sample) )
  } 
  if (as.character(encirTypes[iso.sample,][2]) == envir.cols.names[6]) {
    p <- p + geom_cladelabel(offset = 0.5,extend = 0.4,alpha = 0.8,
                             barsize = 0.8,color = envir.cols[6],
                             label = "",align = T,
                             node = which(hcluster.tree$tip.label == iso.sample) )
  } 
}

pHeatmap <- gheatmap(p, log10(cluster.df + 1), 
                     offset = 5, width=1,
                     low = "grey85",high = "black",
                     color = "white") 

# ggsave("Figure_6b_raw.pdf", pHeatmap , 
#        units = "in", width = 7.27, height = 4.8) 

ggsave("Figure_6b_raw.pdf", grid.arrange(pHeatmap, pEnvirType, pBarplot, ncol = 2, nrow = 4,
                                          layout_matrix = rbind(c(1,1),
                                                                c(1,1),
                                                                c(1,1),
                                                                c(2,3))), 
       units = "in", width = 4.8, height = 7.2) 

# following modified by PhantomPDF (Foxit) software