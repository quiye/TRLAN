#!/bin/bash
#============ LSF Options ============
#QSUB -q gr20101d
#QSUB -ug gr20114
#QSUB -W 24:00
#QSUB -A p=1:t=28:c=28:m=60G

#============ Shel Script ============
set -x

module load intel
module switch intel/15.0.6 intel/16.0.2

ulimit -s unlimited
export OMP_STACKSIZE=10G

aprun -n $LSB_PROCS -d $LSB_CPUS -N $LSB_PPN numactl -l ./fileinput_gkl 10 s 20 < sparse_data10.txt > l10-10.txt
aprun -n $LSB_PROCS -d $LSB_CPUS -N $LSB_PPN numactl -l ./fileinput_gkl 20 s 20 < sparse_data10.txt > l10-20.txt
aprun -n $LSB_PROCS -d $LSB_CPUS -N $LSB_PPN numactl -l ./fileinput_gkl 30 s 20 < sparse_data10.txt > l10-30.txt
aprun -n $LSB_PROCS -d $LSB_CPUS -N $LSB_PPN numactl -l ./fileinput_gkl 10 s 20 < sparse_data20.txt > l20-10.txt
aprun -n $LSB_PROCS -d $LSB_CPUS -N $LSB_PPN numactl -l ./fileinput_gkl 20 s 20 < sparse_data20.txt > l20-20.txt
aprun -n $LSB_PROCS -d $LSB_CPUS -N $LSB_PPN numactl -l ./fileinput_gkl 30 s 20 < sparse_data20.txt > l20-30.txt
aprun -n $LSB_PROCS -d $LSB_CPUS -N $LSB_PPN numactl -l ./fileinput_gkl 10 s 20 < sparse_data30.txt > l30-10.txt
aprun -n $LSB_PROCS -d $LSB_CPUS -N $LSB_PPN numactl -l ./fileinput_gkl 20 s 20 < sparse_data30.txt > l30-20.txt
aprun -n $LSB_PROCS -d $LSB_CPUS -N $LSB_PPN numactl -l ./fileinput_gkl 30 s 20 < sparse_data30.txt > l30-30.txt

