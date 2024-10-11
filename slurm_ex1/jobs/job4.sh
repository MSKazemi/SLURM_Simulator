#!/bin/bash
#SBATCH --job-name=dummy_job          # Job name
#SBATCH --output=job_output_%j.out    # Output file, %j is replaced with job ID
#SBATCH --error=job_error_%j.err      # Error file
#SBATCH --ntasks=1                    # Number of tasks (processes)
#SBATCH --cpus-per-task=1             # CPU cores per task
#SBATCH --mem=1G                      # Memory per node
#SBATCH --nodes=1                     # Request 2 virtual nodes
#SBATCH --time=00:00:30               # Time limit (5 minutes)

echo "Dummy job started on $(date)"
sleep 2                             # Simulate a task with 2 minutes sleep
echo "Dummy job finished on $(date)"

