mkdir -p /dind-k8s/temp/
mkdir -p /dind-k8s/var/lib/docker
mkdir -p /dind-k8s/var/lib/kubelet
mkdir -p /dind-k8s/etc/docker
mkdir -p /dind-k8s/etc/kubernetes
#mkdir -p /dind-k8s/var/lib/cni


docker network create --subnet=172.10.0.0/24 --gateway=172.10.0.1 net-k8s-1.16.3


docker run -d -it --privileged=true -d -it \
    --network net-k8s-1.16.3 \
    --ip 172.7.0.10 \
    -v /dind-k8s/temp:/temp/ \
    -v /dind-k8s/var/lib/docker/:/var/lib/docker/ \
    -v /dind-k8s/var/lib/kubelet/:/var/lib/kubelet/ \
    -v /dind-k8s/etc/docker/:/etc/docker/ \
    -v /dind-k8s/etc/kubernetes/:/etc/kubernetes/ \
    -v /dind-k8s/dind-k8s:/dind-k8s/ \
    --hostname dind-k8s \
    --name dind-k8s \
    forsrc/dind:k8s /usr/sbin/init
