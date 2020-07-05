# Copyright： qyliang
# email: qfsfdxlqy@163.com
# GitHub: https://github.com/2015qyliang

mkdir taxfile
mkdir otutabfile

ls -lh 6.taxfile/*.txt| awk -F "/" '{print $2}' |awk -F "_" '{print "cp 6.taxfile/"$1"_tax.txt taxfile/"$1".txt" }' > copytax.sh
sh copytax.sh ; rm -rf copytax.sh

ls -lh 5.otutabfile/*.txt| awk -F "/" '{print $2}' |awk -F "_" '{print "cp 5.otutabfile/"$1"_otutab.txt otutabfile/"$1".txt" }' > copyotu.sh
sh copyotu.sh ; rm -rf copyotu.sh
