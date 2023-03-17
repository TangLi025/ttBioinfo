zcat /disk/user_08/Data/TC1-planB/04_bam_rm_rRNA_bowtie2/p5_input_rep1.2.derRNA.fq.gz |grep -A 2 -B 1 --no-group-separator '^TTTTT' > p5_input_rep1.2.polyT.fq &
zcat /disk/user_08/Data/TC1-planB/04_bam_rm_rRNA_bowtie2/p5_input_rep1.1.derRNA.fq.gz |grep -A 2 -B 1 --no-group-separator '^TTTTT' > p5_input_rep1.1.polyT.fq &
zcat /disk/user_08/Data/TC1-planB/04_bam_rm_rRNA_bowtie2/p5_input_rep1.2.derRNA.fq.gz |grep -A 2 -B 1 --no-group-separator 'AAAAA$' > p5_input_rep1.2.polyA.fq &
zcat /disk/user_08/Data/TC1-planB/04_bam_rm_rRNA_bowtie2/p5_input_rep1.1.derRNA.fq.gz |grep -A 2 -B 1 --no-group-separator 'AAAAA$' > p5_input_rep1.1.polyA.fq &

zcat /disk/user_08/Data/TC1-planB/04_bam_rm_rRNA_bowtie2/p5_input_rep1.2.derRNA.fq.gz | grep --color=auto -A 2 -B 1 --no-group-separator '^TTTTTTTTTT' > p5_input_rep1.2.polyT10.fq &
zcat /disk/user_08/Data/TC1-planB/04_bam_rm_rRNA_bowtie2/p5_input_rep1.1.derRNA.fq.gz | grep --color=auto -A 2 -B 1 --no-group-separator '^TTTTTTTTTT' > p5_input_rep1.1.polyT10.fq &
zcat /disk/user_08/Data/TC1-planB/04_bam_rm_rRNA_bowtie2/p5_input_rep1.2.derRNA.fq.gz | grep --color=auto -A 2 -B 1 --no-group-separator 'AAAAAAAAAA$' > p5_input_rep1.2.polyA10.fq &
zcat /disk/user_08/Data/TC1-planB/04_bam_rm_rRNA_bowtie2/p5_input_rep1.1.derRNA.fq.gz | grep --color=auto -A 2 -B 1 --no-group-separator 'AAAAAAAAAA$' > p5_input_rep1.1.polyA10.fq &

for i in {1,2}
do
for j in {polyA,polyA10,polyT,polyT10}
do
/disk/user_09/anaconda3/envs/LinLong/bin/hisat2 -x /disk/user_09/reference/index/hisat2/mm39/mm39 \
    --summary-file 01_hisat2_mapping/p5_input_rep1.${i}.${j}.summary.txt \
    -p 30 -U 00_polyA_fq/p5_input_rep1.${i}.${j}.fq --un 01_hisat2_mapping/p5_input_rep1.${i}.${j}.dem.fq \
    | /disk/user_09/anaconda3/envs/LinLong/bin/samtools view -@ 30 -bS \
    | /disk/user_09/anaconda3/envs/LinLong/bin/samtools sort -@ 30 -o 01_hisat2_mapping/p5_input_rep1.${i}.${j}.bam &
done
done