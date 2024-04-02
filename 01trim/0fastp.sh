mkdir fq


for i in `cat 1host/all_faces_sample.txt`
	do
	fastp  --thread 16 -i /home/ngs2/Desktop/Liujia/Lixiyan/metagenomic/fastq/${i}.clean.fastq.gz -o fq/${i}.fastq.gz -j fq/${i}.json |& tee fq/${i}.log.txt 2>&1
	#rm fq/${i}.fastq
	
done

for i in `cat 1host/all_faces_sample_other6.txt`
	do
	fastp  --thread 16 -i /home/ngs2/Desktop/Liujia/Lixiyan/metagenomic/fastq/${i}.clean.fastq.gz -o fq/${i}.fastq.gz -j fq/${i}.json |& tee fq/${i}.log.txt 2>&1
	#rm fq/${i}.fastq
	
done



# #调取Q30的值
# #cat fq/*.log.txt fq/concat.log.txt
# cat fq/*.log.txt | grep Q30 > fq/Q30.txt
# tail -n 2  fq/*.log.txt | grep "fastp" > fq/fastp.txt
# paste fq/fastp.txt fq/Q30.txt | grep clean.fastq.gz > Q30.clean.fastq.txt

#调取Q30的值
#cat fq/*.log.txt fq/concat.log.txt
cat fq/*.json | grep q30_rate > fq/q30_rate.txt
cat fq/*.json | grep "fastp" > fq/fastp.txt
cat fq/*.json | grep gc_content > fq/gc_content.txt
paste fq/fastp.txt fq/q30_rate.txt fq/gc_content.txt | grep clean.fastq.gz > q30_gc.clean.fastq.txt
paste fq/fastp.txt fq/q30_rate.txt fq/gc_content.txt | grep version > before.q30_gc.clean.fastq.txt




