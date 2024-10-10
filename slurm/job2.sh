#!/bin/bash
#SBATCH --job-name=test_job     # Job name
#SBATCH --output=result.out     # Output file
#SBATCH --error=error.log       # Error log file
#SBATCH --ntasks=1              # Number of tasks (processes)
#SBATCH --cpus-per-task=2       # Number of CPU cores per task
#SBATCH --nodes=1               # Number of nodes (reduce if simulating)
#SBATCH --time=00:10:00         # Wall time (10 minutes)
#SBATCH --mem=1G                # Memory per node
