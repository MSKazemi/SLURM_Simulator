#!/bin/bash

# Source the configuration file
source config.sh

# Define the output file
slurmdbd_conf="slurmdbd.conf"

# Create the slurm.conf content
cat <<EOL > $slurmdbd_conf
DbdHost=localhost
DbdPort=6819
AuthType=auth/munge
StorageType=accounting_storage/mysql
StorageHost=localhost
StoragePort=3306                  # Change if using a non-default MySQL port
StorageUser=slurm                 # User to access the database
StoragePass=$STORAGE_PASS    # Set your database password
StorageLoc=slurm_acct_db
SlurmUser=slurm
EOL

# Print the generated slurm.conf file for verification
cat $slurmdbd_conf
