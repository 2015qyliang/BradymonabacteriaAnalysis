# Copyright： qyliang
# email: qfsfdxlqy@163.com
# GitHub: https://github.com/2015qyliang

import os
workpath = os.getcwd()
filenames = os.listdir('6.taxfile')
text = []
os.chdir('6.taxfile')
for fn in filenames:
	tmpcontent = open(fn).readlines()
	for line in tmpcontent:
		if '_f_' in line and '_o_' in line :
			text.append(line.split('_f_')[0].split('_o_')[1] + '\n')
		if '_o_' in line and '_f_' not in line:
			text.append(line.strip().split('_o_')[1].split('\t')[0] + '\n')
os.chdir(workpath)
open('order.list','w').writelines(set(text))
