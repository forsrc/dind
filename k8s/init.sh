#echo 262144 > /sys/module/nf_conntrack/parameters/hashsize

#docker rm -f k8s-master k8s-node1 k8s-node2
#docker network rm net-dind-k8s

#echo -e '{\n\t "dns": ["8.8.8.8"]\n}' > /etc/docker/daemon.json && systemctl daemon-reload && systemctl restart docker

mkdir -p /dind-k8s/temp/
mkdir -p /dind-k8s/master/var/lib/docker
mkdir -p /dind-k8s/master/var/lib/kubelet
mkdir -p /dind-k8s/master/etc/docker
mkdir -p /dind-k8s/master/etc/kubernetes
mkdir -p /dind-k8s/node1/var/lib/docker
mkdir -p /dind-k8s/node1/var/lib/kubelet
mkdir -p /dind-k8s/node1/etc/docker
mkdir -p /dind-k8s/node1/etc/kubernetes
mkdir -p /dind-k8s/node2/var/lib/docker
mkdir -p /dind-k8s/node2/var/lib/kubelet
mkdir -p /dind-k8s/node2/etc/docker
mkdir -p /dind-k8s/node2/etc/kubernetes

#rm -rf /dind-k8s/master/etc/kubernetes/*
#rm -rf /dind-k8s/node1/etc/kubernetes/*
#rm -rf /dind-k8s/node2/etc/kubernetes/*

#rm -rf /dind-k8s/master/var/lib/kubelet/*
#rm -rf /dind-k8s/node1/var/lib/kubelet/*
#rm -rf /dind-k8s/node2/var/lib/kubelet/*

mkdir -p /dind-k8s/etc/
echo 'nameserver 8.8.8.8' > /dind-k8s/etc/resolv.conf


docker network create --subnet=172.7.0.0/24 --gateway=172.7.0.1 net-dind-k8s

docker run -d -it --privileged=true -d -it \
    --network net-dind-k8s \
    --ip 172.7.0.10 \
    -v /dind-k8s/temp:/temp/ \
    -v /dind-k8s/etc/resolv.conf:/etc/resolv.conf \
    -v /dind-k8s/master/var/lib/docker/:/var/lib/docker/ \
    -v /dind-k8s/master/var/lib/kubelet/:/var/lib/kubelet/ \
    -v /dind-k8s/master/etc/docker/:/etc/docker/ \
    -v /dind-k8s/master/etc/kubernetes/:/etc/kubernetes/ \
    -v /dind-k8s/master/run/flannel/:/run/flannel/ \
    --hostname k8s-master \
    --name k8s-master \
    forsrc/dind:k8s /usr/sbin/init

docker run -d -it --privileged=true -d -it \
    --network net-dind-k8s \
    --ip 172.7.0.11 \
    -v /dind-k8s/temp:/temp/ \
    -v /dind-k8s/etc/resolv.conf:/etc/resolv.conf \
    -v /dind-k8s/node1/var/lib/docker/:/var/lib/docker/ \
    -v /dind-k8s/node1/var/lib/kubelet/:/var/lib/kubelet/ \
    -v /dind-k8s/node1/etc/docker/:/etc/docker/ \
    -v /dind-k8s/node1/etc/kubernetes/:/etc/kubernetes/ \
    -v /dind-k8s/node1/run/flannel/:/run/flannel/ \
    --hostname k8s-node1 \
    --name k8s-node1 \
    forsrc/dind:k8s /usr/sbin/init
  
docker run -d -it --privileged=true -d -it \
    --network net-dind-k8s \
    --ip 172.7.0.12 \
    -v /dind-k8s/temp:/temp/ \
    -v /dind-k8s/etc/resolv.conf:/etc/resolv.conf \
    -v /dind-k8s/node2/var/lib/docker/:/var/lib/docker/ \
    -v /dind-k8s/node2/var/lib/kubelet/:/var/lib/kubelet/ \
    -v /dind-k8s/node2/etc/docker/:/etc/docker/ \
    -v /dind-k8s/node2/etc/kubernetes/:/etc/kubernetes/ \
    -v /dind-k8s/node2/run/flannel/:/run/flannel/ \
    --hostname k8s-node2 \
    --name k8s-node2 \
    forsrc/dind:k8s /usr/sbin/init

#docker exec k8s-master sh -c "echo -e '{\n\t \"dns\": [\"8.8.8.8\"]\n}' > /etc/docker/daemon.json && systemctl daemon-reload && systemctl restart docker"
#docker exec k8s-node1  sh -c "echo -e '{\n\t \"dns\": [\"8.8.8.8\"]\n}' > /etc/docker/daemon.json && systemctl daemon-reload && systemctl restart docker"
#docker exec k8s-node2  sh -c "echo -e '{\n\t \"dns\": [\"8.8.8.8\"]\n}' > /etc/docker/daemon.json && systemctl daemon-reload && systemctl restart docker"

docker exec k8s-master sh -c "echo 127.0.0.1  localhost  >  /etc/hosts"
docker exec k8s-master sh -c "echo 172.7.0.10 k8s-master >> /etc/hosts"
docker exec k8s-master sh -c "echo 172.7.0.11 k8s-node1  >> /etc/hosts"
docker exec k8s-master sh -c "echo 172.7.0.12 k8s-node2  >> /etc/hosts"

docker exec k8s-node1  sh -c "echo 127.0.0.1  localhost  >  /etc/hosts"
docker exec k8s-node1  sh -c "echo 172.7.0.10 k8s-master >> /etc/hosts"
docker exec k8s-node1  sh -c "echo 172.7.0.11 k8s-node1  >> /etc/hosts"
docker exec k8s-node1  sh -c "echo 172.7.0.12 k8s-node2  >> /etc/hosts"

docker exec k8s-node2  sh -c "echo 127.0.0.1  localhost  >  /etc/hosts"
docker exec k8s-node2  sh -c "echo 172.7.0.10 k8s-master >> /etc/hosts"
docker exec k8s-node2  sh -c "echo 172.7.0.11 k8s-node1  >> /etc/hosts"
docker exec k8s-node2  sh -c "echo 172.7.0.12 k8s-node2  >> /etc/hosts"

#docker exec k8s-master rm -f /etc/cni/net.d/*flannel*
#docker exec k8s-node1  rm -f /etc/cni/net.d/*flannel*
#docker exec k8s-node2  rm -f /etc/cni/net.d/*flannel*

#docker exec k8s-master ip link delete cni0
#docker exec k8s-master ip link delete flannel.1
#docker exec k8s-node1  ip link delete cni0
#docker exec k8s-node1  ip link delete flannel.1
#docker exec k8s-node2  ip link delete cni0
#docker exec k8s-node2  ip link delete flannel.1


SUBNET_ENV_1="mkdir -p /run/flannel/ && echo FLANNEL_NETWORK=10.244.0.0/16 > /run/flannel/subnet.env && echo FLANNEL_SUBNET=10.244.0.1/24 >> /run/flannel/subnet.env && echo FLANNEL_MTU=1450 >> /run/flannel/subnet.env && echo FLANNEL_IPMASQ=true >> /run/flannel/subnet.env"
SUBNET_ENV_2="mkdir -p /run/flannel/ && echo FLANNEL_NETWORK=10.244.0.0/16 > /run/flannel/subnet.env && echo FLANNEL_SUBNET=10.244.0.2/24 >> /run/flannel/subnet.env && echo FLANNEL_MTU=1450 >> /run/flannel/subnet.env && echo FLANNEL_IPMASQ=true >> /run/flannel/subnet.env"
SUBNET_ENV_3="mkdir -p /run/flannel/ && echo FLANNEL_NETWORK=10.244.0.0/16 > /run/flannel/subnet.env && echo FLANNEL_SUBNET=10.244.0.3/24 >> /run/flannel/subnet.env && echo FLANNEL_MTU=1450 >> /run/flannel/subnet.env && echo FLANNEL_IPMASQ=true >> /run/flannel/subnet.env"

#docker exec k8s-master sh -c "$SUBNET_ENV_1"
#docker exec k8s-node1  sh -c "$SUBNET_ENV_2"
#docker exec k8s-node2  sh -c "$SUBNET_ENV_3"

SUBNET_ENV_1="mkdir -p /dind-k8s/master/run/flannel/ && echo FLANNEL_NETWORK=10.244.0.0/16 > /dind-k8s/master/run/flannel/subnet.env && echo FLANNEL_SUBNET=10.244.0.1/24 >> /dind-k8s/master/run/flannel/subnet.env && echo FLANNEL_MTU=1450 >> /dind-k8s/master/run/flannel/subnet.env && echo FLANNEL_IPMASQ=true >> /dind-k8s/master/run/flannel/subnet.env"
SUBNET_ENV_2="mkdir -p /dind-k8s/node2/run/flannel/  && echo FLANNEL_NETWORK=10.244.0.0/16 > /dind-k8s/node1/run/flannel/subnet.env  && echo FLANNEL_SUBNET=10.244.0.2/24 >> /dind-k8s/node1/run/flannel/subnet.env  && echo FLANNEL_MTU=1450 >> /dind-k8s/node1/run/flannel/subnet.env  && echo FLANNEL_IPMASQ=true >> /dind-k8s/node1/run/flannel/subnet.env"
SUBNET_ENV_3="mkdir -p /dind-k8s/node2/run/flannel/  && echo FLANNEL_NETWORK=10.244.0.0/16 > /dind-k8s/node2/run/flannel/subnet.env  && echo FLANNEL_SUBNET=10.244.0.3/24 >> /dind-k8s/node2/run/flannel/subnet.env  && echo FLANNEL_MTU=1450 >> /dind-k8s/node2/run/flannel/subnet.env  && echo FLANNEL_IPMASQ=true >> /dind-k8s/node2/run/flannel/subnet.env"

sh -c "$SUBNET_ENV_1"
sh -c "$SUBNET_ENV_2"
sh -c "$SUBNET_ENV_3"

docker exec k8s-master sh -c "kubeadm init --kubernetes-version=\`kubeadm version -o short\` --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=172.7.0.10 --ignore-preflight-errors=all"
docker exec k8s-master mkdir -p /root/.kube
docker exec k8s-master cp -f /etc/kubernetes/admin.conf /root/.kube/config
docker exec k8s-master chown 0:0 /root/.kube/config

docker exec k8s-node1  sh -c "`docker exec k8s-master kubeadm token create --print-join-command` --ignore-preflight-errors=all"
docker exec k8s-node2  sh -c "`docker exec k8s-master kubeadm token create --print-join-command` --ignore-preflight-errors=all"

sleep 10
docker exec k8s-master kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

#docker exec k8s-master yum install -y bash-completion
docker exec k8s-master sh -c "echo 'source /usr/share/bash-completion/bash_completion' >>~/.bashrc"
docker exec k8s-master sh -c "echo 'source <(kubectl completion bash)'                 >>~/.bashrc"

docker exec k8s-master kubectl get nodes

docker exec k8s-master kubectl get pod --all-namespaces -o wide
