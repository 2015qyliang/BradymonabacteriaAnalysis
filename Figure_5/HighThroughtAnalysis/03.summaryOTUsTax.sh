# Copyright： qyliang
# email: qfsfdxlqy@163.com
# GitHub: https://github.com/2015qyliang

mv 8.rarefaction/1_summaryOTUs.fasta 8.1_summaryOTUs.fasta
grep ">" 8.1_summaryOTUs.fasta | awk -F ">" '{print $2}' > 8.1_summaryOTUsNameList.txt

python 04.summaryOTUsFilted.py

vsearch  --usearch_global  8.1_summaryOTUsFilted.fasta  --db ./vsearchsilva.udb --id 0.60  --blast6out  8.1_summaryOTUsFilted_tax.txt
