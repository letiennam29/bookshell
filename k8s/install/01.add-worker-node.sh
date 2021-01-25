#!/usr/bin/env bash
set -e  # stop immediately if any error happens
SCRIPT_HOME=$(cd `dirname $BASH_SOURCE` && pwd)
MASTER_NODE_IP=$1
if [[ -z "$MASTER_NODE_IP" ]]; then
    echo "ERROR: Please input the master node IP as the first argument."
    exit 1
fi

$SCRIPT_HOME/install-components.sh
echo "$MASTER_NODE_IP k8smaster" | sudo tee -a /etc/hosts
echo; echo "--> Nex step: Run 'kubeadm join ...' that shows on master node."
