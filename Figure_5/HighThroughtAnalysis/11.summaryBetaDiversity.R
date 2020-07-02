# email: qfsfdxlqy@163.com
# GitHub: https://github.com/2015qyliang

library(vegan) # 2.5-6

system('python 12.getSampleOrderTable.py')

file.df <- read.table('11_Order_OTU_table.txt',
                      header = F,sep = '\t',row.names = 1)
file.df <- file.df[which( rowSums(file.df) != 0 ),]
brayDisMetric <- as.matrix(vegdist(file.df,"bray"))
# save Bray_crutis matrix
write.table(brayDisMetric,'12_BraycurtisMetric.txt',
            quote = F, sep = '\t',
            row.names = T, col.names = F)
