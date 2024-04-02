#!/bin/bash
mkdir -p temp/prodigal
#for i in `cat bb.txt`; do sudo rm -rf denovo/${i}/prokka; done
for i in `cat ../01trim/1host/all_faces_sample.txt`
do
# prodigal的meta模式预测基因，35s，>和2>&1记录分析过程至gene.log
	time prodigal -i ../02denovo/01megahit/${i}/final.contigs.fa \
		-d temp/prodigal/${i}.gene.fa \
		-o temp/prodigal/${i}.gene.gff \
		-p meta -f gff > temp/prodigal/${i}.gene.log 2>&1 
	# 统计基因数量
	grep -c '>' temp/prodigal/${i}.gene.fa >> temp/prodigal/1_gene_count.txt
	# 统计完整基因数量，数据量大可只用完整基因部分
	grep -c 'partial=00' temp/prodigal/${i}.gene.fa >> temp/prodigal/2_complete_gene_count.txt
	# 提取完整基因(完整片段获得的基因全为完整，如成环的细菌基因组)
	grep 'partial=00' temp/prodigal/${i}.gene.fa | cut -f1 -d ' '| sed 's/>//' > temp/prodigal/${i}.full_length.id
	seqkit grep -f temp/prodigal/${i}.full_length.id temp/prodigal/${i}.gene.fa > temp/prodigal/${i}.full_length.fa
	

	# echo "###############################################"
	# echo "###############################################"
	# echo "###############################################"
	echo "                                             "
	echo ${i} prodigal RESULT
	echo "                                             "
	echo "###############################################"
	echo "###############################################"
	echo "###############################################"
done

seqkit stat temp/prodigal/*.full_length.fa > result/full_length_stat.tsv

#合并所有结果
#移动到temp/prodigal/文件夹
cat temp/prodigal/*gene.fa > temp/gene.fa
cat temp/prodigal/*gene.gff > temp/gene.gff
mv temp/gene.fa temp/gene.gff temp/prodigal/






    # prodigal的meta模式预测基因，35s，>和2>&1记录分析过程至gene.log
    prodigal -i result/megahit/all_final.contigs.fa \
        -d temp/prodigal/gene.fa \
        -o temp/prodigal/gene.gff \
        -p meta -f gff > temp/prodigal/gene.log 2>&1 
    # 查看日志是否运行完成，有无错误
    tail temp/prodigal/gene.log
    # 统计基因数量
    seqkit stat temp/prodigal/gene.fa 
    # 统计完整基因数量，数据量大可只用完整基因部分
    grep -c 'partial=00' temp/prodigal/gene.fa 
    # 提取完整基因(完整片段获得的基因全为完整，如成环的细菌基因组)
    grep 'partial=00' temp/prodigal/gene.fa | cut -f1 -d ' '| sed 's/>//' > temp/prodigal/full_length.id
    seqkit grep -f temp/prodigal/full_length.id temp/prodigal/gene.fa > temp/prodigal/full_length.fa
    seqkit stat temp/prodigal/full_length.fa
### 3.2.2 基因聚类/去冗余cd-hit

    # 输入文件：prodigal预测的基因序列 temp/prodigal/gene.fa
    # 输出文件：去冗余后的基因和蛋白序列：result/NR/nucleotide.fa, result/NR/protein.fa
    
    mkdir -p result/NR
    # aS覆盖度，c相似度，G局部比对，g最优解，T多线程，M内存0不限制
    # 2万基因2m，2千万需要2000h，多线程可加速
    cd-hit-est -i temp/prodigal/gene.fa \
        -o result/NR/nucleotide.fa \
        -aS 0.9 -c 0.95 -G 0 -g 0 -T 0 -M 0
    # 统计非冗余基因数量，单次拼接结果数量下降不大，多批拼接冗余度高
    grep -c '>' result/NR/nucleotide.fa
    # 翻译核酸为对应蛋白序列, --trim去除结尾的*
    seqkit translate --trim result/NR/nucleotide.fa \
        > result/NR/protein.fa 
    # 两批数据去冗余使用cd-hit-est-2d加速，见附录
### 3.2.3 基因定量salmon

    # 输入文件：去冗余后的基因和蛋白序列：result/NR/nucleotide.fa
    # 输出文件：Salmon定量后的结果：result/salmon/gene.count, gene.TPM
    
    mkdir -p temp/salmon
    salmon -v # 1.4.0
    
    # 建索引, -t序列, -i 索引，10s
    salmon index \
      -t result/NR/nucleotide.fa \
      -p 9 \
      -i temp/salmon/index 
    
    # 定量，l文库类型自动选择，p线程，--meta宏基因组模式, 2个任务并行2个样
    # 注意parallel中待并行的命令必须是双引号，内部变量需要使用原始绝对路径 
    tail -n+2 result/metadata.txt|cut -f1|rush -j 2 \
      "salmon quant \
        -i temp/salmon/index -l A -p 3 --meta \
        -1 temp/qc/{1}_1.fastq \
        -2 temp/qc/{1}_2.fastq \
        -o temp/salmon/{1}.quant"
    
    # 合并
    mkdir -p result/salmon
    salmon quantmerge --quants temp/salmon/*.quant \
        -o result/salmon/gene.TPM
    salmon quantmerge --quants temp/salmon/*.quant \
        --column NumReads -o result/salmon/gene.count
    sed -i '1 s/.quant//g' result/salmon/gene.*
    
    # 预览结果表格
    head -n3 result/salmon/gene.*
