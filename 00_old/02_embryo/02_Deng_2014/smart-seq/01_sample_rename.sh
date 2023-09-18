cd ~/Data/02_embryo/01_mouse_embryo_scRNA-seq_2014_Deng/00_raw_fastq
for SRR in `cat /disk/user_09/ttBioinfo/02_embryo/02_Deng_2014/smart-seq/01_SRRlist`
do
    for sample in `cat /disk/user_09/ttBioinfo/02_embryo/02_Deng_2014/smart-seq/01_sample_list`
    do
        rename ${SRR} ${sample} ${SRR}.fastq
    done
done

for i in {1..259}
do
    head -n ${i} /disk/user_09/ttBioinfo/02_embryo/02_Deng_2014/smart-seq/01_SRRlist | tail -n 1
    head -n ${i} /disk/user_09/ttBioinfo/02_embryo/02_Deng_2014/smart-seq/01_sample_list | tail -n 1
done
