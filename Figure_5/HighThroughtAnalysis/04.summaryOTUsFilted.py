# Copyright： qyliang
# email: qfsfdxlqy@163.com
# GitHub: https://github.com/2015qyliang

from Bio import SeqIO
otulist = [ line.strip() for line in open('8.1_summaryOTUsNameList.txt').readlines()]
newseq = []
readscount = 0
for read in SeqIO.parse(open('8.1_summaryOTUs.fasta'),'fasta'):
	if read.id in otulist:
		readscount +=1
		newseq.append('>' + read.id + '\n' + str(read.seq) + '\n')
open('8.1_summaryOTUsFilted.fasta','w').writelines(newseq)
