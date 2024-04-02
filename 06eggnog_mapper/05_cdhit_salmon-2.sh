#!/bin/bash
# mamba activate /home/ngs2/anaconda3/envs/snakemake_env


#基因聚类/去冗余cd-hit
mkdir -p result/NR
mkdir -p temp/salmon-230618
### 3.2.3 基因定量salmon

    # 输入文件：去冗余后的基因和蛋白序列：result/NR/nucleotide.fa
    # 输出文件：Salmon定量后的结果：result/salmon/gene.count, gene.TPM
    
    mkdir -p temp/salmon-230618
    salmon -v # 1.8.0
    
    # 建索引, -t序列, -i 索引，10s
    salmon index \
      -t result/NR-230618/nucleotide.fa \
      -p 20 \
      -i temp/salmon-230618/index 
	  
    # salmon index \
      # -t result/NR-230618/full_nucleotide.fa \
      # -p 20 \
      # -i temp/salmon-230618/full_index 


    # # aS覆盖度，c相似度，G局部比对，g最优解，T多线程，M内存0不限制
    # # 2万基因2m，2千万需要2000h，多线程可加速
        # time cd-hit-est -i temp/prodigal/${i}.gene.fa \
        ##time cd-hit-est -i temp/prodigal/${i}.full_length.fa
        # -o result/NR/${i}.full_length_nucleotide.fa \
        # -aS 0.9 -c 0.95 -G 0 -g 0 -T 0 -M 0
    # # 统计非冗余基因数量，单次拼接结果数量下降不大，多批拼接冗余度高
    # grep -c '>' result/NR/${i}.full_length_nucleotide.fa >> result/NR/3_ncgene_count.txt
    # # 翻译核酸为对应蛋白序列，emboss
    # transeq -sequence result/NR/${i}.full_length_nucleotide.fa \
    # -outseq result/NR/${i}.protein.fa -trim Y 
    # # 序列名自动添加了_1，为与核酸对应要去除
    # sed -i 's/_1 / /' result/NR/${i}.protein.fa
    # # 两批数据去冗余使用cd-hit-est-2d加速，见附录
for i in `cat ../01trim/1host/all_faces_sample_nodel_zero.txt`
do
	salmon quant -i temp/salmon-230618/index -l A -p 40 --meta -r ../01trim/bowtie/nohost_silva_${i}.fastq.gz -o temp/salmon-230618/${i}.quant
done


#get merge quant
    mkdir -p result/salmon-230618
    salmon quantmerge --quants temp/salmon-230618/*.quant \
        -o result/salmon-230618/gene.TPM
    salmon quantmerge --quants temp/salmon-230618/*.quant \
        --column NumReads -o result/salmon-230618/gene.count
    sed -i '1 s/.quant//g' result/salmon-230618/gene.*


# for i in `cat ../01trim/1host/all_faces_sample.txt`
# do
	# salmon quant -i temp/salmon/full_index -l A -p 20 --meta -r ../01trim/bowtie/nohost_silva_${i}.fastq.gz -o temp/salmon/full.${i}.quant
# done

#get merge quant
    # mkdir -p result/salmon
    # salmon quantmerge --quants temp/salmon/full.*.quant \
        # -o result/salmon/full.gene.TPM
    # salmon quantmerge --quants temp/salmon/full.*.quant \
        # --column NumReads -o result/salmon/full.gene.count
    # sed -i '1 s/.quant//g' result/salmon/full.gene.*
	# sed -i '1 s/full.//g' result/salmon/full.gene.*





# 预览结果表格
head -n 3 result/salmon-230618/gene.*

#head -n 3 result/salmon/full.gene.*


