conda activate m6A
for i in `ls 00_raw_sra`
do
fasterq-dump 00_raw_sra/${i}/${i}.sra -O 00_raw_fastq -e 40 -3
done


00_raw_sra/SRR805223/SRR805223.sra

fasterq-dump 00_raw_sra/SRR805223/SRR805223.sra -O 00_raw_fastq -e 40 -3

conda activate m6A
for i in `cat SRR_list.txt`; do prefetch -X 100G ${i} & done

for i in `cat /disk/user_09/ttBioinfo/02_embryo/02_Deng_2014/smart-seq/01_SRRlist`
do
fasterq-dump 00_raw_sra/${i}/${i}.sra -O 00_raw_fastq -e 40 -3
done

/disk/user_09/anaconda3/envs/LinLong/bin/fastqc -t 40 -o 01_fastqc *.fastq &

cd ~/Data/02_embryo/01_mouse_embryo_scRNA-seq_2014_Deng/00_raw_fastq
for i in {1..259}
do
    rename `head -n ${i} /disk/user_09/ttBioinfo/02_embryo/02_Deng_2014/smart-seq/01_SRRlist | tail -n 1` \
    `head -n ${i} /disk/user_09/ttBioinfo/02_embryo/02_Deng_2014/smart-seq/01_sample_list | tail -n 1` *
done

rename `head -n 1 /disk/user_09/ttBioinfo/02_embryo/02_Deng_2014/smart-seq/01_SRRlist | tail -n 1` \
    `head -n 1 /disk/user_09/ttBioinfo/02_embryo/02_Deng_2014/smart-seq/01_sample_list | tail -n 1` *


