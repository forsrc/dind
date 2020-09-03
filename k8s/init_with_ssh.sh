ssh -o "StrictHostKeyChecking=no" -i ~/.ssh/id_rsa root@k8s-node1 echo ssh ok
ssh -o "StrictHostKeyChecking=no" -i ~/.ssh/id_rsa root@k8s-node2 echo ssh ok

sleep 2

exec_all() {
    echo $1 | sh
    echo $1 | ssh -i ~/.ssh/id_rsa root@k8s-node1 sh
    echo $1 | ssh -i ~/.ssh/id_rsa root@k8s-node2 sh
     
}

exec_node() {
    echo $1 | ssh -i ~/.ssh/id_rsa root@k8s-node1 sh
    echo $1 | ssh -i ~/.ssh/id_rsa root@k8s-node2 sh
}


exec_all "sed -i -e 's@^ExecStart=/usr/bin/kubelet.*@ExecStart=/usr/bin/kubelet \$KUBELET_KUBECONFIG_ARGS \$KUBELET_CONFIG_ARGS \$KUBELET_KUBEADM_ARGS \$KUBELET_EXTRA_ARGS --fail-swap-on=false@g' /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf"
exec_all "systemctl daemon-reload && systemctl restart kubelet"

exec_all "echo 127.0.0.1  localhost  >  /etc/hosts"
exec_all "echo 172.7.0.10 k8s-master >> /etc/hosts"
exec_all "echo 172.7.0.11 k8s-node1  >> /etc/hosts"
exec_all "echo 172.7.0.12 k8s-node2  >> /etc/hosts"


kubeadm init --kubernetes-version=`kubeadm version -o short` --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=172.7.0.10 --ignore-preflight-errors=all
mkdir -p /root/.kube
cp -f /etc/kubernetes/admin.conf /root/.kube/config
chown 0:0 /root/.kube/config


exec_node "`kubeadm token create --print-join-command` --ignore-preflight-errors=all"

sleep 10
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

echo 'source /usr/share/bash-completion/bash_completion' >>~/.bashrc
echo 'source <(kubectl completion bash)'                 >>~/.bashrc

source ~/.bashrc
kubectl get nodes
kubectl get pod --all-namespaces -o wide



