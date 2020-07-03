# email: qfsfdxlqy@163.com
# GitHub: https://github.com/2015qyliang

library(ggplot2)
library(grid)


# Figure a
geo.infor <- read.table("Figure_S8_GeoInformation.txt", header = T,sep = '\t',
                        row.names = 1,stringsAsFactors = F)
predator.sum <- all.Brady$V7 + all.Bdell$V7 + all.Myxoc$V7
enTypes <- geo.infor[ rownames(all.Brady),"EnvirTypes"]
all.df <- data.frame(predator.sum, 
                     samples = rep("TotalSamples", length(predator.sum)),
                     envir = enTypes)
p2a <- ggplot(all.df, aes(x=factor(envir),
                          y=predator.sum,
                          fill = factor(envir),
                          alpha = 0.7))+
  geom_boxplot() + geom_jitter(alpha = 0.075) +
  facet_grid(.~samples)+
  scale_fill_manual(values = c("#AFD888", "#00A779", "#63ADD0", "#FF4540", 
                               "#D836C4", "#EE6B9E", "#FF8F40", "#FFFA73"),
                    name = "Node color for sample environmental type",
                    limits=c("NSLS", "NSS", "NSW", "SW", "MS", "SS", "SLS", "SLW"))+
  scale_x_discrete(limits = c("NSLS", "NSS", 
                              "NSW", "SLS", "SLW",
                              "SS", "MS", "SW"),
                   labels = c("NSLS", "NSS", 
                              "NSW", "SLS", "SLW",
                              "SS", "MS", "SW")) + 
  theme_bw()+labs(x = "", y = "Relative abundance") +
  theme(panel.grid =element_blank(),
        legend.position = "none",
        axis.text.x = element_text(size = 2))


# Figure b
all.Brady <- read.table("Figure_S8b_Bradymonadales.txt",header = F,
                        sep = '\t',row.names = 1,
                        stringsAsFactors = F)
all.Bdell <- read.table("Figure_S8b_Bdellovibrionales.txt",header = F,
                        sep = '\t',row.names = 1,
                        stringsAsFactors = F)
all.Myxoc <- read.table("Figure_S8b_Myxococcales.txt",header = F,
                        sep = '\t',row.names = 1,
                        stringsAsFactors = F)
bacPercent <- c(all.Brady[which(all.Brady$V7 > 0.001),"V7"], 
                all.Bdell[which(all.Brady$V7 > 0.001),"V7"], 
                all.Myxoc[which(all.Brady$V7 > 0.001),"V7"])
rep.num1 <- length(all.Brady[which(all.Brady$V7 > 0.001),"V7"])
rep.num2 <- length(all.Bdell[which(all.Brady$V7 > 0.001),"V7"])
rep.num3 <- length(all.Myxoc[which(all.Brady$V7 > 0.001),"V7"])
bacGroup <- c(rep("B1radymonadales", rep.num1), 
              rep("B2dellovibrionales", rep.num2), 
              rep("Myxococcales", rep.num3))
bacTmp <- rep("bactmp", rep.num1 + rep.num2 +rep.num3)
all.samples.percent <- data.frame(bacGroup, bacPercent, bacTmp)
labels <- c(B1radymonadales = "Bradymonadales", 
            B2dellovibrionales = "Bdellovibrionales",
            Myxococcales = "Myxococcales")
p2b <- ggplot(all.samples.percent, aes(x=factor(bacTmp),
                                       y=bacPercent))+
  geom_boxplot() + geom_jitter(alpha = 0.075) +
  facet_grid(.~bacGroup, 
             labeller = labeller(bacGroup = labels))+
  theme_bw()+labs(x = "", y = "Relative abundance") +
  theme(panel.grid = element_blank(),
        legend.position = "none", 
        axis.text.x = element_blank())


# Figure c
geo.infor <- read.table("Figure_S8_GeoInformation.txt",header = T,sep = '\t',
                        row.names = 1,stringsAsFactors = F)
enTypes <- geo.infor[ rownames(all.Brady),"EnvirTypes"]
bacPercent <- c(all.Brady$V7, all.Bdell$V7, all.Myxoc$V7)
bacGroup <- c(rep("B1rady", length(all.Brady$V7)),
              rep("B2dell", length(all.Bdell$V7)),
              rep("Myxoc", length(all.Myxoc$V7)))
envir <- c(enTypes,enTypes,enTypes)
all.df <- data.frame(bacPercent, bacGroup, envir)
all.df <- all.df[which(all.df$envir %in% c("SLS","SLW")), ]
p2c <- ggplot(all.df, aes(x=factor(bacGroup),
                          y=bacPercent,
                          fill = factor(bacGroup),
                          alpha = 0.7))+
  geom_boxplot() + geom_jitter(alpha = 0.1) +
  facet_grid(.~envir)+
  scale_x_discrete(limits = c("B1rady", "B2dell", "Myxoc"),
                   labels = c("Bradymonadales", "Bdellovibrionales", "Myxococcales")) + 
  theme_bw()+labs(x = "", y = "Relative abundance") +
  theme(panel.grid =element_blank(),
        legend.position = "none", 
        axis.text.x = element_text(angle = -20, size = 4))


# Figure d
Saltern.df <- read.table("Figure_S8d_Saltern.txt",header = T, 
                         sep = '\t',stringsAsFactors = F)
Saltern.df[which(Saltern.df$bacgroups == "1bradymonadales"), 'bacgroups'] <- 'b1radymonadales'
Saltern.df[which(Saltern.df$bacgroups == "2bdellovibrionales"), 'bacgroups'] <- 'b2dellovibrionales'
labels <- c(b1radymonadales = "Bradymonadales", 
            b2dellovibrionales = "Bdellovibrionales",
            Myxococcales = "Myxococcales")
p2d <- ggplot(Saltern.df, aes(x=factor(types), 
                              y=values,
                              fill=types,
                              alpha = 0.6))+
  geom_boxplot() + geom_jitter(alpha = 0.3) +
  facet_grid(.~bacgroups, 
             labeller = labeller(bacgroups = labels))+
  scale_x_discrete(limits = c("1S45", "2S8", "S125", "S175", "S265"),
                   labels = c("S45", "S80", "S125", "S175", "S265")) + 
  theme_bw()+labs(x = "", y = "Relative abundance") +
  theme(panel.grid =element_blank(),legend.position = "none")


# summary
grid.newpage()
VP <- viewport(layout = grid.layout(2, 2))
pushViewport(VP)
vplayout <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
print(p2a, vp = vplayout(1, 1))
print(p2b, vp = vplayout(1, 2))
print(p2c, vp = vplayout(2, 1))
print(p2d, vp = vplayout(2, 2))

# Export set:
#  6 * 8 in
# Figure_S8_raw.pdf

# following modified by PhantomPDF (Foxit) software

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
library(ggpubr)
geo.infor <- read.table("Figure_S8_GeoInformation.txt",header = T,sep = '\t',
                        row.names = 1,stringsAsFactors = F)
enTypes <- geo.infor[ rownames(all.Brady),"EnvirTypes"]
bacPercent <- c(all.Brady$V7, all.Bdell$V7, all.Myxoc$V7)
bacGroup <- c(rep("B1rady", length(all.Brady$V7)),
              rep("B2dell", length(all.Bdell$V7)),
              rep("Myxoc", length(all.Myxoc$V7)))
envir <- c(enTypes,enTypes,enTypes)
all.df <- data.frame(bacPercent, bacGroup, envir)
all.df <- all.df[which(all.df$envir %in% c("SLS","SLW")), ]
my_comparisons1 <- list( c("B1rady", "B2dell"),
                         c("B2dell", "Myxoc"),
                         c("B1rady", "Myxoc"))
p2cCompare <- ggplot(all.df, aes(x=factor(bacGroup),
                                 y=bacPercent,
                                 fill = factor(bacGroup),
                                 alpha = 0.7))+
  geom_boxplot() + geom_jitter(alpha = 0.1) +
  facet_grid(.~envir)+
  stat_compare_means(comparisons = my_comparisons1,
                     label = "p.signif") +
  theme_bw()+labs(x = "", y = "Relative abundance (%)") +
  theme(panel.grid =element_blank(),
        legend.position = "none")
p2cCompare
