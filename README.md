# SLURM Simulator

[TOC]

## MUNGE

MUNGE (MUNGE Uid 'N' Gid Emporium) is an authentication service used by SLURM for secure communication between nodes.

```bash
sudo apt update
sudo apt install -y munge libmunge-dev libmunge2
```
### Configure MUNGE

```bash
sudo /usr/sbin/create-munge-key
sudo chown munge: /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key
```


```bash
sudo systemctl start munge
sudo systemctl enable munge
sudo systemctl status munge
```


### Manually Create the MUNGE Key
```bash
sudo dd if=/dev/urandom bs=1 count=1024 > /etc/munge/munge.key
sudo chown munge: /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key

sudo chown -R munge: /etc/munge
sudo chmod 0700 /etc/munge
sudo chmod 0400 /etc/munge/munge.key


sudo mkdir -p /var/log/munge
sudo chown -R munge: /var/log/munge
sudo chmod 0755 /var/log/munge

sudo mkdir -p /var/run/munge
sudo chown -R munge: /var/run/munge
sudo chmod 0755 /var/run/munge

sudo chown munge: /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key
sudo chown munge:munge /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key


sudo /usr/sbin/create-munge-key -f
sudo chown munge:munge /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key



sudo chown slurm: /etc/slurm-llnl/slurm.conf
sudo chmod 644 /etc/slurm-llnl/slurm.conf
sudo chown munge:munge /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key


```

 Permission denied error
```bash
sudo bash -c 'dd if=/dev/urandom bs=1 count=1024 > /etc/munge/munge.key'
sudo chown -R munge: /etc/munge
sudo chmod 0700 /etc/munge
sudo chmod 0400 /etc/munge/munge.key

sudo systemctl start munge
sudo systemctl enable munge
sudo systemctl status munge


```




## Install SLURM

```bash
sudo apt install -y slurm-wlm
```

### Configure SLURM

```bash
dpkg -l | grep munge
```



Add the all nodes name in `/etc/hosts` file.

```bash

127.0.0.1	localhost
192.168.56.10	sl1
127.0.1.1	ubuntu-jammy	ubuntu-jammy
127.0.0.1	Node1
127.0.0.1	Node2
127.0.0.1	Node3
127.0.0.1	Node4

```

### SLURM Configuration
`/etc/slurm/slurm.conf`


```bash
ClusterName=cluster
ControlMachine=sl1 
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

# Controller node is not used for jobs
# NodeName=sl1 CPUs=10 State=UNKNOWN

# Simulated nodes with large resources
# PartitionName=debug Nodes=ALL Default=YES MaxTime=INFINITE State=UP
# Define the Control Node
NodeName=sl1 CPUs=10 RealMemory=8192 State=UNKNOWN

# Define the Worker Nodes
NodeName=Node[1-4] CPUs=16 RealMemory=10480 State=UNKNOWN

# Define the Partition
PartitionName=debug Nodes=sl1,Node[1-4] Default=YES MaxTime=INFINITE State=UP
```

```bash
sudo systemctl start slurmctld
sudo systemctl enable slurmctld
sudo systemctl start slurmd
sudo systemctl enable slurmd
```

```bash
sudo systemctl status slurmctld
sudo systemctl status slurmd
```

Verfiy the SLURM installation Configuration

```bash
ps aux | grep slurm
```

Set the SLURM user on all nodes
```bash
id slurm

sudo useradd -m -s /bin/bash -u <UID> -g <GID> slurm
```

SLURM commands

```bash
sinfo
squeue
sinfo -N
sinfo -l
sinfo -p debug
sinfo -N -l
sinfo -N -l -o "%N %c %m %d %f %G %z"
sinfo -N -l -o "%N %c %m %d %f %G %z" | grep Node
sinfo -N -l -o "%N %c %m %d %f %G %z" | grep Node | awk '{print $1}'
sinfo -N -l -o "%N %c %m %d %f %G %z" | grep Node | awk '{print $2}'
squeue -u slurm --start -l -o "%A %j %u %T %M %D %C %R %S"
squeue -u slurm --start -l -o "%A %j %u %T %M %D %C %R %S" | grep PENDING
squeue -u slurm --start -l -o "%A %j %u %T %M %D %C %R %S" | grep RUNNING
squeue -u slurm --start -l -o "%A %j %u %T %M %D %C %R %S" | grep COMPLETED


srun --nodes=1 --ntasks=1 --partition=debug --time=00:01:00 --wait=0 --pty /bin/bash
scancel <job_id>
scancel -u <username>
scancel --state=PENDING
scancel --state=RUNNING
scancel --state=COMPLETED


scontrol reconfigure
scontrol update NodeName=Node[1-10] State=IDLE


scontrol show job <job_id>
scontrol show partition
scontrol show nodes
scontrol show config
scontrol show state
scontrol show licenses
scontrol show topology
scontrol show switches
scontrol show network
scontrol show job <job_id>
scontrol show job <job_id> | grep NodeList
scontrol show job <job_id> | grep JobState
```


### SLURM LOGS
    
```bash
sudo mkdir -p /var/log/
sudo touch /var/log/slurmctld.log
sudo chown slurm: /var/log/slurmctld.log
sudo tail -f /var/log/slurmctld.log
```

 ### Check Slurm Logs for Errors
 ```bash
sudo tail -f /var/log/slurmctld.log
sudo tail -f /var/log/slurmd.log
```

### Database Daemon (slurmdbd)
```bash
sudo apt-get install slurmdbd
sudo systemctl start slurmdbd
sudo systemctl enable slurmdbd
sudo systemctl status slurmdbd
```

#### Manual Node Creation

sudo scontrol create NodeName=Node1 CPUs=1 RealMemory=1048 State=IDLE



## SACCT

```bash
sudo apt update
sudo apt install mysql-server
```

`slurmdbd.conf`
`/etc/slurm-llnl/slurmdbd.conf`



```bash
sudo systemctl start mysql
sudo systemctl enable mysql
```
database name: `slurm_acct_db`

```bash
sudo mysql -u root -p
```

#### Initialize SLURM Database Schema: 
If this is the first time you’re setting up SLURM accounting, you need to initialize the database schema. SLURM provides a script, slurmdbd.sql, that can be used to create the necessary tables.
your_db_password: 123456

```bash
CREATE DATABASE slurm_acct_db;
CREATE USER 'slurm'@'localhost' IDENTIFIED BY '<your_db_password>';
GRANT ALL PRIVILEGES ON slurm_acct_db.* TO 'slurm'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```
Then, load the schema into the database:
    
```bash
mysql -u <your_user> -p slurm_acct_db < /usr/share/doc/slurmdbd/slurmdbd.sql
```


`/etc/slurm/slurm.conf`


`/etc/slurm/slurmdbd.conf`

```bash
DbdHost=localhost
DbdPort=6819
StorageHost=localhost
StorageType=accounting_storage/mysql
StorageUser=slurm
StoragePass=<your_db_password>
```



```bash
ALTER USER 'slurm'@'localhost' IDENTIFIED BY 'new_password';
FLUSH PRIVILEGES;
EXIT;
```

```bash
sudo nano /etc/slurm/slurmdbd.conf
```




```bash
sudo systemctl enable slurmdbd

sudo systemctl start slurmdbd

sudo systemctl status slurmdbd
sudo systemctl restart slurmdbd
sudo systemctl restart slurmctld

```
    
```bash
sudo tail -f /var/log/slurmdbd.log
sudo tail -f /var/log/slurmctld.log
sudo tail -f /var/log/slurm/slurmctld.log


```

```bash
sacct --starttime=2023-09-01 --endtime=2023-09-25
sacct --state=COMPLETED

sacct -o JobID,JobName,Partition,Account,AllocCPUS,State,ExitCode,Submit,Start,End,Elapsed,MaxRSS
sacct -o JobID,JobName,Partition,Account,AllocCPUS,State,ExitCode,Submit,Start,End,Elapsed,MaxRSS,NodeList

sacct -o JobID,JobName,Partition,Account,AllocCPUS,State,ExitCode,Submit,Start,End,Elapsed,MaxRSS,NodeList

sacct -o JobID,JobName,Partition,Account,AllocCPUS,State,ExitCode,Submit,Start,End,Elapsed,MaxRSS,NodeList,AllocNodes,CPUTime,ReqNodes
sacct --format=JobID,JobName,Partition,State,AllocCPUS,Start,End,Elapsed,ExitCode
sacct --format=JobID,JobName,Partition,State,AllocCPUS,MaxRSS,MaxVMSize,Elapsed,ExitCode



```


#### USER: slurm

```bash
ps aux | grep slurmctld
ps aux | grep slurmdbd
ps aux | grep slurmd
```

```bash
sudo apt-get update
sudo apt-get install munge libmunge-dev
```

sudo /usr/sbin/create-munge-key
sudo chown munge: /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key


sudo systemctl start munged
sudo systemctl enable munged
sudo systemctl status munged


sudo systemctl restart slurmdbd
sudo systemctl restart slurmctld
sudo systemctl restart slurmd



sudo systemctl daemon-reload
sudo systemctl restart slurmd





sudo systemctl daemon-reload
sudo systemctl restart slurmd



slurmd is Running as slurm
ps aux | grep slurm





#### For chechking the status of the slurm services

```bash
sudo systemctl status slurmctld
sudo systemctl status slurmdbd
sudo systemctl status slurmd

```

```bash
sudo systemctl restart slurmctld
sudo systemctl restart slurmdbd
sudo systemctl restart slurmd

```

## Job Submission

```bash
echo "hostname" | sbatch
```



```bash
sudo systemctl restart munged
sudo systemctl restart slurmdbd
sudo systemctl restart slurmctld
sudo systemctl restart slurmd
```






