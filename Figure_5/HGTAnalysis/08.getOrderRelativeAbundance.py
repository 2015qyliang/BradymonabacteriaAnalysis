# Copyright： qyliang
# email: qfsfdxlqy@163.com
# GitHub: https://github.com/2015qyliang

import numpy as np
import os

# First step: getFamilyTaxlist
workpath = os.getcwd()
filenames = os.listdir('taxfile')
text = []
os.chdir('taxfile')
for fn in filenames:
	tmpcontent = open(fn).readlines()
	for line in tmpcontent:
		if '_f_' in line:
			text.append(line.split('_f_')[0].split('_o_')[1] + '\n')
		if '_f_' not in line and '_o_' in line:
			text.append(line.split('\t')[1].split('_o_')[1] + '\n')
os.chdir(workpath)
open('order.list','w').writelines(set(text))

# Second step: summaryHitOtusReads
orderList = [ line.strip() for line in open('order.list').readlines()]
fileList = os.listdir('taxfile')

if not os.path.exists('9.OrderRelative'):
	os.mkdir('9.OrderRelative')
else:
	os.system('rm -rf 9.OrderRelative')
	os.mkdir('9.OrderRelative')
	
for ordername in orderList:
	print('-- ',orderList.index(ordername)+1,' of ',len(orderList))
	summaryOrder = []
	for fn in fileList:
		otuCount = 0
		readscount = 0
		taxText = open('taxfile/' + fn).readlines()
		otuText = open('otutabfile/' + fn).readlines()[1:]
		totalReads = np.sum([ int(line.strip().split('\t')[1]) for line in otuText ])
		totalOTU = len(taxText)
		for line in open('taxfile/' + fn).readlines():
			if '_o_'+ordername+'_f_' in line:
				otuheader = line.split('\t')[0]
				otuCount += 1
				textOtuDict = { line.split('\t')[0]:line.strip().split('\t')[1] for line in otuText }
				if otuheader in textOtuDict.keys():
					readscount += int(textOtuDict[otuheader])
			if '_o_'+ordername+'\t' in line:
				otuheader = line.split('\t')[0]
				otuCount += 1
				textOtuDict = { line.split('\t')[0]:line.strip().split('\t')[1] for line in otuText }
				if otuheader in textOtuDict.keys():
					readscount += int(textOtuDict[otuheader])
		strline = [str(otuCount),str(totalOTU),str(round(otuCount/totalOTU,5)),str(readscount),str(totalReads),str(round(readscount/totalReads,5))]
		summaryOrder.append(fn.split('.')[0] + '\t' + str( '\t'.join(strline) ) + '\n')
	open('9.OrderRelative/summaryHitOtusReads_'+ordername,'w').writelines(summaryOrder)

os.remove('order.list')

