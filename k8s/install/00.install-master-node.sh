#!/usr/bin/env bash
set -e  # stop immediately if any error happens
SCRIPT_HOME=$(cd `dirname $BASH_SOURCE` && pwd)
POD_IP_MASTER="192.168.1.130"
POD_IP_RANGE="172.16.0.0/16"  # This IP Range is the default value of Flannel

$SCRIPT_HOME/install-components.sh

sudo kubeadm init --apiserver-advertise-address=$POD_IP_MASTER --pod-network-cidr=$POD_IP_RANGE
# Admin config for Master node
if [ -d "$HOME/.kube" ]; then
  sudo rm -r $HOME/.kube
fi
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

sudo apt-get install -y bash-completion
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl get pods -A

echo ;echo "--> Complete installation of master node"
echo "--> Run command bellow after run '01.add-worker-node.sh' on worker node"
sudo kubeadm token create --print-join-command