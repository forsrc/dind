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
    forsrc/dind:k8s-ssh /usr/sbin/init

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
    forsrc/dind:k8s-ssh /usr/sbin/init
  
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
    forsrc/dind:k8s-ssh /usr/sbin/init


docker exec -i k8s-master sh -c "cat >init_with_ssh.sh" < init_with_ssh.sh
docker exec -i k8s-master sh -c "chmod +x /init_with_ssh.sh && /init_with_ssh.sh"
