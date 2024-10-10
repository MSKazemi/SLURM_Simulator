# SLURM Simulator



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

## SLURM Configuration
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


## SACCT
```bash
sudo apt update
sudo apt install mysql-server
```

```bash
sudo systemctl start mysql
sudo systemctl enable mysql
```
```bash
sudo mysql -u root -p
```
your_db_password: 123456
```bash
CREATE DATABASE slurm_acct_db;
CREATE USER 'slurm'@'localhost' IDENTIFIED BY '<your_db_password>';
GRANT ALL PRIVILEGES ON slurm_acct_db.* TO 'slurm'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

`/etc/slurm/slurm.conf`

```bash
AccountingStorageType=accounting_storage/slurmdbd
AccountingStorageHost=localhost
AccountingStoragePort=6819
```



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
