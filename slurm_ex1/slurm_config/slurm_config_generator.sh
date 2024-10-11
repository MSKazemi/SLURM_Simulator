#!/bin/bash

# Source the configuration file
source config.sh

# Define the output file
slurm_conf="slurm.conf"

# Create the slurm.conf content
cat <<EOL > $slurm_conf
ClusterName=cluster
ControlMachine=$CONTROL_NODE 
SlurmUser=slurm
AuthType=auth/munge
StateSaveLocation=/var/spool/slurmctld
SlurmdSpoolDir=/var/spool/slurmd
SwitchType=switch/none
MpiDefault=none
SlurmctldPort=6817
SlurmdPort=6818
ProctrackType=proctrack/pgid
ReturnToService=2
SlurmctldTimeout=120
SlurmdTimeout=300
SchedulerType=sched/backfill
SelectType=select/cons_res
SelectTypeParameters=CR_Core
SchedulerParameters=simulate,fast_schedule=1

AccountingStorageType=accounting_storage/slurmdbd
AccountingStorageHost=localhost
AccountingStoragePort=6819       # Default port for slurmdbd
AccountingStorageUser=slurm

# Controller node is not used for jobs
# NodeName=${CONTROL_NODE} CPUs=${CONTROL_NODE_CPUS} State=UNKNOWN

# Define the Control Node
NodeName=${CONTROL_NODE} CPUs=${CONTROL_NODE_CPUS} RealMemory=${CONTROL_NODE_MEMORY} State=UNKNOWN

# Define the Worker Nodes
NodeName=node[1-4] CPUs=${WORKER_NODE_CPUS} RealMemory=${WORKER_NODE_MEMORY} State=UNKNOWN

# Define the Partition
PartitionName=debug Nodes=${CONTROL_NODE},node[1-4] Default=YES MaxTime=INFINITE State=UP
EOL

# Print the generated slurm.conf file for verification
cat $slurm_conf
