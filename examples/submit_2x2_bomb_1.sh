#!/usr/bin/env bash

source admin/load_fireworks.sh

scripts/load_yaml.py specs/SimForBomb.yaml specs/2x2_bomb_1/*.yaml

start=36864
size=10240
logdir=$SCRATCH/job_logs.2x2_bomb_1

mkdir -p $logdir

scripts/fwsub.py --runner SimForBomb_Edep --base-env 2x2_bomb_1.edep --size $size --start $start
# scripts/fwsub.py --runner SimForBomb_Convert2H5 --base-env 2x2_bomb_1.convert2h5 --size $size --start $start
scripts/fwsub.py --runner SimForBomb_LArND --base-env 2x2_bomb_1.larnd --size $size --start $start

# 2048 in 4 nodes = < 10 minutes
sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 4 -t 120 slurm/2x2_bomb_1/2x2_bomb_1.edep.slurm.sh

# sbatch -o $logdir/slurm-%j.txt --array=1-1 -N 1 slurm/2x2_bomb_1/2x2_bomb_1.convert2h5.slurm.sh

sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-60 -N 4 slurm/2x2_bomb_1/2x2_bomb_1.larnd.slurm.sh
