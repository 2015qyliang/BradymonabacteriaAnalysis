# email: qfsfdxlqy@163.com
# GitHub: https://github.com/2015qyliang

library(ggfortify)
library(vegan) # 2.5-6

file.df <- read.table(gzfile('Figure_S6_BraycrutisMetricEnvirType.txt'),
                      header = F,sep = '\t',row.names = 1)
colnames(file.df) <- c( rownames(file.df),"EnvirTypes", "salineType" )
df <- file.df[,c(1:(length(rownames(file.df))))]
pca <- prcomp(df)

salineNum <- summary(file.df$salineType)['saline']
nonsalNum <- summary(file.df$salineType)['non-saline']
p <- autoplot(pca, data = file.df, colour = 'salineType',alpha = 0.8,size = 0.6) + 
  # scale_color_manual(values = c("#000000", "#808080"),
  #                    limits = c("saline", "non-saline"),
  #                    labels = c(paste0("Saline (", salineNum, ")"), 
  #                               paste0("Non_saline (", nonsalNum, ")")
  #                               ))+
  scale_color_manual(values = c("#000000", "#808080"),
                     limits = c("saline", "non-saline"),
                     labels = c(paste0("Saline"), 
                                paste0("Non_saline")
                     ))+
  geom_hline(yintercept=0, colour="#000000", linetype="dashed")+
  geom_vline(xintercept=0, colour="#000000", linetype="dashed")+
  theme( panel.background = element_rect(fill="white",color="black"),
         panel.grid = element_blank(), 
         legend.position = c(0.8,0.9),
         legend.key = element_blank(), 
         legend.title = element_blank()) 
p

# Export Set:
# 4*6
# 
# ggsave(p, 'Figure_S6_BetaDivBraycrutisPCA_raw.pdf',
#        units = 'in', width = 6, height = 4)

# following modified by PhantomPDF (Foxit) software


