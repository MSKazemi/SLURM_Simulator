# SLURM Simulator
[TOC]

## MUNGE

MUNGE (MUNGE Uid 'N' Gid Emporium) is an authentication service used by SLURM for secure communication between nodes.

```bash
sudo apt update
sudo apt install -y munge libmunge-dev libmunge2
```

### Configure MUNGE

#### Create MUNGE Key

```bash
sudo /usr/sbin/create-munge-key
sudo /usr/sbin/create-munge-key -f

sudo chown munge: /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key
```

##### Manually Create the MUNGE Key

```bash
sudo dd if=/dev/urandom bs=1 count=1024 > /etc/munge/munge.key
sudo chown -R munge: /etc/munge
sudo chmod 0700 /etc/munge
sudo chown munge: /etc/munge/munge.key
sudo chown munge:munge /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key
```

##### Permission denied error

```bash
sudo bash -c 'dd if=/dev/urandom bs=1 count=1024 > /etc/munge/munge.key'
sudo chown -R munge: /etc/munge
sudo chmod 0700 /etc/munge
sudo chmod 0400 /etc/munge/munge.key
```

#### Start MUNGE

```bash
sudo systemctl start munge
sudo systemctl enable munge
sudo systemctl status munge
```

#### Logs MUNGE

```bash
sudo mkdir -p /var/log/munge
sudo chown -R munge: /var/log/munge
sudo chmod 0755 /var/log/munge

sudo mkdir -p /var/run/munge
sudo chown -R munge: /var/run/munge
sudo chmod 0755 /var/run/munge
```

```bash
dpkg -l | grep munge
```

## Install SLURM

```bash
sudo apt install -y slurm-wlm
```

### Configure SLURM

#### Create SLURM User

```bash
```

#### Add the all nodes name in `/etc/hosts` file.

```bash
127.0.0.1	localhost
192.168.56.10	sl1
127.0.0.1	Node1
127.0.0.1	Node2
127.0.0.1	Node3
127.0.0.1	Node4

```

### SLURM Configuration

`/etc/slurm-llnl/slurm.conf`
`/etc/slurm/slurm.conf`

```bash
sudo chown slurm: /etc/slurm-llnl/slurm.conf
sudo chmod 644 /etc/slurm-llnl/slurm.conf
```

```bash
sudo systemctl start slurmctld
sudo systemctl enable slurmctld
sudo systemctl start slurmd
sudo systemctl enable slurmd
sudo systemctl status slurmctld
sudo systemctl status slurmd
```

Verfiy the SLURM installation Configuration

```bash
ps aux | grep slurm
```

##### Set the SLURM user on all nodes.

```bash
id slurm
sudo useradd -m -s /bin/bash -u <UID> -g <GID> slurm
```

#### SLURM commands

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

### Slurm Logs

```bash
sudo mkdir -p /var/log/
sudo touch /var/log/slurmctld.log
sudo chown slurm: /var/log/slurmctld.log
```

```bash
sudo tail -f /var/log/slurmctld.log
sudo tail -f /var/log/slurmd.log
```

## Manual Node Creation

```bash
sudo scontrol create NodeName=Node1 CPUs=1 RealMemory=1048 State=IDLE
```

## Database Daemon (slurmdbd)

```bash
sudo apt-get install slurmdbd

sudo systemctl start slurmdbd
sudo systemctl enable slurmdbd
sudo systemctl status slurmdbd
```




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

Database name: `slurm_acct_db`

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
sudo systemctl start slurmdbd
sudo systemctl enable slurmdbd
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

slurmd is Running as slurm

```bash
ps aux | grep slurmctld
ps aux | grep slurmdbd
ps aux | grep slurmd
```

#### For chechking the status of the slurm services

```bash
sudo systemctl status slurmctld
sudo systemctl status slurmdbd
sudo systemctl status slurmd

sudo systemctl restart slurmctld
sudo systemctl restart slurmdbd
sudo systemctl restart slurmd

sudo systemctl restart munged
sudo systemctl restart slurmdbd
sudo systemctl restart slurmctld
sudo systemctl restart slurmd

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
```

## Job Submission

```bash
echo "hostname" | sbatch
```