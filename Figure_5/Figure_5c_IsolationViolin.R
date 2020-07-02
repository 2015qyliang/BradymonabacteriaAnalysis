# email: qfsfdxlqy@163.com
# GitHub: https://github.com/2015qyliang

# library(ggplot2)
library(ggpubr)

file.content <- read.table('Figure_5c_BradyDifIsolationTable.txt',header = T,sep = '\t')
my_comparisons1 <- list( c("MS", "NSLS"),c("SS", "NSS"),c("MS", "SLS"),c("MS", "SW"),
                         c("SLS", "NSLS"),c("SLS", "NSS"),
                         c("SW", "NSW"),c("SLW", "SLS"))

p <- ggplot(file.content, aes(x = EnvirTypes, y = percentReads, fill = EnvirTypes)) +
  geom_jitter(width = 0.3,alpha= 0.1) +
  geom_boxplot(alpha= 0.75) +
  stat_compare_means(comparisons = my_comparisons1,
                     label = "p.signif") +
  stat_compare_means(label.y = max(file.content$percentReads))+
  scale_y_continuous(labels = scales::percent) +
  scale_fill_manual(values = c("#AFD888", "#00A779", "#63ADD0", "#FF4540",
                               "#D836C4", "#EE6B9E", "#FF8F40", "#FFFA73"),
                    limits=c("NSLS", "NSS", "NSW", "SW", "MS",
                             "SS", "SLS", "SLW"))+
  scale_x_discrete(limits = c("NSLS", "NSS", 
                              "NSW", "SLS", "SLW",
                              "SS", "MS", "SW"),
                   labels = c("NSLS", "NSS", 
                              "NSW", "SLS", "SLW",
                              "SS", "MS", "SW")) + 
  labs(x = "", y = "Relative abundance")+
  theme_bw()+
  theme(panel.grid =element_blank(),legend.position = "none")
ggsave("Figure_5c_BradyIsolationA_raw.pdf",p,
       units = "in",height = 2.6,width = 3.7)


p <- ggplot(file.content, aes(x = EnvirTypes, y = percentReads, fill = EnvirTypes)) +
  geom_jitter(width = 0.3,alpha= 0.1) +
  geom_boxplot(alpha= 0.75) +
  # stat_compare_means(comparisons = my_comparisons1,
  #                    label = "p.signif") +
  # stat_compare_means(label.y = max(file.content$percentReads))+
  scale_y_continuous(labels = scales::percent) +
  scale_fill_manual(values = c("#AFD888", "#00A779", "#63ADD0", "#FF4540",
                               "#D836C4", "#EE6B9E", "#FF8F40", "#FFFA73"),
                    limits=c("NSLS", "NSS", "NSW", "SW", "MS",
                             "SS", "SLS", "SLW"))+
  scale_x_discrete(limits = c("NSLS", "NSS", 
                              "NSW", "SLS", "SLW",
                              "SS", "MS", "SW"),
                   labels = c("NSLS", "NSS", 
                              "NSW", "SLS", "SLW",
                              "SS", "MS", "SW")) + 
  labs(x = "", y = "Relative abundance")+
  theme_bw()+
  theme(panel.grid =element_blank(),legend.position = "none")
ggsave("Figure_5c_BradyIsolationB_raw.pdf",p,
       units = "in",height = 2.6,width = 3.7)

# width = 4.60,height = 2.5

# following modified by PhantomPDF (Foxit) software

