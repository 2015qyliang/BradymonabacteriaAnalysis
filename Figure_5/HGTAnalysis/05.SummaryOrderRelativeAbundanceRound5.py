# Copyright： qyliang
# email: qfsfdxlqy@163.com
# GitHub: https://github.com/2015qyliang

import numpy as np
import os

os.system('python 06.getDifOrderTaxList.py')
orderList = [ line.strip() for line in open('order.list').readlines()]
fileList = [ fn.split('_')[0] for fn in os.listdir('6.taxfile')]

if os.path.exists('OrderRelativeOtuRound5') == False:
	os.mkdir('OrderRelativeOtuRound5')

for ordername in orderList:
	print('-- ',orderList.index(ordername)+1,' of ',len(orderList))
	summaryOrder = []
	for fn in fileList:
		otuCount = 0
		readscount = 0
		taxText = open('6.taxfile/' + fn + '_tax.txt').readlines()
		otuText = open('5.otutabfile/' + fn + '_otutab.txt').readlines()[1:]
		totalReads = np.sum([ int(line.strip().split('\t')[1]) for line in otuText ])
		totalOTU = len(taxText)
		for line in open('6.taxfile/' + fn + '_tax.txt').readlines():
			if '_o_'+ordername+'_f_' in line:
				otuheader = line.split('\t')[0]
				otuCount += 1
				textOtuDict = { line.split('\t')[0]:line.strip().split('\t')[1] for line in otuText }
				if otuheader in textOtuDict.keys():
					readscount += int(textOtuDict[otuheader])
			if '_o_'+ordername in line and '_f_' not in line:
				otuheader = line.split('\t')[0]
				otuCount += 1
				textOtuDict = { line.split('\t')[0]:line.strip().split('\t')[1] for line in otuText }
				if otuheader in textOtuDict.keys():
					readscount += int(textOtuDict[otuheader])
		strline = [str(otuCount),str(totalOTU),str(round(otuCount/totalOTU,5)),str(readscount),str(totalReads),str(round(readscount/totalReads,5))]
		summaryOrder.append(fn + '\t' + str( '\t'.join(strline) ) + '\n')
	open('OrderRelativeOtuRound5/HitOtusReads_'+ordername,'w').writelines(summaryOrder)

os.remove('order.list')

