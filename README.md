# Job Array Blast
Slurm job array generator for blast.

# Usage:
```sh
./generate-blast-commands.sh <fastq-input> <database>
./mt_slurm_parallel_ja_submit.sh commands.txt <nthreads-per-blast>
Change num_threads in single-blast.sh
(Optional) Modify the time in the <jobscript>
sbatch --array=1-<nnodes> <jobscript>
```

# Contact
- High Performance Computing Team, New York University in Abu Dhabi (guowei.he@nyu.edu)
