# email: qfsfdxlqy@163.com
# GitHub: https://github.com/2015qyliang

library(fossil)
# summary Alpha Diversity:
# ace, goods_coverage, observed_otus, shannon, simpson
system('python 10.AlphaDiversityPartial.py')
# summary Alpha Diversity:
# chao1
file.list <- list.files('8.rarefaction')
chao1.vector <- c()
for (fn in file.list) {
  fn.path <- paste0('8.rarefaction/',fn)
  file.content <- read.table(fn.path, header = F,sep = '\t')
  chao1(file.content$V2)
  chao1.str <- paste0( strsplit(fn,'_')[[1]][1],'\t',chao1(file.content$V2))
  chao1.vector <- append(chao1.vector,chao1.str)
}
write(chao1.vector,'adiv_chao1.txt')

# summary Alpha Diversity
adiv.ace <- read.table('adiv_ace.txt', header = F, sep = '\t')
adiv.chao1 <- read.table('adiv_chao1.txt', header = F, sep = '\t')
adiv.shannon <- read.table('adiv_shannon.txt', header = F, sep = '\t')
adiv.simpson <- read.table('adiv_simpson.txt', header = F, sep = '\t')
adiv.goods_coverage <- read.table('adiv_goods_coverage.txt', header = F, sep = '\t')
adiv.observed_otus <- read.table('adiv_observed_otus.txt', header = F, sep = '\t')
colnames(adiv.ace) <- c('Samples', 'ace')
colnames(adiv.chao1) <- c('Samples', 'chao1')
colnames(adiv.shannon) <- c('Samples', 'shannon')
colnames(adiv.simpson) <- c('Samples', 'simpson')
colnames(adiv.goods_coverage) <- c('Samples', 'goods_coverage')
colnames(adiv.observed_otus) <- c('Samples', 'observed_otus')

adiv.summary <- merge(adiv.ace, adiv.chao1, 
                      by = "Samples", all.x = TRUE)
adiv.summary <- merge(adiv.summary, adiv.shannon, 
                      by = "Samples", all.x = TRUE)
adiv.summary <- merge(adiv.summary, adiv.simpson, 
                      by = "Samples", all.x = TRUE)
adiv.summary <- merge(adiv.summary, adiv.goods_coverage, 
                      by = "Samples", all.x = TRUE)
adiv.summary <- merge(adiv.summary, adiv.observed_otus, 
                      by = "Samples", all.x = TRUE)

write.table(adiv.summary, 'SummaryAlphaDiversity.txt', 
            quote = F, sep = '\t',
            row.names = F, col.names = T)

system('rm adiv_*.txt')
