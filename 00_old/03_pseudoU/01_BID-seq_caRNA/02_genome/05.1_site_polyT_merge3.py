#!/usr/bin/env python3

import pandas as pd

import csv
import os
from collections import defaultdict
from optparse import OptionParser
from multiprocessing import Process, current_process

###Count the memory used in this script
import psutil

THREADS = 24
DEBUG = True

INITIATION = 0
NOCANDIDATE = 1

#_____________________________________________________________________        
def filter_sites(del_filename, out_filename, strand):
    print("Filter: " + del_filename + " ...")
    del_file = open(del_filename)
    out_file = open(out_filename, "w")
    
    out_file.write("chrom\tpos\tbase_ref\ttotal_count\tt_count\tdel_count\tdel_ratio\n")
    
    status = INITIATION
    tmp_chrom = ''
    pre_chrom = ''
    pre_pos = -1
    i = 0
    total_count = 0
    ncount = 0
    ndel = 0
    
    for r in csv.DictReader(del_file,delimiter='\t'):
        current_chrom = r['chrom']
        current_pos = r['pos']
        current_base_ref = r['base_ref']
        current_total_count = r['total_count']
        current_t_count = r['t_count']
        current_del_count = r["del_count"]
        current_del_ratio = r['del_ratio']
        
        known_site = False
        
        if status == INITIATION:         
            tmp_chrom = current_chrom
            tmp_pos = current_pos
            tmp_del_ratio = current_del_ratio
            tmp_base_ref = current_base_ref
            tmp_total_count = current_total_count
            tmp_t_count = current_t_count
            tmp_del_count = current_del_count
            
            total_count += int(current_total_count)
            ncount += int(current_t_count)
            ndel += int(current_del_count)

            i += 1
                            
            pre_chrom = current_chrom
            pre_pos = current_pos              

            status = NOCANDIDATE
            continue
        if status == NOCANDIDATE:
            if current_chrom != pre_chrom or ( int(current_pos) != int(pre_pos) + 1 ):
                tmp_del_count = ndel
                tmp_t_count = ncount / i
                tmp_total_count = total_count / i
                if int(tmp_del_count) == 0:
                    tmp_del_ratio = 0
                else:
                    tmp_del_ratio = tmp_del_count / ( tmp_t_count + tmp_del_count )
                

                line = tmp_chrom + '\t' + tmp_pos + '\t' + tmp_base_ref + '\t' + str(tmp_total_count) + '\t' + str(tmp_t_count) + '\t' + str(tmp_del_count) + '\t' + str(tmp_del_ratio) + '\n'
                out_file.write(line)

                status = INITIATION
                tmp_chrom = ''
                total_count = 0
                ndel = 0
                ncount = 0
                i = 0
    
                tmp_chrom = current_chrom
                tmp_pos = current_pos
                tmp_del_ratio = current_del_ratio
                tmp_base_ref = current_base_ref
                tmp_total_count = current_total_count
                tmp_t_count = current_t_count
                tmp_del_count = current_del_count
                
                total_count += int(current_total_count)
                ncount += int(current_t_count)
                ndel += int(current_del_count)
                i += 1
                            
                pre_chrom = current_chrom
                pre_pos = current_pos              

                status = NOCANDIDATE
                continue
            else :                  
                tmp_chrom = current_chrom
                tmp_pos = current_pos
                tmp_del_ratio = current_del_ratio
                tmp_base_ref = current_base_ref
                tmp_total_count = current_total_count
                tmp_t_count = current_t_count
                tmp_del_count = current_del_count
                
                total_count += int(current_total_count)
                ncount += int(current_t_count)
                ndel += int(current_del_count)
                i += 1
                                
                pre_chrom = current_chrom
                pre_pos = current_pos   
                continue 
                                        
    if status != INITIATION :
        tmp_del_count = ndel
        tmp_t_count = ncount / i
        tmp_total_count = total_count / i
        if ( tmp_t_count + tmp_del_count) == 0:
            tmp_del_ratio = 0
        else:
            tmp_del_ratio = tmp_del_count / ( tmp_t_count + tmp_del_count)

        line = tmp_chrom + '\t' + tmp_pos + '\t' + tmp_base_ref + '\t' + str(tmp_total_count) + '\t' + str(tmp_t_count) + '\t' + str(tmp_del_count) + '\t' + str(tmp_del_ratio) + '\n'
        out_file.write(line)
        
    del_file.close()
    out_file.close()
                        
    print("Done.")
    return(0)

#______________________________________________________________________
if __name__ == "__main__":
    print("BID-seq:filtrating deletion site.")
    print("Open sampleTable file...")
    try:
        sampleTable = pd.read_csv("/disk/user_09/Data/09_PseudoU/06_aging_pU_SE/samples_bid.txt",sep='\t',index_col=0)
    except:
        print("ERROR:cannot open \"samples_bid.txt\". QUIT!")
        exit(1)
    print("Done.")

    REPLICATES = 3
    TREAT = 'BS'
    CONTROL = 'input'

    DELIMITER = "."
    print('Using parameters are TREAT: {}, CONTROL:{}, REPLICATES:{}, DELIMITER:{}'.format( TREAT, CONTROL, REPLICATES, DELIMITER))
    
    ###for debug
    if DEBUG :
        pid = os.getpid()
        print("process ID is: " + str(pid) )
        p = psutil.Process(pid)
        info = p.memory_full_info()
        print("Current used memory is: " + str(info.uss) )

    run_list = pd.unique(sampleTable['run'])
    procs = []
    proc_count = 0
    for run in run_list:
        print("Processing GENOME for: " + run)
        del_filename = "./04_hisat2_mapping/04_bam_readcount/" + run + "_pos.txt"
        out_filename = "./04_hisat2_mapping/05_polyT_merge/" + run + "_pos.txt"
        proc = Process(target=filter_sites, args=(del_filename, out_filename, '+'))
        proc.start()
        procs.append(proc)
        proc_count += 1
        
        del_filename = "./04_hisat2_mapping/04_bam_readcount/" + run + "_neg.txt"
        out_filename = "./04_hisat2_mapping/05_polyT_merge/" + run + "_neg.txt"
        proc = Process(target=filter_sites, args=(del_filename, out_filename, '-'))
        proc.start()
        procs.append(proc)
        proc_count += 1
        if proc_count >= THREADS :
            for proc in procs :
                proc.join()
            procs = []
            proc_count = 0
        
    if proc_count > 0 :
        for proc in procs :
            proc.join()
        proc = []
        proc_count = 0
    try:
        pass
    except KeyboardInterrupt:
        sys.stderr.write("KeyboardInterrupt exiting...)\n")
        exit(1)


