mkdir -p dmnd_virus

#分别denovo组装
for i in `cat ../01trim/1host/all_faces_sample.txt`
do
	#diamond和checkv的病毒参考库比较
	diamond blastx -b12 -c1 --outfmt 6 --db /home/ngs2/Desktop/Liujia/Poyanglake/Faces_sample/02denovo/diamond_db/checkv_reps.dmnd -q 01megahit/${i}/final.contigs.fa --out dmnd_virus/${i}.fmt6.out
done
