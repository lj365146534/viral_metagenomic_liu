

#16服务器有nt数据库
#blastn -query viruses.fna -db /home/ngs/Desktop/Liujia/db/nt_20210810/nt -out virus.blast.out -outfmt "6 qseqid stitle staxids pident length mismatch gapopen qstart qend sstart send evalue bitscore " -max_target_seqs 1 -num_threads 16 -e 1e-06
#18服务器有nr_Virus.dmnd库
diamond blastx -b12 -c1 --outfmt 6 qseqid stitle staxids pident length mismatch gapopen qstart qend sstart send evalue bitscore --db /home/ngs2/Desktop/Liujia/db/dmnd/nr_Virus.dmnd -q /home/ngs2/Desktop/Liujia/Poyanglake/Faces_sample/06eggnog_mapper/result/NR-230618/nucleotide.fa --out virus.blast.out -k 1

#18服务器有taxonkit
cat virus.blast.out | awk -F "\t" '{print $3}' | cut -d ";" -f2 --complement | taxonkit lineage | taxonkit reformat -f "{k}\t{p}\t{c}\t{o}\t{f}\t{g}\t{s}" -F -P | cut -f2 --complement | csvtk add-header -t -n taxid,kindom,phylum,class,order,family,genus,species > tax_virus.tsv
#给blast结果也加一个头
cat virus.blast.out | csvtk add-header -t -n qseqid,stitle,staxids,pident,length,mismatch,gapopen,qstart,qend,sstart,send,evalue,bitscore  > virus.blast.2.out 
#横向合并
paste virus.blast.2.out tax_virus.tsv > virus.blast.tax.tsv
#将注释的tax信息提取
cat virus.blast.tax.tsv | grep k__Viruses | csvtk add-header -t -n qseqid,stitle,staxids,pident,length,mismatch,gapopen,qstart,qend,sstart,send,evalue,bitscore,taxid,kindom,phylum,class,order,family,genus,species > grep_viruses.tsv

#获得病毒序列的名字（部分名字）
cat grep_viruses.tsv | awk -F "\t" '{print $1}' > virus.name.txt
#获得病毒序列
seqkit grep -f virus.name.txt /home/ngs2/Desktop/Liujia/Poyanglake/Faces_sample/06eggnog_mapper/result/NR-230618/nucleotide.fa > grep.virus.fa
#运行checkv
#如果出现ref database报错，请将checkv的库放入运行环境
#export CHECKVDB=/home/ngs2/Desktop/Liujia/db/checkv_db/checkv-db-v1.4
checkv end_to_end grep.virus.fa checkv_virus


#筛选checkv的结果
	# 删选条件如下
	# 1. checkV_quality 要在Low-quality以上，即Low-quality, Medium-quality, High-quality
	# 2. 不要在warning 中出现 "no viral genes detected"

#将得到的序列取出
#取出序列号
cat checkv_virus/quality_summary.tsv | grep "\-quality"| grep -v "no viral"|  awk -F "\t" '{print $1}' > checkv_virus/virus.name.txt
#获取序列
seqkit grep -f checkv_virus/virus.name.txt checkv_virus/viruses.fna > quality.virus.fa

#获取所有low_quality以上的序列summary
cat checkv_virus/quality_summary.tsv | grep "\-quality"| grep -v "no viral" > checkv_virus/viral_quality_summary.tsv
#从上述文件取出High-quality和Medium-quality的序列id
cat checkv_virus/viral_quality_summary.tsv | grep -v "Low-quality"|  awk -F "\t" '{print $1}' > checkv_virus/high-medium-virus.name.txt
#获取High-quality和Medium-quality序列
seqkit grep -f checkv_virus/high-medium-virus.name.txt checkv_virus/viruses.fna > high-medium-quality.virus.fa
