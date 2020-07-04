# Copyright： qyliang
# email: qfsfdxlqy@163.com
# GitHub: https://github.com/2015qyliang

import os

workpath = os.getcwd()
os.chdir(workpath)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# 8.1_summaryOTUsFilted_tax.txt
# 8.1_summaryOTUsNameList.txt
new = []
for line in open('8.1_summaryOTUsFilted_tax.txt').readlines():
	if '_tax_' not in line:
		print(line)
		newline = line.replace('_Eukaryota;','_tax_k_Eukaryota_p_')
		new.append(newline)
	else:
		new.append(line)
test = [ line.split('\t')[0] + '\t' + line.split('_tax_')[1].split('\t')[0] for line in new if '_tax_' in line ]
newfile = []
for line in test:
	if '_p_' in line:
		line = line.replace('_p_', '	p_')
	if '_c_' in line:
		line = line.replace('_c_', '	c_')
	if '_o_' in line:
		line = line.replace('_o_', '	o_')
	if '_f_' in line:
		line = line.replace('_f_', '	f_')
	if '_g_' in line:
		line = line.replace('_g_', '	g_')
	if '_s_' in line:
		line = line.replace('_s_', '	s_')
	newfile.append(line)
OtuTax = { line.split('\t')[0]:('\t'.join(line.split('\t')[1:])) for line in newfile }
OtuList = [ line.strip() for line in open('8.1_summaryOTUsNameList.txt').readlines() ]
OtuTaxFile = []
for otu in OtuList:
	if otu in OtuTax.keys():
		if '	o_' in OtuTax[otu]:
			tax = '_'.join(OtuTax[otu].split('\t')[:4]) + '\n'
			newline = otu + '\t' + tax[2:]
			OtuTaxFile.append(newline)
		else:
			print('- ', otu, ' -')
open('8.1_summaryOTUs_order_tax.txt ', 'w').writelines(set(OtuTaxFile))

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
fileList = os.listdir('8.rarefaction/')
otuTaxDict = { line.split('\t')[0]:line.strip().split('\t')[1].replace('(','').replace(')','').replace('-','') for line in open('8.1_summaryOTUs_order_tax.txt').readlines() }
orderTaxList = list(set([ line.strip().split('\t')[1].replace('(','').replace(')','').replace('-','') for line in open('8.1_summaryOTUs_order_tax.txt').readlines() ]))

if not os.path.exists('10.rarefaction'):
	os.mkdir('10.rarefaction')

for fn in fileList:
	os.chdir(workpath)
	os.chdir('8.rarefaction')
	fnCountDict = { k:int(0) for k in orderTaxList }
	sampleHeader = fn.split('_otu')[0]
	textDict = { line.split('\t')[0]:line.strip().split('\t')[1] for line in open(fn).readlines()[1:] }
	for sampleOTU,readsCount in textDict.items():
		if sampleOTU in otuTaxDict.keys():
			fnCountDict[ otuTaxDict[sampleOTU] ] += int(readsCount)
	os.chdir(workpath)
	os.chdir('10.rarefaction')
	with open(fn,'w') as file:
		for k,v in fnCountDict.items():
			file.write(k + '\t' + str(v) + '\n')
	print('-- Done file ',fileList.index(fn)+1,' of ', len(fileList))

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
os.chdir(workpath)
dataList = []
idsList = []
filelist = os.listdir('10.rarefaction')
os.chdir('10.rarefaction')
for fn in filelist:
	idsList.append(fn.split('_otuTab')[0])
	textDict = { line.split('\t')[0]:line.strip().split('\t')[1]  for line in open(fn).readlines() }
	tmpList = [ int(textDict[k]) if k in textDict.keys() else int(0)  for k in orderTaxList ]
	dataList.append(tmpList)
	print('--- Done -- ',fn,' -- order ',filelist.index(fn)+1,' of ',len(filelist))
os.chdir(workpath)
print('---- Computing alpha diversities ----')
print('---- Length of dataList: ',len(dataList))
print('---- Length of idsList: ', len(idsList))

# save sample-OTU table
newtext = []
for i in range(0,len(idsList)):
	newtext.append(idsList[i] + '\t')
	lineList = [ str(item) for item in dataList[i] ]
	newline = '\t'.join(lineList)
	newtext.append(newline + '\n')

open('11_Order_OTU_table.txt','w').writelines(newtext)
