#!/bin/bash

#使用py3环境（已安装vamb）
# conda activate py3
# conda deactivate

mkdir -p vamb_result mapping
##必须先把contigs为0的序列和denovo结果删除掉
python concatenate_ja.py concatenate.m1000.fna.gz ../01trim/1host/all_faces_sample.txt -m 1000 --keepname
gunzip concatenate.m1000.fna
bwa index concatenate.m1000.fna
samtools faidx concatenate.m1000.fna



#分别denovo组装
for i in `cat ../01trim/1host/all_faces_sample.txt`
do
#	bwa mem concatenate.m1000.fna ../01trim/bowtie/nohost_silva_${i}.fastq.gz -t 24 | samtools view -F 3584 -b --threads 24 > mapping/nohost_silva_${i}.bam
#由于经常报错说没有index，虽然不影响，但是不方便，所以先sort再index
#不能用sort的bam文件，或者只能使用must be unsorted or sorted by readname.
#索性就不sort，忽略报错
	bwa mem concatenate.m1000.fna ../01trim/bowtie/nohost_silva_${i}.fastq.gz -t 24 |samtools view -F 3584 -b --threads 24 > mapping/nohost_silva_${i}.bam
	#samtools index mapping/nohost_silva_${i}.bam
	
	echo "###############################################"
	echo "###############################################"
	echo "###############################################"
	echo "                                             "
	echo ${i}" SAM & VAMB RESULT"
	echo "                                             "
	echo "###############################################"
	echo "###############################################"
	echo "###############################################"
done


#由于“Last batch size exceeds dataset length”错误，所以使用-t 64参数（默认值256）
#原因是有些contigs太少
vamb -z 0.95 -s 30 --outdir vamb_results --fasta concatenate.m1000.fna --bamfiles mapping/*.bam -o C --minfasta 200000 -t 64


#可以根据vamb的结果来调整参数
#默认参数 (default for multiple samples is -l 32 -n 512 512)
#调整参数，然后根据CheckV或者CheckM的结果选取合适结果
#vamb -l 24 -n 384 384 -z 0.95 -s 30 --outdir vamb_results_l24_n384 --fasta concatenate.m1000.fna --bamfiles mapping/*.bam -o C --minfasta 200000 -t 64
#vamb -l 40 -n 768 768 -z 0.95 -s 30 --outdir vamb_results_l40_n768 --fasta concatenate.m1000.fna --bamfiles mapping/*.bam -o C --minfasta 200000 -t 64



#合并bin的fna,CheckV查看相应的质量
cat vamb_results_l24_n384/bins/*.fna > vamb_results_l24_n384/concat_bin_l24_n384.fna
cat vamb_results/bins/*.fna > vamb_results/concat_bin.fna
cat vamb_results_l40_n768/bins/*.fna > vamb_results_l40_n768/concat_bin_l40_n768.fna

#下载数据库
# https://portal.nersc.gov/CheckV/

#进入phamb环境
#mamba activate phamb
#匹配数据库
#export CHECKVDB=/home/ngs2/Desktop/Liujia/db/checkv_db/checkv-db-v1.4



#运行CheckV
#查看quality_summary.tsv的结果

checkv end_to_end vamb_results/concat_bin.fna vamb_results/checkv_vamb_bins
checkv end_to_end vamb_results_l24_n384/concat_bin_l24_n384.fna vamb_results_l24_n384/checkv_vamb_bins_l24
checkv end_to_end vamb_results_l40_n768/concat_bin_l40_n768.fna vamb_results_l40_n768/checkv_vamb_bins_l40