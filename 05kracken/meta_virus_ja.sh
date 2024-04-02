#!/bin/bash


mkdir denovo kraken_result_ja
mkdir -p temp/bowtie2_filter_rRNA
mkdir result
mkdir result/mpa_file/



#get_fastq_summary
#seqkit stats *.clean.fastq.gz -T -j 40 > seq_stats.tsv 

#给rRNA建库-已完成
#bowtie2-build -i /home/ngs2/Desktop/Liujia/db/bowtie2/rRNA_LSUep_SSUe/rRNA_LSUep_SSUe.fa /home/ngs2/Desktop/Liujia/db/bowtie2/rRNA_LSUep_SSUe/rRNA_LSUep_SSUe

for i in `cat /home/ngs2/Desktop/Liujia/Poyanglake/Faces_sample/01trim/1host/all_faces_sample_nodel_zero.txt`
do

	mkdir -p kraken_result_ja/${i}
	#k2_Standard plus protozoa & fungi
	kraken2 --db /home/ngs2/Desktop/Liujia/db/kraken2/k2_pluspf_20210517  --threads 24  --report kraken_result_ja/${i}/${i}.pluspf.report --output kraken_result_ja/${i}/${i}.pluspf.output ../01trim/bowtie/nohost_silva_${i}.fastq.gz 
	#把过大output的删除掉
	rm kraken_result_ja/${i}/${i}.pluspf.output
	#Bracken估计丰度
	for j in S G F O
	do
		/home/ngs2/Desktop/Liujia/biosoft/Bracken/Bracken/bracken -d /home/ngs2/Desktop/Liujia/db/kraken2/k2_pluspf_20210517 -i kraken_result_ja/${i}/${i}.pluspf.report -o kraken_result_ja/${i}/${i}.${j}.pluspf.bracken.report -r 75 -l ${j}
	done
	#转化bracken_report为mpa文件
	python 2.4kreport2mpa.py -r kraken_result_ja/${i}/${i}.pluspf_bracken_species.report -o result/mpa_file/${i}.mpa.report
	
	#mkdir -p temp/megahit/${i}/
	#denovo出contigs，保留1000bp以上的contigs
	# megahit -t 20 -r temp/bowtie2_filter_rRNA/${i}_unmap.fq \
	# -o temp/megahit/${i}/ \
	# --presets meta-large \
	# --min-contig-len 1000
	
	#qyast.py评估组装质量
	#python /home/ngs2/Desktop/Liujia/biosoft/quast-master/quast.py  ../02denovo/contigs/${i}/final.contigs.fa -o result/quest-report/${i}
	
done
#将MPA文件合并
# cp aa.txt result/
# python 2.5combine_textname_mpa.py -i aa.txt -o result/mpa_file/combined.mpa.report



#将bracken的output文件合并,挨个把O,F,G,S等级别的合并了
#合并了之后的文件，里面一个样本有num和frac两列，手动excel筛选num列数据
#python combine_textname_bracken_outputs_JA.py --files aa.txt -o combine_S_bracken_out.tsv


#18服务器有taxonkit,去掉第一行
for i in S G F O
do
	cat bracken_report/combine_${i}_bracken_out.tsv| sed -n '1!p' | awk -F "\t" '{print $2}' | cut -d ";" -f2 --complement | taxonkit lineage | taxonkit reformat -f "{k}" -F -P | cut -f2 --complement | csvtk add-header -t -n taxid,kindom > bracken_report/combine_${i}_bracken_out_taxon.tsv
	paste bracken_report/combine_${i}_bracken_out_taxon.tsv bracken_report/combine_${i}_bracken_out.tsv > bracken_report/combine_${i}_bracken_out_taxon2.tsv

	cat bracken_report/combine_${i}_bracken_out_taxon2.tsv | awk '$2 ~ /kindom|k__Bacteria/{print $0}' | cut -f3,6- >  bracken_report/combine_${i}_Bac.tsv
	cat bracken_report/combine_${i}_bracken_out_taxon2.tsv | awk '$2 ~ /kindom|k__Viruses/ {print $0}' | cut -f3,6- >  bracken_report/combine_${i}_Vir.tsv
	rm -rf bracken_report/combine_${i}_bracken_out_taxon2.tsv bracken_report/combine_${i}_bracken_out_taxon2.tsv
done