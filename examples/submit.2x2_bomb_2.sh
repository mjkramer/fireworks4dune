#!/usr/bin/env bash

source admin/load_fireworks.sh
set +o posix                    # sneaky sneaky, NERSC

name=2x2_bomb_2
start=0
single_size=1
logdir=$SCRATCH/logs.$name
# export FW4DUNE_SLEEP_SEC=60
export FW4DUNE_SLEEP_SEC=1

scripts/load_yaml.py specs/SimForBomb.yaml specs/2x2_bomb_2/*.yaml

mkdir -p "$logdir"

scripts/fwsub.py --runner SimForBomb_Edep --base-env $name.edep --size $single_size --start $start
scripts/fwsub.py --runner SimForBomb_LArND --base-env $name.larnd --size $single_size --start $start

sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 4 -t 120 slurm/fw_cpu.slurm.sh $name.edep rapidfire

sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-60 -N 4 -t 120 slurm/fw_gpu.slurm.sh $name.larnd rapidfire
