#!/bin/bash

# Source the configuration file
source config.sh

# Specify the output file
hosts_file="hosts"

# Start the hosts file with the localhost entry
echo "127.0.0.1    localhost" > $hosts_file

# Add the control node entry
echo "$CONTROL_NODE_IP    $CONTROL_NODE" >> $hosts_file

# Add each worker node entry
for worker in "${WORKER_NODES[@]}"; do
  echo "$WORKER_NODE_IP    $worker" >> $hosts_file
done

# Print the generated hosts file for verification
cat $hosts_file



# 127.0.0.1       localhost
# 192.168.56.10    sl1
# 127.0.0.1	Node1
# 127.0.0.1	Node2
# 127.0.0.1	Node3
# 127.0.0.1	Node4