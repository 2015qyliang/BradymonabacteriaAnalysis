# email: qfsfdxlqy@163.com
# GitHub: https://github.com/2015qyliang

file = [ line for line in open('Figure_6b_SampleGenbankCountA.txt').readlines() ]

newFirstLineBack = [ sample.split('.')[0] for sample in file[0].split('\t')[1:] ]
newFirstLine = file[0].split('\t')[0] + '\t' + '\t'.join(newFirstLineBack) + '\n'

newFile = []
for line in file[1:]:
	header = line.split('\t')[0].split('.')[0] + '\t'
	back = '\t'.join(line.split('\t')[1:])
	newFile.append(header + back)

open('Figure_6b_SampleGenbankCountB.txt', 'w').write(newFirstLine)
open('Figure_6b_SampleGenbankCountB.txt', 'a').writelines(newFile)
