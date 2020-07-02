# Copyright： qyliang
# email: qfsfdxlqy@163.com
# GitHub: https://github.com/2015qyliang

from skbio.diversity import alpha_diversity
import os

workpath = os.getcwd()
totalDict = { line.strip():0 for line in  open('8.1_summaryOTUsNameListFilted.txt').readlines()}

dataList = []
idsList = []

filelist = os.listdir('8.rarefaction')
os.chdir('8.rarefaction')
for fn in filelist:
	idsList.append(fn.split('_otuTab')[0])
	textDict = { line.split('\t')[0]:line.strip().split('\t')[1]  for line in open(fn).readlines()[1:] }
	tmpList = [ int(textDict[k]) if k in textDict.keys() else int(totalDict[k])  for k,v in totalDict.items() ]
	dataList.append(tmpList)
	# print('--- Done -- ',fn)
os.chdir(workpath)
print('---- Computing alpha diversities ----')
print('---- Length of dataList: ',len(dataList))
print('---- Length of idsList: ', len(idsList))

adiv_observed_otus = alpha_diversity('observed_otus', dataList, idsList)
print('adiv_obs_otus--',type(adiv_observed_otus))
open('adiv_observed_otus.txt','w').writelines( [ str(i) + '\t' + str(adiv_observed_otus[i]) + '\n' for i in adiv_observed_otus.index ] )
adiv_ace = alpha_diversity('ace', dataList, idsList)
print('adiv_ace--',type(adiv_ace))
open('adiv_ace.txt','w').writelines( [ str(i) + '\t' + str(adiv_ace[i]) + '\n' for i in adiv_ace.index ] )
# adiv_chao1_ci = alpha_diversity('chao1_ci', dataList, idsList)
# print('adiv_chao1_ci--',type(adiv_chao1_ci))
# open('adiv_chao1_ci.txt','w').writelines( [ str(i) + '\t' + str(adiv_chao1_ci[i]) + '\n' for i in adiv_chao1_ci.index ] )
adiv_shannon = alpha_diversity('shannon', dataList, idsList)
print('adiv_shannon--',type(adiv_shannon))
open('adiv_shannon.txt','w').writelines( [ str(i) + '\t' + str(adiv_shannon[i]) + '\n' for i in adiv_shannon.index ] )
adiv_simpson = alpha_diversity('simpson', dataList, idsList)
print('adiv_simpson--',type(adiv_simpson))
open('adiv_simpson.txt','w').writelines( [ str(i) + '\t' + str(adiv_simpson[i]) + '\n' for i in adiv_simpson.index ] )
# adiv_simpson_e = alpha_diversity('simpson_e', dataList, idsList)
# print('adiv_simpson_e--',type(adiv_simpson_e))
# open('adiv_simpson_e.txt','w').writelines( [ str(i) + '\t' + str(adiv_simpson_e[i]) + '\n' for i in adiv_simpson_e.index ] )
adiv_goods_coverage = alpha_diversity('goods_coverage', dataList, idsList)
print('adiv_goods_coverage--',type(adiv_goods_coverage))
open('adiv_goods_coverage.txt','w').writelines( [ str(i) + '\t' + str(adiv_goods_coverage[i]) + '\n' for i in adiv_goods_coverage.index ] )
