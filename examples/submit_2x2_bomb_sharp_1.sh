#!/usr/bin/env bash

source admin/load_fireworks.sh

scripts/load_yaml.py specs/SimForBomb.yaml specs/2x2_bomb_sharp_1/*.yaml

name=2x2_bomb_sharp_1
start=0
size=10240                      # XXX go up to start=10240 size=10240
logdir=$SCRATCH/job_logs.${name}

# XXX uncomment run-edep-sim after reconverting 2x2_sharp first 20480

mkdir -p $logdir

scripts/fwsub.py --runner SimForBomb_Edep --base-env ${name}.edep --size $size --start $start
# scripts/fwsub.py --runner SimForBomb_Convert2H5 --base-env 2x2_bomb_1.convert2h5 --size $size --start $start
scripts/fwsub.py --runner SimForBomb_LArND --base-env ${name}.larnd --size $size --start $start

sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 4 -t 120 slurm/fw_cpu.slurm.sh ${name}.edep rapidfire

sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-100 -N 4 -t 120 slurm/fw_gpu.slurm.sh ${name}.larnd rapidfire

# cori
sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-4 -N 4 -t 120 slurm/fw_cpu.cori.slurm.sh ${name}.edep rapidfire
