# email: qfsfdxlqy@163.com
# GitHub: https://github.com/2015qyliang

library(ggplot2)
library(grid)

file.df <- read.table('Figure_S5_AlphaDiv.txt', 
                      header = T,sep = '\t',row.names = 1)
p_ace <- ggplot(data = file.df,
                aes(x = EnvirTypes,y = ace, 
                    fill = factor(EnvirTypes))) +
  geom_jitter(width = 0.28,alpha= 0.1)+
  geom_boxplot(alpha = 0.8)+ 
  scale_y_continuous() +
  scale_x_discrete(limits = c("NSLS", "NSS", 
                              "NSW", "SLS", "SLW",
                              "SS", "MS", "SW"),
                   labels = c("NSLS", "NSS", 
                              "NSW", "SLS", "SLW",
                              "SS", "MS", "SW")) + 
  labs(x = "") + 
  scale_fill_manual(limits=c("NSLS", "NSS", "NSW", "SW", "MS", "SS", "SLS", "SLW"),
                    values=c("#AFD888", "#00A779", "#63ADD0", "#FF4540", 
                             "#D836C4", "#EE6B9E", "#FF8F40", "#FFFA73"))+
  theme_bw()+
  theme(panel.grid =element_blank(),legend.position = "none")

p_chao1 <- ggplot(data = file.df,
                  aes(x = EnvirTypes,y = chao1, 
                      fill = factor(EnvirTypes))) +
  geom_jitter(width = 0.28,alpha= 0.1)+
  geom_boxplot(alpha = 0.8)+ 
  scale_y_continuous() + theme_bw() +
  labs(x = "") + theme(axis.text.x = element_blank()) + 
  scale_fill_manual(limits=c("NSLS", "NSS", "NSW", "SW", "MS", "SS", "SLS", "SLW"),
                    values=c("#AFD888", "#00A779", "#63ADD0", "#FF4540", 
                             "#D836C4", "#EE6B9E", "#FF8F40", "#FFFA73"))+
  scale_x_discrete(limits = c("NSLS", "NSS", 
                              "NSW", "SLS", "SLW",
                              "SS", "MS", "SW"),
                   labels = c("NSLS", "NSS", 
                              "NSW", "SLS", "SLW",
                              "SS", "MS", "SW")) + 
  theme(panel.grid =element_blank(),legend.position = "none")

p_observed_otus <- ggplot(data = file.df,
                          aes(x = EnvirTypes,y = observed_otus, 
                              fill = factor(EnvirTypes))) +
  geom_jitter(width = 0.28,alpha= 0.1)+
  geom_boxplot(alpha = 0.8)+ 
  scale_y_continuous() + theme_bw() +
  labs(x = "") + theme(axis.text.x = element_blank()) + 
  scale_fill_manual(limits=c("NSLS", "NSS", "NSW", "SW", "MS", "SS", "SLS", "SLW"),
                    values=c("#AFD888", "#00A779", "#63ADD0", "#FF4540", 
                             "#D836C4", "#EE6B9E", "#FF8F40", "#FFFA73"))+
  scale_x_discrete(limits = c("NSLS", "NSS", 
                              "NSW", "SLS", "SLW",
                              "SS", "MS", "SW"),
                   labels = c("NSLS", "NSS", 
                              "NSW", "SLS", "SLW",
                              "SS", "MS", "SW")) + 
  theme(panel.grid =element_blank(),legend.position = "none")

p_shannon <- ggplot(data = file.df,
                    aes(x = EnvirTypes,y = shannon, 
                        fill = factor(EnvirTypes))) +
  geom_jitter(width = 0.28,alpha= 0.1)+
  geom_boxplot(alpha = 0.8)+ 
  scale_y_continuous() + theme_bw() +
  labs(x = "") + theme(axis.text.x = element_blank()) + 
  scale_fill_manual(limits=c("NSLS", "NSS", "NSW", "SW", "MS", "SS", "SLS", "SLW"),
                    values=c("#AFD888", "#00A779", "#63ADD0", "#FF4540", 
                             "#D836C4", "#EE6B9E", "#FF8F40", "#FFFA73"))+
  scale_x_discrete(limits = c("NSLS", "NSS", 
                              "NSW", "SLS", "SLW",
                              "SS", "MS", "SW"),
                   labels = c("NSLS", "NSS", 
                              "NSW", "SLS", "SLW",
                              "SS", "MS", "SW")) + 
  theme(panel.grid =element_blank(),legend.position = "none")

p_simpson <- ggplot(data = file.df,
                    aes(x = EnvirTypes,y = simpson, 
                        fill = factor(EnvirTypes))) +
  geom_jitter(width = 0.28,alpha= 0.1)+
  geom_boxplot(alpha = 0.8)+ 
  scale_y_continuous() + theme_bw() +
  labs(x = "") + theme(axis.text.x = element_blank()) + 
  scale_fill_manual(limits=c("NSLS", "NSS", "NSW", "SW", "MS", "SS", "SLS", "SLW"),
                    values=c("#AFD888", "#00A779", "#63ADD0", "#FF4540", 
                             "#D836C4", "#EE6B9E", "#FF8F40", "#FFFA73"))+
  scale_x_discrete(limits = c("NSLS", "NSS", 
                              "NSW", "SLS", "SLW",
                              "SS", "MS", "SW"),
                   labels = c("NSLS", "NSS", 
                              "NSW", "SLS", "SLW",
                              "SS", "MS", "SW")) + 
  theme(panel.grid =element_blank(),legend.position = "none")

p_goods_coverage <- ggplot(data = file.df,
                           aes(x = EnvirTypes,y = goods_coverage, 
                               fill = factor(EnvirTypes))) +
  geom_jitter(width = 0.28,alpha= 0.1)+
  geom_boxplot(alpha = 0.8)+ 
  scale_y_continuous() + theme_bw() +
  labs(x = "") + theme(axis.text.x = element_blank()) + 
  scale_fill_manual(limits=c("NSLS", "NSS", "NSW", "SW", "MS", "SS", "SLS", "SLW"),
                    values=c("#AFD888", "#00A779", "#63ADD0", "#FF4540", 
                             "#D836C4", "#EE6B9E", "#FF8F40", "#FFFA73"))+
  scale_x_discrete(limits = c("NSLS", "NSS", 
                              "NSW", "SLS", "SLW",
                              "SS", "MS", "SW"),
                   labels = c("NSLS", "NSS", 
                              "NSW", "SLS", "SLW",
                              "SS", "MS", "SW")) + 
  theme(panel.grid =element_blank(),legend.position = "none")

grid.newpage()  
pushViewport(viewport(layout = grid.layout(3,2))) 
vplayout <- function(x,y){viewport(layout.pos.row = x, layout.pos.col = y)}  
print(p_goods_coverage, vp = vplayout(1,1))   
print(p_simpson, vp = vplayout(2,1))  
print(p_shannon, vp = vplayout(3,1))   
print(p_observed_otus, vp = vplayout(1,2))  
print(p_chao1, vp = vplayout(2,2))  
print(p_ace, vp = vplayout(3,2))  

# Export set:
# 5.0 * 7.5
# Figure_S5_AlphaDiv_raw.pdf

# following modified by PhantomPDF (Foxit) software
