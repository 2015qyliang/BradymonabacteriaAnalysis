# -*- coding: utf-8 -*-
# Copyright： qyliang
# time: 10-16-2018
# email: qfsfdxlqy@163.com
# GitHub: https://github.com/2015qyliang

import os
import sys

def VsearchFlow(processType, idOTU, idChimerotus, idTax):
	# vsearch v2.8.4_linux_x86_64
	for fn in fnlist:
		fnfirst = fn.split('.')[0]
		# 1
		proc11 = 'vsearch --fastq_filter ./0.fqfile/' + fn
		proc12 = ' --fastq_maxee_rate 0.01 --fastaout ./1.filtedfile/'
		process1 = proc11 + proc12 + fnfirst + '_filted.fasta'
		# 2
		# wget http://drive5.com/uchime/rdp_gold.fa
		proc21 = 'vsearch --uchime_ref ./1.filtedfile/' + fnfirst + '_filted.fasta'
		proc22 = ' --db ./rdp_gold.fa --nonchimeras ./2.nonchimerfile/'
		process2 = proc21 + proc22 + fnfirst + '_nonchimer.fasta'
		# 3
		proc31 = 'vsearch --derep_fulllength ./2.nonchimerfile/' + fnfirst + '_nonchimer.fasta'
		proc32 = ' --sizeout --minuniquesize 2 --output ./3.uniquesfile/'
		process3 = proc31 + proc32 + fnfirst + '_uniques.fasta'
		# 4
		proc41 = 'vsearch --cluster_fast ./3.uniquesfile/' + fnfirst + '_uniques.fasta --id '
		proc42 = idOTU + ' --centroids ./4.otusfile/'
		process4 = proc41 + proc42 + fnfirst + '_otus.fasta' + ' --relabel ' + fnfirst +'_otu_'
		# 5
		proc51 = 'vsearch --usearch_global ./2.nonchimerfile/' + fnfirst + '_nonchimer.fasta'+ ' --db '
		proc52 = './4.otusfile/' + fnfirst + '_otus.fasta --id '
		proc53 = idChimerotus + ' --otutabout ./5.otutabfile/'
		process5 = proc51 + proc52 + proc53 + fnfirst + '_otutab.txt'
		# 6
		proc61 = 'vsearch --usearch_global ./4.otusfile/'  + fnfirst + '_otus.fasta'
		proc62 = ' --db ./vsearchsilva.udb --id ' + idTax + ' --blast6out ./6.taxfile/'
		process6 = proc61 + proc62 + fnfirst + '_tax.txt'

		if processType == '1-6':
			print('='*80)
			print('='*10,' Which is file on going? ',fn)
			print('='*10,' File order? ',fnlist.index(fn)+1)
			os.system(process1)
			os.system(process2)
			os.system(process3)
			os.system(process4)
			os.system(process5)
			os.system(process6)
		elif processType == '2-6':
			print('='*80)
			print('='*10,' Which is file on going? ',fn)
			print('='*10,' File order? ',fnlist.index(fn)+1)
			print('='*10,'idOTU:', idOTU, 'idChimerotus:', idChimerotus, 'idTax:', idTax)
			os.system(process2)
			os.system(process3)
			os.system(process4)
			os.system(process5)
			os.system(process6)
		elif processType == '3-6':
			print('='*80)
			print('='*10,' Which is file on going? ',fn)
			print('='*10,' File order? ',fnlist.index(fn)+1)
			print('='*10,'idOTU:', idOTU, 'idChimerotus:', idChimerotus, 'idTax:', idTax)
			os.system(process3)
			os.system(process4)
			os.system(process5)
			os.system(process6)
		elif processType == '6':
			print('='*80)
			print('='*10,' Which is file on going? ',fn)
			print('='*10,' File order? ',fnlist.index(fn)+1)
			os.system(process6)
		else:
			pass

processType = sys.argv[1] # '1-6' '2-6' '6' '3-6'

os.chdir(os.getcwd())

if processType == '1-6':
	fnlist = os.listdir('0.fqfile/')
elif processType == '2-6':
	fileAddr = '1.filtedfile/'
	fnlist = [ fn.split('_')[0] + '.fasta' for fn in os.listdir(fileAddr) ]
elif processType == '3-6':
	fileAddr = '2.nonchimerfile/'
	fnlist = [ fn.split('_')[0] + '.fasta' for fn in os.listdir(fileAddr) ]
elif processType == '6':
	fileAddr = '4.otusfile/'
	fnlist = [ fn.split('_')[0] + '.fasta' for fn in os.listdir(fileAddr) ]
else:
	pass
print(fnlist)
# species, 0.97; genus, 0.93; family, 0.86; order, 0.82
VsearchFlow(processType, idOTU = '0.97', idChimerotus = '0.8', idTax = '0.82')
