#!/bin/bash

Thread=20

genomdir=~/reference/index/STAR/GLORI
genome2=${genomdir}/hg38.fa
genome=${genomdir}/hg38.AG_conversion.fa
rvsgenome=${genomdir}/hg38.rvsCom.fa

genomdir2=~/reference/index/bowtie/GCF_000001405.39_GRCh38.p13_rna2.fa.AG_conversion
TfGenome=${genomdir2}/GCF_000001405.39_GRCh38.p13_rna2.fa.AG_conversion.fa

annodir=~/reference/annotation/hg38/GLORI
baseanno=${annodir}/GCF_000001405.39_GRCh38.p13_genomic.gtf_change2Ens.tbl2.noredundance.base
anno=${annodir}/GCF_000001405.39_GRCh38.p13_genomic.gtf_change2Ens.tbl2

tooldir=~/software/GLORI-tools

outputdir=~/Data/19_GLORI_yi/04_GLORI_anno
for i in {1,2}
do
file=~/Data/19_GLORI_yi/03_umi_trim/HEK293T_GLORI${i}_trimmed.fq
prx=HEK293T_GLORI${i}
nohup python ${tooldir}/run_GLORI.py \
    -i $tooldir -q $file -T $Thread -f ${genome} \
    -f2 ${genome2} -rvs ${rvsgenome} -Tf ${TfGenome} \
    -a $anno -b $baseanno -pre ${prx} -o $outputdir \
    --combine --rvs_fac 1> ~/Data/19_GLORI_yi/04_GLORI_anno/GLORI${i}.log 2>&1 &
done