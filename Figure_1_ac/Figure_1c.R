# email: qfsfdxlqy@163.com
# GitHub: https://github.com/2015qyliang

library(ggplot2)
library(grid)
library(RColorBrewer)

tableS1.df <- read.table('Figure_1c_TableS1.txt', 
                         header = T, sep = '\t', stringsAsFactors = F)
tableS1.df.new <- tableS1.df[2:dim(tableS1.df)[1],]
preyType <- as.numeric(tableS1.df.new$Prey_of_FA350) + as.numeric(tableS1.df.new$Prey_of_B210)
preyType[which(preyType > 0)] <- 1
tableS1.df.new <- data.frame(tableS1.df.new, preyType)

cols <- brewer.pal(4,"Set2")
names(cols) <- c("Actinobacteria", "Bacteroidetes", "Firmicutes", "Proteobacteria")

phylum.total <- summary(as.factor(tableS1.df.new$Phylum))
phylum.prey <- summary(as.factor(tableS1.df.new[which(tableS1.df.new$preyType == 1),'Phylum']))
phylum.percent <- phylum.prey/phylum.total
phylum.label <- paste(phylum.prey, phylum.total, sep = '/')
phylum.tax <- names(phylum.total)
phylum.col <- cols[names(phylum.total)]
phylum.df <- data.frame(phylum.tax, phylum.total, 
                        phylum.prey, phylum.percent,
                        phylum.label, phylum.col)
colnames(phylum.df) <- c('Phylum', 'Total', 'Prey', 'Percent', 'Label', 'Cols')

class.total <- summary(as.factor(tableS1.df.new$Class))
class.prey <- summary(as.factor(tableS1.df.new[which(tableS1.df.new$preyType == 1),'Class']))
class.percent <- class.prey/class.total
class.label <- paste(class.prey, class.total, sep = '/')
class.tax <- names(class.total)
dup.class <- tableS1.df.new[!duplicated(tableS1.df.new$Class),'Phylum']
names(dup.class) <- tableS1.df.new[!duplicated(tableS1.df.new$Class),'Class']
class.phylum <- dup.class[names(class.total)]
class.col <- cols[class.phylum]
class.df <- data.frame(class.tax, class.total, 
                       class.prey, class.percent,
                       class.label, class.col)
colnames(class.df) <- c('Class', 'Total', 'Prey', 'Percent', 'Label', 'Cols')

order.total <- summary(as.factor(tableS1.df.new$Order))
order.prey <- summary(as.factor(tableS1.df.new[which(tableS1.df.new$preyType == 1),'Order']))
order.total <- order.total[names(order.prey)]
order.percent <- order.prey/order.total
order.label <- paste(order.prey, order.total, sep = '/')
order.tax <- names(order.total)
dup.order <- tableS1.df.new[!duplicated(tableS1.df.new$Order),'Phylum']
names(dup.order) <- tableS1.df.new[!duplicated(tableS1.df.new$Order),'Order']
dup.order <- dup.order[names(order.prey)]
order.phylum <- dup.order[names(order.total)]
order.col <- cols[order.phylum]
order.df <- data.frame(order.tax, order.total, 
                       order.prey, order.percent,
                       order.label, order.col)
colnames(order.df) <- c('Order', 'Total', 'Prey', 'Percent', 'Label', 'Cols')

p1 <- ggplot(phylum.df, 
             aes(x = Phylum,y = Percent)) + 
  geom_bar(stat="identity",width = 0.5, fill = phylum.df$Cols) + 
  geom_text(aes(x = Phylum,y = Percent, label = Label), 
            angle = 90, hjust = 1) +
  scale_y_continuous(labels = scales::percent)+
  ylab(NULL) + labs(title = 'phylum') +
  theme(panel.grid =element_blank(),
        axis.title.x=element_blank(),
        panel.background = element_rect(fill = "white", 
                                        colour = "grey50"),
        axis.text.x = element_text(angle = -30, 
                                   hjust = 0.05, 
                                   vjust = 0.01,
                                   color = "black",
                                   size=4))

p2 <- ggplot(class.df, 
             aes(x = Class,y = Percent)) + 
  geom_bar(stat="identity",width = 0.5, fill = class.df$Cols) + 
  geom_text(aes(x = Class,y = Percent, label = Label), 
            angle = 90, hjust = 1) +
  scale_y_continuous(labels = scales::percent)+
  ylab(NULL) + labs(title = 'Class') +
  theme(panel.grid =element_blank(),
        axis.title.x=element_blank(),
        panel.background = element_rect(fill = "white", 
                                        colour = "grey50"),
        axis.text.x = element_text(angle = -30, 
                                   hjust = 0.05, 
                                   vjust = 0.01,
                                   color = "black",
                                   size=4))

p3 <- ggplot(order.df, 
             aes(x = Order, y = Percent)) + 
  geom_bar(stat="identity",width = 0.5, fill = order.df$Cols) + 
  geom_text(aes(x = Order,y = Percent, label = Label), 
            angle = 90, hjust = 1) +
  scale_y_continuous(labels = scales::percent)+
  ylab(NULL) + labs(title = 'Order') +
  theme(panel.grid =element_blank(),
        axis.title.x=element_blank(),
        panel.background = element_rect(fill = "white", 
                                        colour = "grey50"),
        axis.text.x = element_text(angle = -30, 
                                   hjust = 0.05, 
                                   vjust = 0.01,
                                   color = "black",
                                   size=4))

grid.newpage()  
pushViewport(viewport(layout = grid.layout(3,2)))
vplayout <- function(x,y){
  viewport(layout.pos.row = x,
           layout.pos.col = y)}  
print(p1, vp = vplayout(1,1))
print(p2, vp = vplayout(1,2)) 
print(p3, vp = vplayout(2,1:2)) 

# following modified by PhantomPDF (Foxit) software
