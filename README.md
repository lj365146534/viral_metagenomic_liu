#宏基因组流程

#1 序列质控
#1.0 去除Q值低的碱基
由公司的进行的质控，拿到手的就是clean data
#1.1 序列质控可以使用相应宿主的全基因组序列过滤
根据鸟的科来给样本去除宿主基因组，详情见表
#1.2 去除rRNA序列 Silver数据库
根据SILVA_138.1_LSUref_SSURef_NR99_tax来去除rRNA的数据
#2 组装
#2.0 分别组装megahit默认参数
结果并不使用
#2.1 合并组装成一个大contigs.fa
经过25小时的运算，将250个样本fastq文件通过megahit进行组装，共获得200,819条序列，序列总长205,939,697bp ,最长的contigs有38,844bp,平均长度1,025bp,N50为1073bp。
#200819 contigs, total 205939697 bp, min 500 bp, max 38844 bp, avg 1025 bp, N50 1073 bp



#3 基因定量
#3.1 prodigal预测gene并翻译成氨基酸
预测ORFs，预测基因313,233条，统计其中完整基因数量80,683条。
#3.2 基因聚类/去冗余cd-hit
经过cd-hit去除冗余，得到80,676条序列
#3.3 基因定量salmon 匹配回fastq中，并计算丰度
使用salmon定量基因。
#4 功能注释
#4.1 基因注释eggNOG, emmaper
#4.1.1 
#4.2 碳水化合物dbCAN2
#4.3 抗生素抗性CARD
#5 挖掘单菌基因组/分箱(Binning)
#5.1 vamb
#5.2 blastn
#5.3 diamond
经过checkv的Medium-quality确认，得到3条序列。
