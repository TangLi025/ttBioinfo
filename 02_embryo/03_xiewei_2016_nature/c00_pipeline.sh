cd ~/Data/02_embryo/06_embryo_xiewei/00_raw_sra
conda activate m6A
for i in {292..308}; do prefetch -X 100G GSM1845${i} & done
cd ../

mkdir 00_raw_fastq
for i in {53..69}; do fasterq-dump -O 00_raw_fastq -e 40 -3 00_raw_sra/SRR21472${i}/SRR21472${i}.sra; done &

cd 00_raw_fastq

rename SRR2147253 Growing_oocyte_10days *
rename SRR2147254 Growing_oocyte_14days *
rename SRR2147255 GV_8weeks *
rename SRR2147256 MII_oocyte_rep1 *
rename SRR2147257 MII_oocyte_rep2 *
rename SRR2147258 zygote_PN5_rep1 *
rename SRR2147259 zygote_PN5_rep2 *
rename SRR2147260 early_2cell_rep1 *
rename SRR2147261 early_2cell_rep2 *
rename SRR2147262 late_2cell_rep1 *
rename SRR2147263 late_2cell_rep2 *
rename SRR2147264 cell4_rep1 *
rename SRR2147265 cell4_rep2 *
rename SRR2147266 cell8_rep1 *
rename SRR2147267 cell8_rep2 *
rename SRR2147268 ICM_rep1 *
rename SRR2147269 ICM_rep2 *

cd ../

snakemake -s ~/ttBioinfo/02_embryo/03_xiewei_2016_nature/c01_cutadapter.sm -p -c 55 &

snakemake -s ~/ttBioinfo/02_embryo/03_xiewei_2016_nature/c02_bowtie2_rRNA.sm -p -c 55
snakemake -s ~/ttBioinfo/02_embryo/03_xiewei_2016_nature/c03_hisat2_genome.sm -p -c 55
snakemake -s ~/ttBioinfo/02_embryo/03_xiewei_2016_nature/c04_bam_merge.sm -p -c 55