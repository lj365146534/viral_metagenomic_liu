for i in `cat 1host/all_faces_sample.txt`
	do
	bowtie2 --very-sensitive-local -x /home/ngs2/Desktop/Liujia/db/SILVA_LLU_SSU_rRNA/SILVA_138.1_LSUref_SSURef_NR99_tax -q bowtie/nohost_${i}.fastq --un-gz bowtie/nohost_silva_${i}.fastq.gz -S bowtie/nohost_silva_${i}.sam -p 32
	rm bowtie/nohost_silva_${i}.sam
	rm bowtie/nohost_${i}.fastq
done
	