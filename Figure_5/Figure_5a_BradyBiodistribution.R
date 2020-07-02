# email: qfsfdxlqy@163.com
# GitHub: https://github.com/2015qyliang

library(ggplot2)
library(maps)

# make Run location dataset
all.run.set <- read.table("Figure_5a_GeoInformation.txt",header = T,sep = '\t')
bradymonadales.yes <- all.run.set[which(all.run.set$percentReads >= 0.001),]

# make map figure
worldmap <- map_data("world")
p <- ggplot() + 
  theme(panel.background = element_rect(fill = "white", colour = "grey50")) +
  geom_polygon(data = worldmap,aes(x =long, y = lat, group = group),
               fill = "grey89",colour="grey40",size = 0.05)

# ---------------------------------------------------------------------------------
# add bradymonadales.yes to figure 
p + geom_point(data = bradymonadales.yes,
               mapping = aes(x = Long, y = Lat,size = factor(percentSize),
                             fill = factor(EnvirTypes)),
               alpha = 0.8,shape = 21,color = "white",stroke = 0.05) +
  scale_fill_manual(values = c("#AFD888", "#00A779", "#63ADD0", "#FF4540", 
                               "#D836C4", "#EE6B9E", "#FF8F40", "#FFFA73"),
                    name = "Node color for sample environmental type",
                    limits=c("NSLS", "NSS", "NSW", "SW", "MS", "SS", "SLS", "SLW")) +
  scale_size_discrete(labels = c("0.1","0.5","1","3"))+
  scale_y_discrete(labels = NULL,breaks = NULL) + 
  scale_x_continuous(labels = NULL,breaks = NULL) +
  theme(axis.title.y=element_blank(),
        axis.title.x=element_blank(),
        legend.position = "bottom",axis.title =element_text(),
        legend.key = element_blank()) + 
  guides(size = guide_legend(label.position = "bottom",
                             label.theme = element_text(angle = 90, hjust = 1, vjust = 0.6),
                             title.theme = element_text(face = "bold"),
                             title.position = "top",
                             title = "Node size for relative abundance (%)",
                             title.hjust = 0.5),
         fill = guide_legend(label.position = "bottom",
                              label.theme = element_text(angle = 90, hjust = 1, vjust = 0.6),
                              nrow = 1,
                              override.aes = list(size=6),
                              title.theme = element_text(face = "bold"),
                              title.position = "top",
                              title.hjust = 0.5)) 

# Save the plot to a pdf
ggsave("Figure_5a_BradyBiodistribution_raw.pdf",units = "in",width = 7.27, height = 4.8)

# save config
# 7.27 * 4.8 in

# following modified by PhantomPDF (Foxit) software

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
summary(bradymonadales.yes$EnvirTypes)
summary(all.run.set$EnvirTypes)

names(summary(bradymonadales.yes$EnvirTypes))
names(summary(all.run.set$EnvirTypes))

percentSample <- paste0(summary(bradymonadales.yes$EnvirTypes), 
       "/", 
       summary(all.run.set$EnvirTypes))
names(percentSample) <- names(summary(bradymonadales.yes$EnvirTypes))

percentSample