#!/usr/bin/env bash

source admin/load_fireworks.sh

scripts/load_yaml.py specs/SimForBomb.yaml specs/ndlar_bomb_1/*.yaml

# XXX reset MEVEMTS to 100 or something (or not?)
# XXX add flag to run_larnd_sim to specify pixel geom

name=ndlar_bomb_1
start=0
size=1
logdir=$SCRATCH/job_logs.ndlar_bomb_1

mkdir -p $logdir

scripts/fwsub.py --runner SimForBomb_Edep --base-env ndlar_bomb_1.edep --size $size --start $start
scripts/fwsub.py --runner SimForBomb_LArND --base-env ndlar_bomb_1.larnd --size $size --start $start

# 2048 in 4 nodes = < 10 minutes
sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 4 -t 120 slurm/ndlar_bomb_1/ndlar_bomb_1.edep.slurm.sh

sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-60 -N 4 slurm/ndlar_bomb_1/ndlar_bomb_1.larnd.slurm.sh
