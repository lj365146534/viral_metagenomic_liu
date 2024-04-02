#!/bin/bash

# mamba activate /home/ngs2/anaconda3/envs/snakemake_env

mkdir -p temp/prodigal-230618
#for i in `cat bb.txt`; do sudo rm -rf denovo/${i}/prokka; done
time prodigal -i result/megahit-230618/final.contigs.fa \
        -d temp/prodigal-230618/gene.fa \
        -o temp/prodigal-230618/gene.gff \
        -p meta -f gff > temp/prodigal-230618/gene.log 2>&1 
    # 查看日志最后10行，看是否运行完成，有无错误
    tail temp/prodigal-230618/gene.log
# Finding genes in sequence #200810 (1718 bp)...done!
# Finding genes in sequence #200811 (600 bp)...done!
# Finding genes in sequence #200812 (506 bp)...done!
# Finding genes in sequence #200813 (673 bp)...done!
# Finding genes in sequence #200814 (2001 bp)...done!
# Finding genes in sequence #200815 (1481 bp)...done!
# Finding genes in sequence #200816 (511 bp)...done!
# Finding genes in sequence #200817 (642 bp)...done!
# Finding genes in sequence #200818 (562 bp)...done!
# Finding genes in sequence #200819 (860 bp)...done!


	# 统计基因数量
	seqkit stat temp/prodigal-230618/gene.fa 
# file                          format  type  num_seqs      sum_len  min_len  avg_len  max_len
# temp/prodigal-230618/gene.fa  FASTA   DNA    314,892  177,516,333       60    563.7   14,115


	# grep -c '>' temp/prodigal/${i}.gene.fa >> temp/prodigal/1_gene_count.txt
	# 统计完整基因数量，数据量大可只用完整基因部分
	grep -c 'partial=00' temp/prodigal-230618/gene.fa
	# 81028条
	
	
	# 提取完整基因(完整片段获得的基因全为完整，如成环的细菌基因组)
	grep 'partial=00' temp/prodigal-230618/gene.fa | cut -f1 -d ' '| sed 's/>//' > temp/prodigal-230618/full_length.id
	seqkit grep -f temp/prodigal-230618/full_length.id temp/prodigal-230618/gene.fa > temp/prodigal-230618/full_length.fa
	seqkit stat temp/prodigal-230618/full_length.fa
# file                          format  type  num_seqs     sum_len  min_len  avg_len  max_len
# temp/prodigal/full_length.fa  FASTA   DNA     81,028  53,436,390       90      659.5    8,310

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
    
    mkdir -p result/NR-230618
    # aS覆盖度，c相似度，G局部比对，g最优解，T多线程，M内存0不限制
    # 2万基因2m，2千万需要2000h，多线程可加速
    cd-hit-est -i temp/prodigal-230618/gene.fa \
        -o result/NR-230618/nucleotide.fa \
        -aS 0.9 -c 0.95 -G 0 -g 0 -T 0 -M 0
	# Approximated maximum memory consumption: 1813M
	# writing new database
	# writing clustering information
	# program completed !

	# Total CPU time 11915.44





# 使用全长的基因
    # cd-hit-est -i temp/prodigal/full_length.fa \
        # -o result/NR/full_nucleotide.fa \
        # -aS 0.9 -c 0.95 -G 0 -g 0 -T 0 -M 0
    # 统计非冗余基因数量，单次拼接结果数量下降不大，多批拼接冗余度高
    grep -c '>' result/NR-230618/nucleotide.fa

	# 313,535


    # 翻译核酸为对应蛋白序列, --trim去除结尾的*
    seqkit translate --trim result/NR-230618/nucleotide.fa \
        > result/NR-230618/protein.fa 
# file                         format  type     num_seqs     sum_len  min_len  avg_len  max_len
# result/NR-230618/protein.fa  FASTA   Protein   313,535  58,550,012        0    186.7    4,704



#	seqkit translate --trim result/NR-230618/full_nucleotide.fa \
#        > result/NR-230618/full_protein.fa 
    # 两批数据去冗余使用cd-hit-est-2d加速，见附录

