# email: qfsfdxlqy@163.com
# GitHub: https://github.com/2015qyliang

library(ggplot2)
library(ggfortify)
library(vegan) # 2.5-6

file.df <- read.table('Figure_5b_BraycrutisMetricEnvirType.txt',
                      header = F,sep = '\t',row.names = 1)
colnames(file.df) <- c( rownames(file.df),"EnvirTypes", "salineType" )
df <- file.df[,c(1:(length(rownames(file.df))))]
pca <- prcomp(df)

p <- autoplot(pca, data = file.df, 
              colour = 'EnvirTypes',
              alpha = 0.8,size = 0.6) +
  scale_color_manual(values = c("#AFD888", "#00A779", "#63ADD0", "#FF4540",
                                "#D836C4", "#EE6B9E", "#FF8F40", "#FFFA73"),
                     limits=c("NSLS", "NSS", "NSW", "SW",
                              "MS", "SS", "SLS", "SLW"),
                     name = "EnvirTypes") +
  geom_hline(yintercept=0, colour="#000000", linetype="dashed")+
  geom_vline(xintercept=0, colour="#000000", linetype="dashed")+
  theme( panel.background = element_rect(fill="white",color="black"),
         panel.grid = element_blank(), legend.position = "right",
         legend.key = element_blank())

# Export Set:
# 4*6

# ggsave(p, 'Figure_5b_BetaDivBraycrutisPCA_raw.pdf', 
#        units = 'in', width = 6, height = 4)

# following modified by PhantomPDF (Foxit) software