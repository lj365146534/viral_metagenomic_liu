#!/bin/bash

#p跑了25小时
#将所有megahit看做一个文件进行denovo
#min_length 500bp
#megahit -t 40 -r `cat ../01trim/1host/all_faces_sample_nodel_zero.txt | sed 's/^/\.\.\/01trim\/bowtie\/nohost_silva_/;s/$/\.fastq\.gz/' | tr '\n' ',' |sed 's/,$//'` -o temp/megahit --presets meta-large --min-contig-len 500

megahit -t 40 -r `cat ../01trim/1host/all_faces_sample_nodel_zero.txt | sed 's/^/\.\.\/01t
rim\/bowtie\/nohost_silva_/;s/$/\.fastq\.gz/' | tr '\n' ',' |sed 's/,$//'` -o temp/megahit-230618/ --presets meta-large --min-conti
g-len 500
#200819 contigs, total 205939697 bp, min 500 bp, max 38844 bp, avg 1025 bp, N50 1073 bp


#保存结果
#cp temp/megahit/final.contigs.fa result/megahit/
mkdir result/megahit-230618/
cp temp/megahit-230618/final.contigs.fa result/megahit-230618/

#rm -rf temp/megahit/intermediate_contigs/
rm -rf temp/megahit-230618/intermediate_contigs/

#直接过滤短序列
#megahit也可以选择输出长度（默认200bp）
#但是megahit重跑一次很久
#seqkit seq -m 也可以实现这个功能
seqkit seq -m 1000 result/megahit/final.contigs.fa > result/megahit/final-1000.contigs.fa
seqkit seq -m 500 result/megahit/final.contigs.fa > result/megahit/final-500.contigs.fa

#显示拼接序列结果
seqkit stat result/megahit/final.contigs.fa result/megahit/final-500.contigs.fa result/megahit/final-1000.contigs.fa

# file                                  format  type  num_seqs      sum_len  min_len  avg_len  max_len
# result/megahit/final.contigs.fa       FASTA   DNA    851,235  409,578,363      203    481.2   38,844
# result/megahit/final-500.contigs.fa   FASTA   DNA    199,740  204,833,137      500  1,025.5   38,844
# result/megahit/final-1000.contigs.fa  FASTA   DNA     58,180  109,618,416    1,000  1,884.1   38,844





#查看生成contigs的质量
#python /home/ngs2/Desktop/Liujia/biosoft/quast-master/quast.py  result/megahit/final.contigs.fa result/megahit/final-500.contigs.fa result/megahit/final-1000.contigs.fa -o result/megahit/quest-report
python /home/ngs2/Desktop/Liujia/biosoft/quast-master/quast.py  result/megahit-230618/final.contigs.fa -o result/megahit-230618/quest-report

