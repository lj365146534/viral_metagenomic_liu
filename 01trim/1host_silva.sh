mkdir bowtie

for i in `cat 1host/Anatidae.txt`
	do
	gzip -dc fq/${i}.fastq.gz > fq/${i}.clean.fastq
	bowtie2 --very-sensitive-local -x /home/ngs2/Desktop/Liujia/db/avain_ref/Anatidae/Anatitae_ref_Anser_indicus -q fq/${i}.clean.fastq --un bowtie/nohost_${i}.fastq -S bowtie/${i}.sam -p 32
	rm fq/${i}.clean.fastq bowtie/${i}.sam
	
	bowtie2 --very-sensitive-local -x /home/ngs2/Desktop/Liujia/db/SILVA_LLU_SSU_rRNA/SILVA_138.1_LSUref_SSURef_NR99_tax -q bowtie/nohost_${i}.fastq --un-gz bowtie/nohost_silva_${i}.fastq.gz -S bowtie/nohost_silva_${i}.sam -p 32
	rm bowtie/nohost_silva_${i}.sam
	rm bowtie/nohost_${i}.fastq
	
	done

for i in `cat 1host/Ardeidae.txt`
	do
	gzip -dc fq/${i}.fastq.gz > fq/${i}.clean.fastq
	bowtie2 --very-sensitive-local -x /home/ngs2/Desktop/Liujia/db/avain_ref/Ardeidae/Ardeidae_ref_Nycticorax -q fq/${i}.clean.fastq --un bowtie/nohost_${i}.fastq -S bowtie/${i}.sam -p 32
	rm fq/${i}.clean.fastq bowtie/${i}.sam
	
	bowtie2 --very-sensitive-local -x /home/ngs2/Desktop/Liujia/db/SILVA_LLU_SSU_rRNA/SILVA_138.1_LSUref_SSURef_NR99_tax -q bowtie/nohost_${i}.fastq --un-gz bowtie/nohost_silva_${i}.fastq.gz -S bowtie/nohost_silva_${i}.sam -p 32
	rm bowtie/nohost_silva_${i}.sam
	rm bowtie/nohost_${i}.fastq
	
	done

for i in `cat 1host/Rallidae.txt`
	do
	gzip -dc fq/${i}.fastq.gz > fq/${i}.clean.fastq
	bowtie2 --very-sensitive-local -x /home/ngs2/Desktop/Liujia/db/avain_ref/Rallidae/Rallidae_ref_Fulica_atra -q fq/${i}.clean.fastq --un bowtie/nohost_${i}.fastq -S bowtie/${i}.sam -p 32
	rm fq/${i}.clean.fastq bowtie/${i}.sam
	
	bowtie2 --very-sensitive-local -x /home/ngs2/Desktop/Liujia/db/SILVA_LLU_SSU_rRNA/SILVA_138.1_LSUref_SSURef_NR99_tax -q bowtie/nohost_${i}.fastq --un-gz bowtie/nohost_silva_${i}.fastq.gz -S bowtie/nohost_silva_${i}.sam -p 32
	rm bowtie/nohost_silva_${i}.sam
	rm bowtie/nohost_${i}.fastq
	
	done

for i in `cat 1host/Recurvirostridae.txt`
	do
	gzip -dc fq/${i}.fastq.gz > fq/${i}.clean.fastq
	bowtie2 --very-sensitive-local -x /home/ngs2/Desktop/Liujia/db/avain_ref/Recurvirostridae/Recurvirostridae_ref_Recurvirostra_avosetta -q fq/${i}.clean.fastq --un bowtie/nohost_${i}.fastq -S bowtie/${i}.sam -p 32
	rm fq/${i}.clean.fastq bowtie/${i}.sam
	
	bowtie2 --very-sensitive-local -x /home/ngs2/Desktop/Liujia/db/SILVA_LLU_SSU_rRNA/SILVA_138.1_LSUref_SSURef_NR99_tax -q bowtie/nohost_${i}.fastq --un-gz bowtie/nohost_silva_${i}.fastq.gz -S bowtie/nohost_silva_${i}.sam -p 32
	rm bowtie/nohost_silva_${i}.sam
	rm bowtie/nohost_${i}.fastq
	
	done

for i in `cat 1host/Charadriidae.txt`
	do
	gzip -dc fq/${i}.fastq.gz > fq/${i}.clean.fastq
	bowtie2 --very-sensitive-local -x /home/ngs2/Desktop/Liujia/db/avain_ref/Charadriidae/Charadriidae_ref_Pluvialis_apricaria -q fq/${i}.clean.fastq --un bowtie/nohost_${i}.fastq -S bowtie/${i}.sam -p 32
	rm fq/${i}.clean.fastq bowtie/${i}.sam
	
	bowtie2 --very-sensitive-local -x /home/ngs2/Desktop/Liujia/db/SILVA_LLU_SSU_rRNA/SILVA_138.1_LSUref_SSURef_NR99_tax -q bowtie/nohost_${i}.fastq --un-gz bowtie/nohost_silva_${i}.fastq.gz -S bowtie/nohost_silva_${i}.sam -p 32
	rm bowtie/nohost_silva_${i}.sam
	rm bowtie/nohost_${i}.fastq
	
	done

for i in `cat 1host/Podicedidae.txt`
	do
	gzip -dc fq/${i}.fastq.gz > fq/${i}.clean.fastq
	bowtie2 --very-sensitive-local -x /home/ngs2/Desktop/Liujia/db/avain_ref/Podicedidae/Podicedidae_ref_Podiceps_cristatus -q fq/${i}.clean.fastq --un bowtie/nohost_${i}.fastq -S bowtie/${i}.sam -p 32
	rm fq/${i}.clean.fastq bowtie/${i}.sam
	
	bowtie2 --very-sensitive-local -x /home/ngs2/Desktop/Liujia/db/SILVA_LLU_SSU_rRNA/SILVA_138.1_LSUref_SSURef_NR99_tax -q bowtie/nohost_${i}.fastq --un-gz bowtie/nohost_silva_${i}.fastq.gz -S bowtie/nohost_silva_${i}.sam -p 32
	rm bowtie/nohost_silva_${i}.sam
	rm bowtie/nohost_${i}.fastq
	
	done

for i in `cat 1host/Falconidae.txt`
	do
	gzip -dc fq/${i}.fastq.gz > fq/${i}.clean.fastq
	bowtie2 --very-sensitive-local -x /home/ngs2/Desktop/Liujia/db/avain_ref/Falconidae/Falconidae_ref_Falco_peregrinus -q fq/${i}.clean.fastq --un bowtie/nohost_${i}.fastq -S bowtie/${i}.sam -p 32
	rm fq/${i}.clean.fastq bowtie/${i}.sam
	
	bowtie2 --very-sensitive-local -x /home/ngs2/Desktop/Liujia/db/SILVA_LLU_SSU_rRNA/SILVA_138.1_LSUref_SSURef_NR99_tax -q bowtie/nohost_${i}.fastq --un-gz bowtie/nohost_silva_${i}.fastq.gz -S bowtie/nohost_silva_${i}.sam -p 32
	rm bowtie/nohost_silva_${i}.sam
	rm bowtie/nohost_${i}.fastq
	
	done

for i in `cat 1host/Strigiformes.txt`
	do
	gzip -dc fq/${i}.fastq.gz > fq/${i}.clean.fastq
	bowtie2 --very-sensitive-local -x /home/ngs2/Desktop/Liujia/db/avain_ref/Strigiformes/Strigiformes_ref_Athene_cunicularia -q fq/${i}.clean.fastq --un bowtie/nohost_${i}.fastq -S bowtie/${i}.sam -p 32
	rm fq/${i}.clean.fastq bowtie/${i}.sam
	
	bowtie2 --very-sensitive-local -x /home/ngs2/Desktop/Liujia/db/SILVA_LLU_SSU_rRNA/SILVA_138.1_LSUref_SSURef_NR99_tax -q bowtie/nohost_${i}.fastq --un-gz bowtie/nohost_silva_${i}.fastq.gz -S bowtie/nohost_silva_${i}.sam -p 32
	rm bowtie/nohost_silva_${i}.sam
	rm bowtie/nohost_${i}.fastq
	
	done

