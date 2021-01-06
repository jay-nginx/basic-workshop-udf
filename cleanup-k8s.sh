## USE 
## curl -s https://raw.githubusercontent.com/jay-nginx/basic-workshop-udf/main/cleanup-k8s.sh | bash 
kubeadm reset
iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
rm -rf ~/.kube/
