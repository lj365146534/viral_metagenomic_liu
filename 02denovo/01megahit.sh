mkdir -p 01megahit

#分别denovo组装
for i in `cat ../01trim/1host/all_faces_sample_nodel_zero.txt`
#for i in `cat ../01trim/1host/test_faces_sample.txt`
do
	#denovo出contigs，保留500bp以上的contigs
	megahit -r /home/ngs2/Desktop/Liujia/Poyanglake/Faces_sample/01trim/bowtie/nohost_silva_${i}.fastq.gz -o 01megahit/${i} --presets meta-large --min-contig-len 500 
	#用压缩文件megahit
	#megahit -r /home/ngs2/Desktop/Liujia/Poyanglake/Faces_sample/01trim/bowtie/nohost_silva_${i}.fastq.gz -o 01megahit/${i} --presets meta-large --min-contig-len 1000
	#qyast.py评估组装质量
	#python /home/ngs2/Desktop/Liujia/biosoft/quast-master/quast.py  01megahit/${i}/final.contigs.fa -o quest-report
done

#quast.py评估组装质量
python /home/ngs2/Desktop/Liujia/biosoft/quast-master/quast.py  01megahit/*/final.contigs.fa -o quest-report


#####
#将所有megahit看做一个文件进行denovo，min_length 1000bp
#megahit -t 20 -r `cat ../01trim/1host/all_faces_sample_nodel_zero.txt | sed 's/^/..\/01trim\/bowtie\/nohost_silva_/;s/$/\.fastq/' | tr '\n' ',' |sed 's/,$//'` -o 01megahit/test_concat_denovo --presets meta-large --min-contig-len 500
#用压缩文件megahit
#megahit -t 20 -r `cat ../01trim/1host/all_faces_sample_nodel_zero.txt | sed 's/^/..\/01trim\/bowtie\/nohost_silva_/;s/$/\.fastq\.gz/' | tr '\n' ',' |sed 's/,$//'` -o 01megahit/test_concat_denovo --presets meta-large --min-contig-len 500