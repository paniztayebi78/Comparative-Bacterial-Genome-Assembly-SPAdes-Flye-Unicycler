#!/bin/bash
#SBATCH --job-name=spades_asm
#SBATCH --output=spades.log
#SBATCH --time=6:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G

module load spades

spades.py \
  -1 ../Trimmed/136x2_R1_trimmed_paired.fastq \
  -2 ../Trimmed/136x2_R2_trimmed_paired.fastq \
  -o ../Assembly \
  --careful \
  --threads 8 \
  --memory 32
