#!/bin/bash

# mamba activate /home/ngs2/anaconda3/envs/snakemake_env

mkdir -p temp/prodigal
#for i in `cat bb.txt`; do sudo rm -rf denovo/${i}/prokka; done
time prodigal -i result/megahit/final-500.contigs.fa \
        -d temp/prodigal/gene.fa \
        -o temp/prodigal/gene.gff \
        -p meta -f gff > temp/prodigal/gene.log 2>&1 
    # 查看日志是否运行完成，有无错误
    tail temp/prodigal/gene.log
# Finding genes in sequence #199731 (897 bp)...done!
# Finding genes in sequence #199732 (1314 bp)...done!
# Finding genes in sequence #199733 (748 bp)...done!
# Finding genes in sequence #199734 (508 bp)...done!
# Finding genes in sequence #199735 (666 bp)...done!
# Finding genes in sequence #199736 (555 bp)...done!
# Finding genes in sequence #199737 (520 bp)...done!
# Finding genes in sequence #199738 (575 bp)...done!
# Finding genes in sequence #199739 (765 bp)...done!
# Finding genes in sequence #199740 (2742 bp)...done!

	# 统计基因数量
	seqkit stat temp/prodigal/gene.fa 
# file                   format  type  num_seqs      sum_len  min_len  avg_len  max_len
# temp/prodigal/gene.fa  FASTA   DNA    313,233  176,532,447       60    563.6   14,115

	# grep -c '>' temp/prodigal/${i}.gene.fa >> temp/prodigal/1_gene_count.txt
	# 统计完整基因数量，数据量大可只用完整基因部分
	grep -c 'partial=00' temp/prodigal/gene.fa
	# 80683条
	
	
	# 提取完整基因(完整片段获得的基因全为完整，如成环的细菌基因组)
	grep 'partial=00' temp/prodigal/gene.fa | cut -f1 -d ' '| sed 's/>//' > temp/prodigal/full_length.id
	seqkit grep -f temp/prodigal/full_length.id temp/prodigal/gene.fa > temp/prodigal/full_length.fa
	seqkit stat temp/prodigal/full_length.fa
# file                          format  type  num_seqs     sum_len  min_len  avg_len  max_len
# temp/prodigal/full_length.fa  FASTA   DNA     80,683  53,166,372       90      659    8,310

	# echo "###############################################"
	# echo "###############################################"
	# echo "###############################################"
	echo "                                             "
	echo ${i} prodigal RESULT
	echo "                                             "
	echo "###############################################"
	echo "###############################################"
	echo "###############################################"






### 3.2.2 基因聚类/去冗余cd-hit

    # 输入文件：prodigal预测的基因序列 temp/prodigal/gene.fa
    # 输出文件：去冗余后的基因和蛋白序列：result/NR/nucleotide.fa, result/NR/protein.fa
    
    mkdir -p result/NR
    # aS覆盖度，c相似度，G局部比对，g最优解，T多线程，M内存0不限制
    # 2万基因2m，2千万需要2000h，多线程可加速
    cd-hit-est -i temp/prodigal/gene.fa \
        -o result/NR/nucleotide.fa \
        -aS 0.9 -c 0.95 -G 0 -g 0 -T 0 -M 0
		
		
# 使用全长的基因
    cd-hit-est -i temp/prodigal/full_length.fa \
        -o result/NR/full_nucleotide.fa \
        -aS 0.9 -c 0.95 -G 0 -g 0 -T 0 -M 0
    # 统计非冗余基因数量，单次拼接结果数量下降不大，多批拼接冗余度高
    grep -c '>' result/NR/nucleotide.fa
	grep -c '>' result/NR/full_nucleotide.fa
	# 311889
	# 80676

    # 翻译核酸为对应蛋白序列, --trim去除结尾的*
    seqkit translate --trim result/NR/nucleotide.fa \
        > result/NR/protein.fa 
	seqkit translate --trim result/NR/full_nucleotide.fa \
        > result/NR/full_protein.fa 
    # 两批数据去冗余使用cd-hit-est-2d加速，见附录

