# Comparative-Bacterial-Genome-Assembly-SPAdes-Flye-Unicycler
A bioinformatics project comparing the performance of three genome assemblers (SPAdes, Flye, and Unicycler) on Illumina short-read data for a bacterial isolate. The project evaluates assembly quality based on contiguity, completeness, and the accurate detection of antimicrobial resistance (AMR) genes.

## 📊 Overview

Advances in next-generation sequencing (NGS) have revolutionized microbial genomics, but the choice of assembler significantly impacts results. This project provides a practical workflow and analysis for:
1.  Quality control and trimming of Illumina paired-end reads.
2.  *De novo* genome assembly using **SPAdes** (short-read), **Flye** (long-read), and **Unicycler** (hybrid).
3.  Comparative assembly evaluation using **QUAST**.
4.  Screening for antimicrobial resistance genes using **ABRICATE** and the ResFinder database.

## 🧬 Results Summary

| Assembler | # Contigs | N50 (bp)     | Total Length (bp) | Key Strength                  |
| :-------- | :-------: | :----------- | :---------------- | :---------------------------- |
| **SPAdes**    |    210    | 59,947       | 5,031,610         | Gene-level accuracy (100% ID) |
| **Flye**      |    20     | **1,044,833**    | **5,190,619**         | **Superior contiguity**           |
| **Unicycler** |    32     | 1,297,187    | 5,142,940         | Balanced performance          |

All assemblers successfully identified five key AMR genes with 100% coverage:
*   `blaCTX-M-55`, `blaEC-18` (β-lactam resistance)
*   `aac(3)-IId` (Aminoglycoside resistance)
*   `qnrS1` (Quinolone resistance)
*   `tet(A)` (Tetracycline resistance)

## 🛠️ Tools Used

*   **Quality Control:** FastQC
*   **Trimming:** Trimmomatic
*   **Assembly:**
    *   SPAdes v3.15.5
    *   Flye (pre-assembled)
    *   Unicycler (pre-assembled)
*   **Evaluation:** QUAST v5.2.0
*   **AMR Screening:** ABRICATE v1.0.0 (ResFinder database)
*   **Environment:** Compute Canada's Graham HPC cluster

## 🚀 Quick Start

1.  **Load Modules** (on a compatible HPC system):
    ```bash
    module load StdEnv/2020 gcc/9.3.0 python/3.8.10
    module load fastqc trimmomatic spades quast/5.2.0 abricate/1.0.0
    ```

2.  **Run Quality Control and Trimming** (see `code/01_quality_control.sh`):
    ```bash
    fastqc data/raw_reads/*.fastq -o results/fastqc_reports/
    java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar PE -threads 8 \
    data/raw_reads/illumina_R1.fastq data/raw_reads/illumina_R2.fastq \
    results/trimmed_reads/R1_trimmed_paired.fastq results/trimmed_reads/R1_trimmed_unpaired.fastq \
    results/trimmed_reads/R2_trimmed_paired.fastq results/trimmed_reads/R2_trimmed_unpaired.fastq \
    ILLUMINACLIP:$EBROOTTRIMMOMATIC/adapters/TruSeq3-PE.fa:2:30:10 \
    LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50
    ```

3.  **Assemble with SPAdes** (submit SLURM job):
    ```bash
    sbatch code/02_assembly_spades.slurm
    ```

4.  **Evaluate Assemblies with QUAST**:
    ```bash
    quast.py results/assembly_spades/contigs.fasta \
             data/prebuilt_assemblies/assembly_flye.fasta \
             data/prebuilt_assemblies/assembly_unicycler.fasta \
             -o results/quast_comparison/ \
             --labels "SPAdes,Flye,Unicycler" \
             --gene-finding
    ```

5.  **Screen for AMR Genes**:
    ```bash
    abricate results/assembly_spades/contigs.fasta > results/amr_results/amr_spades.tsv
    abricate --summary results/amr_results/amr_*.tsv > results/amr_results/amr_summary.txt
    ```

## 🔬 Key Conclusions

*   **Flye** produced the most contiguous assembly, ideal for analyzing large-scale genomic structure.
*   **SPAdes** showed the highest per-base accuracy for gene annotation, despite higher fragmentation.
*   **Unicycler** provided a balanced compromise between contiguity and accuracy.
*   All assemblers were equally effective for detecting AMR genes at 100% coverage, making SPAdes a efficient choice for clinical AMR screening projects where contiguity is less critical.

## 📚 References

*   Bankevich et al. (2012). SPAdes: A New Genome Assembly Algorithm. _J Comput Biol_.
*   Kolmogorov et al. (2019). Assembly of long, error-prone reads using repeat graphs. _Nat Biotechnol_.
*   Wick et al. (2017). Unicycler: Resolving bacterial genome assemblies. _PLoS Comput Biol_.
*   Feldgarden et al. (2021). AMRFinderPlus. _Sci Rep_.
