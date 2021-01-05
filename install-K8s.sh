## Execute using 
## curl -s https://raw.githubusercontent.com/jay-nginx/basic-workshop-udf/main/install-K8s.sh | bash
## Author: Giriraj Rajawat
## Created for Ubuntu 18.04 - Might not work on other flavours of Linux

#!/bin/bash
echo "Kubernetes vanilla installation begins using KubeADM"
export DEBIAN_FRONTEND=noninteractive
apt-get clean
rm /var/lib/dpkg/lock    
rm /var/cache/apt/archives/lock
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
sleep 1
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system
sleep 2
apt-get update -y 
sleep 1
apt-get install -y apt-transport-https curl docker.io
sleep 1
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
sleep 1 
systemctl daemon-reload
systemctl restart docker
systemctl enable docker
sleep 1 
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
sleep 1 
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sleep 1 
apt-get update
echo "KUBERNETES DEFAULT PACKAGE INSTALLATION BEGINS"
apt-get install -y kubelet kubeadm kubectl
swapoff -a
kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-bind-port=6443 > /kub.txt
mkdir -p $HOME/.kube && cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml
sleep 1
echo "COMPLETED"
#### FINISH 
