#!/bin/bash


#Eggnog+碳水化合物dbCAN2+抗生素抗性CARD


mamba activate /home/ngs2/anaconda3/envs/snakemake_env

#conda activate snakemake_env
# mkdir -p temp/eggnog
emapper.py --version


# #将所有megahit看做一个文件进行denovo，min_length 1000bp
# megahit -t 20 -r `cat ../01trim/1host/all_faces_sample.txt | sed 's/^/fastq\//;s/$/\.clean\.fastq\.gz/' | tr '\n' ',' |sed 's/,$//'` -o temp/megahit --presets meta-large --min-contig-len 1000



#for i in `cat bb.txt`; do sudo rm -rf denovo/${i}/prokka; done
# for i in `cat ../01trim/1host/all_faces_sample.txt`

# do
    # # diamond比对基因至eggNOG 5.0数据库, 1~9h，默认diamond 1e-3
    # time emapper.py --no_annot --no_file_comments --override \
      # --data_dir /home/ngs2/Desktop/Liujia/db/eggnog5 \
      # --tax_scope Viruses \
      # -i result/NR/${i}.protein.fa \
      # --cpu 16 -m diamond \
      # -o temp/eggnog/${i}.protein

    # # 比对结果功能注释, 1h
    # time emapper.py \
      # --annotate_hits_table temp/eggnog/${i}.protein.emapper.seed_orthologs \
      # --data_dir /home/ngs2/Desktop/Liujia/db/eggnog5 \
      # --cpu 16 --no_file_comments --override \
      # -o temp/eggnog/output

	# # echo "###############################################"
	# # echo "###############################################"
	# # echo "###############################################"
	# echo "                                             "
	# echo ${i} SALMON RESULT
	# echo "                                             "
	# echo "###############################################"
	# echo "###############################################"
	# echo "###############################################"
# done




#单个注释
	mkdir -p temp/eggnog-230618
    time emapper.py --no_annot --no_file_comments --override \
      --data_dir /home/ngs2/Desktop/Liujia/db/eggnog5 \
      -i result/NR-230618/protein.fa \
      --cpu 40 -m diamond \
      -o temp/eggnog-230618/protein
	# Total hits processed: 259014
	# Total time: 1446 secs
	# FINISHED

	# real 24m6.333s
	# user 751m34.544s
	# sys 14m23.729s


    # 比对结果功能注释, 1h # sqlite3.OperationalError: no such table: prots是数据库不配套，重新下载即可
    time emapper.py \
      --annotate_hits_table temp/eggnog-230618/protein.emapper.seed_orthologs \
      --data_dir /home/ngs2/Desktop/Liujia/db/eggnog5 \
      --cpu 40 --no_file_comments --override \
      -o temp/eggnog-230618/output
	# Total hits processed: 259014
	# Total time: 1542 secs
	# FINISHED

	# real 25m42.388s
	# user 47m34.680s
	# sys 111m48.311s


    # 2.1较2.0结果又有新变化，添加了#号表头，减少了列
	# 把开头第一行的#替换掉
    sed '1 s/^#//' temp/eggnog-230618/output.emapper.annotations \
      > temp/eggnog-230618/output



###
# #使用full_protein做
# #单个注释
	# mkdir -p temp/eggnog
    # time emapper.py --no_annot --no_file_comments --override \
      # --data_dir /home/ngs2/Desktop/Liujia/db/eggnog5 \
      # -i result/NR/full_protein.fa \
      # --cpu 40 -m diamond \
      # -o temp/eggnog/full_protein
	  
    # # 比对结果功能注释, 1h # sqlite3.OperationalError: no such table: prots是数据库不配套，重新下载即可
    # time emapper.py \
      # --annotate_hits_table temp/eggnog/full_protein.emapper.seed_orthologs \
      # --data_dir /home/ngs2/Desktop/Liujia/db/eggnog5 \
      # --cpu 40 --no_file_comments --override \
      # -o temp/eggnog/full_output


# sed '1 s/^#//' temp/eggnog/full_output.emapper.annotations \
      # > temp/eggnog/full_output









csvtk -t headers -v temp/eggnog-230618/output
# # temp/eggnog-230618/output
# 1       query
# 2       seed_ortholog
# 3       evalue
# 4       score
# 5       eggNOG_OGs
# 6       max_annot_lvl
# 7       COG_category
# 8       Description
# 9       Preferred_name
# 10      GOs
# 11      EC
# 12      KEGG_ko
# 13      KEGG_Pathway
# 14      KEGG_Module
# 15      KEGG_Reaction
# 16      KEGG_rclass
# 17      BRITE
# 18      KEGG_TC
# 19      CAZy
# 20      BiGG_Reaction
# 21      PFAMs

	#计算多少个注释的基因
	# 汇总，7列COG_category按字母分隔，12列KEGG_ko和19列CAZy按逗号分隔，原始值累加
	# COG_category
	# = 259014-1-13961 = 245052
cat temp/eggnog-230618/output.emapper.annotations | awk -F "\t" '{print $7}' | wc -l
# 259014
cat temp/eggnog-230618/output.emapper.annotations | awk -F "\t" '{print $7}' | grep -c '-'
# 13861
cat temp/eggnog-230618/output.emapper.annotations | awk -F "\t" '{print $12}' | grep -c '-'
# 91596
cat temp/eggnog-230618/output.emapper.annotations | awk -F "\t" '{print $19}' | grep -c '-'
# 254969
	# 12列KEGG_ko = x-1-y = 167417
	# 19列CAZy = x-1-y = 4044
	
mkdir -p result/eggnog-230618
cat temp/eggnog-230618/output.emapper.annotations | awk -F "\t" '{print $1"\t"$6}' > result/eggnog-230618/max_lelv.txt 





# #使用full_protein做

	# #计算多少个注释的基因
	# # 汇总，7列COG_category按字母分隔，12列KEGG_ko和19列CAZy按逗号分隔，原始值累加
	# # COG_category
	# # = 67573-1-6189 = 61383
# cat temp/eggnog/full_output.emapper.annotations | awk -F "\t" '{print $7}' | wc -l
# # 67573
# cat temp/eggnog/full_output.emapper.annotations | awk -F "\t" '{print $7}' | grep -c '-'
# # 6189
	# # 12列KEGG_ko = 67573-1-27140 = 40432
	# # 19列CAZy = 67573 -1 -66974 = 598
# mkdir -p result/eggnog
# cat temp/eggnog/full_output.emapper.annotations | awk -F "\t" '{print $1"\t"$6}' > result/eggnog/full_max_lelv.txt 




    python summarizeAbundance.py -h
    # 汇总，7列COG_category按字母分隔，12列KEGG_ko和19列CAZy按逗号分隔，原始值累加
    # 指定humann3中的Python 3.7.6运行正常，qiime2中的Python 3.6.13报错
    python summarizeAbundance.py \
      -i result/salmon-230618/gene.TPM \
      -m temp/eggnog-230618/output \
      -c '7,12,19' -s '*+,+,' -n raw \
      -o result/eggnog-230618/eggnog
# 生成eggnog.CAZy.raw.txt  eggnog.COG_category.raw.txt  eggnog.KEGG_ko.raw.txt
    sed -i 's/^ko://' result/eggnog-230618/eggnog.KEGG_ko.raw.txt
    sed -i '/^-/d' result/eggnog-230618/eggnog*


    # 添加注释生成STAMP的spf格式，结合metadata.txt进行差异比较
    awk 'BEGIN{FS=OFS="\t"} NR==FNR{a[$1]=$2} NR>FNR{print a[$1],$0}' \
      /home/ngs2/Desktop/Liujia/db/eggnog5/KO_description.txt \
      result/eggnog-230618/eggnog.KEGG_ko.raw.txt | \
      sed 's/^\tKEGG_ko/Description\tKO/' \
      > result/eggnog-230618/eggnog.KEGG_ko.TPM.spf




	# KO to level 1/2/3
    python summarizeAbundance.py \
      -i result/eggnog-230618/eggnog.KEGG_ko.raw.txt \
      -m /home/ngs2/Desktop/Liujia/db/eggnog5/EasyMicrobiome/kegg/KO1-4.txt \
      -c 2,3,4 -s ',+,+,' -n raw \
      -o result/eggnog-230618/KEGG
    # ko_pathway
	awk 'BEGIN{FS=OFS="\t"} NR==FNR{a[$1]=$2} NR>FNR{print a[$1],$0}' \
      /home/ngs2/Desktop/Liujia/db/eggnog5/KO_path.list \
      result/eggnog-230618/eggnog.KEGG_ko.raw.txt | \
      sed 's/^\tKEGG_ko/Description\tKO/' \
      > result/eggnog-230618/eggnog.ko.pathway.TPM.spf
	
	
    # CAZy
    awk 'BEGIN{FS=OFS="\t"} NR==FNR{a[$1]=$2} NR>FNR{print a[$1],$0}' \
       /home/ngs2/Desktop/Liujia/db/dbCAN2/CAZy_description.txt result/eggnog-230618/eggnog.CAZy.raw.txt | \
      sed 's/^\t/Unannotated\t/' \
	  > result/eggnog-230618/eggnog.CAZy.TPM.spf


    # COG
    awk 'BEGIN{FS=OFS="\t"} NR==FNR{a[$1]=$2"\t"$3} NR>FNR{print a[$1],$0}' \
      /home/ngs2/Desktop/Liujia/db/eggnog5/COG.anno result/eggnog-230618/eggnog.COG_category.raw.txt > \
      result/eggnog-230618/eggnog.COG_category.TPM.spf



### 3.3.2 (可选)碳水化合物dbCAN2

    # 比对CAZy数据库, 用时2~18m
    mkdir -p temp/dbcan2-230618
	#在dbcan2官网下载CAZyDB.08062022.fa,并且做成dmnd库
    # --sensitive慢10倍，dbCAN2推荐e值为1e-102，此处结果3条太少，以1e-3为例演示
    diamond blastp \
      --db /home/ngs2/Desktop/Liujia/db/dbCAN2/CAZyDB.08062022.dmnd \
      --query result/NR-230618/protein.fa \
      --threads 9 -e 1e-3 --outfmt 6 --max-target-seqs 1 --quiet \
      --out temp/dbcan2-230618/gene_diamond.f6
	
	wc -l temp/dbcan2-230618/gene_diamond.f6
	# 44005 temp/dbcan2/gene_diamond.f6
	# wc -l temp/dbcan2-230618/gene_diamond.f6
	# 10422 temp/dbcan2/full_gene_diamond.f6
	
	# 整理比对数据为表格 
    mkdir -p result/dbcan2-230618
	
	cp /home/ngs2/Desktop/Liujia/db/eggnog5/EasyMicrobiome/script/format_dbcan2list.pl ./
	# 提取基因与dbcan分类对应表
    perl format_dbcan2list.pl \
      -i temp/dbcan2-230618/gene_diamond.f6 \
      -o temp/dbcan2-230618/gene.list 
    # 按对应表累计丰度，依赖
    python summarizeAbundance.py \
      -i result/salmon-230618/gene.TPM \
      -m temp/dbcan2-230618/gene.list \
      -c 2 -s ',' -n raw \
      -o result/dbcan2-230618/TPM
	# 添加注释生成STAMP的spf格式，结合metadata.txt进行差异比较
    awk 'BEGIN{FS=OFS="\t"} NR==FNR{a[$1]=$2} NR>FNR{print a[$1],$0}' \
       /home/ngs2/Desktop/Liujia/db/eggnog5/EasyMicrobiome/dbcan2/CAZy_description.txt result/dbcan2-230618/TPM.CAZy.raw.txt | \
      sed 's/^\t/Unannotated\t/' > result/dbcan2-230618/TPM.CAZy.raw.spf
    # 检查未注释数量，有则需要检查原因
    # grep 'Unannotated' result/dbcan2/TPM.CAZy.raw.spf|wc -l


### 3.3.3 抗生素抗性CARD

# 数据库：https://card.mcmaster.ca/ ，有在线分析平台，本地代码供参考
# 网上数据库分析平台的上传限制为20M，基本做不到什么事情
    # 用的docker安装
    # 参考文献：http://doi.org/10.1093/nar/gkz935
    # 软件使用Github: https://github.com/arpcard/rgi
    
	# docker pull finlaymaguire/rgi:latest

    docker run -v $PWD:/data finlaymaguire/rgi rgi -h # 6.0.1
    # 蛋白注释
	# 文件夹一定要提前创建，不然rgi会报错
	# 这个可以使用它自带的热图功能，不过建议单个样本的contigs生成一个json文件，然后做
    mkdir -p result/card-230618
    cut -f 1 -d ' ' result/NR-230618/protein.fa > temp/protein-230618.fa
	
     docker run -v $PWD:/data finlaymaguire/rgi rgi main -i /data/temp/protein-230618.fa -t protein \
      -n 40 -a DIAMOND --clean --low_quality --include_nudge \
      -o /data/result/card-230618/protein-2
      
     # docker run -v $PWD:/data finlaymaguire/rgi rgi main -i temp/full_protein.fa -t protein \
      # -n 9 -a DIAMOND --include_loose --clean \
      # -o result/card/full_protein

结果说明：
- protein.json，在线可视化
- protein.txt，注释基因列表

cat result/card-230618/protein.txt  | wc -l
# 16623

## 3.4 基因物种注释

    # Generate report in default taxid output
    # conda activate meta
    # memusg -t kraken2 --db /db/kraken2/mini \
      # result/NR/nucleotide.fa \
      # --threads 3 \
      # --report temp/NRgene.report \
      # --output temp/NRgene.output
    kraken2 --db /home/ngs2/Desktop/Liujia/db/kraken2/k2_pluspf_20210517 \
      result/NR/nucleotide.fa \
      --threads 30 \
      --report temp/NRgene.report \
      --output temp/NRgene.output
    # Genes & taxid list
    grep '^C' temp/NRgene.output|cut -f 2,3|sed '1 i Name\ttaxid' \
      > temp/NRgene.taxid
	
	
	
	# 此处可以使用taxonkit来读取taxid来得到其taxonomy数据。
	# 比如
	# cat virus.blast.out | awk -F "\t" '{print $3}' | cut -d ";" -f2 --complement | taxonkit lineage | taxonkit reformat -f "{k}\t{K}\t{p}\t{c}\t{o}\t{f}\t{g}\t{s}" -F -P | cut -f2 --complement | csvtk add-header -t -n taxid,superkindom,kindom,phylum,class,order,family,genus,species > tax_virus.tsv
	# 然后和原数据paste在一起
	
    # Add taxonomy
    awk 'BEGIN{FS=OFS="\t"} NR==FNR{a[$1]=$0} NR>FNR{print $1,a[$2]}' \
      /home/ngs2/Desktop/Liujia/db/eggnog5/EasyMicrobiome/kraken2/taxonomy.txt \
      temp/NRgene.taxid \
      > result/NR/nucleotide.tax
    python /home/ngs2/Desktop/Liujia/db/eggnog5/EasyMicrobiome/script/summarizeAbundance.py \
      -i result/salmon/gene.TPM \
      -m result/NR/nucleotide.tax \
      -c '2,3,4,5,6,7,8,9' -s ',+,+,+,+,+,+,+,' -n raw \
      -o result/NR/tax
    wc -l result/NR/tax*|sort -n
       # 6 result/NR/tax.Kingdom.raw.txt
      # 60 result/NR/tax.Phylum.raw.txt
     # 101 result/NR/tax.Class.raw.txt
     # 204 result/NR/tax.Order.raw.txt
     # 427 result/NR/tax.Family.raw.txt
    # 1417 result/NR/tax.Genus.raw.txt
    # 4421 result/NR/tax.Species.raw.txt
    # 5625 result/NR/tax.taxid.raw.txt
   # 12261 total

	
	
	#######
	kraken2 --db /home/ngs2/Desktop/Liujia/db/kraken2/k2_pluspf_20210517 \
      result/NR/full_nucleotide.fa \
      --threads 30 \
      --report temp/full_NRgene.report \
      --output temp/full_NRgene.output
    # Genes & taxid list
    grep '^C' temp/full_NRgene.output|cut -f 2,3|sed '1 i Name\ttaxid' \
      > temp/full_NRgene.taxid
    # Add taxonomy
    awk 'BEGIN{FS=OFS="\t"} NR==FNR{a[$1]=$0} NR>FNR{print $1,a[$2]}' \
      /home/ngs2/Desktop/Liujia/db/eggnog5/EasyMicrobiome/kraken2/taxonomy.txt \
      temp/full_NRgene.taxid \
      > result/NR/full_nucleotide.tax
    memusg -t /conda2/envs/humann3/bin/python3 /home/ngs2/Desktop/Liujia/db/eggnog5/EasyMicrobiome/script/summarizeAbundance.py \
      -i result/salmon/full_gene.TPM \
      -m result/NR/full_nucleotide.tax \
      -c '2,3,4,5,6,7,8,9' -s ',+,+,+,+,+,+,+,' -n raw \
      -o result/NR/full_tax
    wc -l result/NR/full_tax*|sort -n
 

