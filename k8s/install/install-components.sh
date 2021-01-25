#!/usr/bin/env bash
set -e  # halt if any error occurs
echo "--> STEP 01. check requirements ubuntu 20.04"
#///check requirements - ubuntu 20.04
sudo apt update
sudo apt upgrade -y
swapon --show
sudo sed "-i.bak" '/swap.img/d' /etc/fstab
sudo swapoff -a
echo "--> STEP 02. install Docker"
#///install docker
sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -sc) stable" | sudo tee  /etc/apt/sources.list.d/docker-ce.list
sudo apt update
sudo apt-get install -y  --allow-downgrades \
  containerd.io=1.2.13-2 \
  docker-ce=5:19.03.14~3-0~ubuntu-$(lsb_release -cs) \
  docker-ce-cli=5:19.03.14~3-0~ubuntu-$(lsb_release -cs)
sudo systemctl enable --now docker containerd
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo usermod -aG docker $USER
docker --version
echo "--> STEP 03. install Kubernetes components"
#///install k8s
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kurbenetes.list
sudo apt update
sudo apt install kubelet kubeadm kubectl -y
sudo systemctl daemon-reload
#sudo systemctl restart kubectl
#sudo systemctl enable kubectl
echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
