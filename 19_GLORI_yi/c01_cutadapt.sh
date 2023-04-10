# fastqc
mkdir -p info/00_raw_fastq
mkdir -p logs/00_raw_fastq
nohup fastqc -o info/00_raw_fastq -t 20 00_raw_fastq/* 1> logs/00_raw_fastq/fastqc.log 2>&1 &

# cutadapt
mkdir -p logs/01_trim_galore
for i in `ls 00_raw_fastq`
do
nohup /disk/user_09/anaconda3/envs/trim-galore/bin/trim_galore -q 20 --stringency 1 -e 0.3 --length 35 -o 01_trim_galore --gzip --path_to_cutadapt /disk/user_09/anaconda3/envs/trim-galore/bin/cutadapt -j 8 00_raw_fastq/${i} 1> logs/01_trim_galore/${i%%.fastq}.log 2>&1 &
done

