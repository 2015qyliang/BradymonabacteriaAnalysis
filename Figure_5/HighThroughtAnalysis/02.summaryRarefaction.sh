# 10-16-2018
# Copyright： qyliang
# email: qfsfdxlqy@163.com
# GitHub: https://github.com/2015qyliang

workPath=$PWD
if [[ ! -d "8.rarefaction" ]]; then
	mkdir 8.rarefaction
fi
rm -rf $workPath/8.rarefaction/0_rawAllOTUs.fasta
ls -lrth 3.uniquesfile/*.fasta |awk '{print $9}' > uniquesfile
for fn in $(cat uniquesfile)
do
	cat $fn >> $workPath/8.rarefaction/0_rawAllOTUs.fasta
done
rm -rf uniquesfile

echo " -------- vsearch --cluster -------- "
vsearch --cluster_fast $workPath/8.rarefaction/0_rawAllOTUs.fasta --id 0.97 --centroids $workPath/8.rarefaction/1_summaryOTUs.fasta --relabel OTU

echo " -------- vsearch --usearch_global -------- "
ls -lrth 2.nonchimerfile/*.fasta |awk -F "/" '{print $2}'|awk -F "[_.]" '{print $1}' > nonchimerfile
for fn in $(cat nonchimerfile)
do
	vsearch --usearch_global $workPath/2.nonchimerfile/$fn"_nonchimer.fasta" --db $workPath/8.rarefaction/1_summaryOTUs.fasta --id 0.8 --otutabout $workPath/8.rarefaction/$fn"_otuTab.txt"
done
rm -rf nonchimerfile


