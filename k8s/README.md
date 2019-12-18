```
mkdir -p /dind-k8s/temp/
mkdir -p /dind-k8s/var/lib/docker
mkdir -p /dind-k8s/var/lib/kubelet
mkdir -p /dind-k8s/etc/docker
mkdir -p /dind-k8s/etc/kubernetes
mkdir -p /dind-k8s/dind-k8s/etc

echo 'nameserver 8.8.8.8' > /dind-k8s/dind-k8s/etc/resolv.conf

docker network create --subnet=172.10.0.0/24 --gateway=172.10.0.1 net-k8s


docker run -d -it --privileged=true -d -it \
    --network net-k8s \
    --ip 172.10.0.100 \
    -v /dind-k8s/temp:/temp/ \
    -v /dind-k8s/var/lib/docker/:/var/lib/docker/ \
    -v /dind-k8s/var/lib/kubelet/:/var/lib/kubelet/ \
    -v /dind-k8s/etc/docker/:/etc/docker/ \
    -v /dind-k8s/etc/kubernetes/:/etc/kubernetes/ \
    -v /dind-k8s/dind-k8s:/dind-k8s/ \
    --hostname dind-k8s \
    --name dind-k8s \
    forsrc/dind:k8s /usr/sbin/init

# in docker
docker network create --subnet=172.7.0.0/24 --gateway=172.7.0.1 net-dind-k8s

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


docker run -d -it --privileged=true -d -it \
    --network net-dind-k8s \
    --ip 172.7.0.10 \
    -v /temp:/temp/ \
    -v /dind-k8s/etc/resolv.conf:/etc/resolv.conf \
    -v /dind-k8s/master/var/lib/docker/:/var/lib/docker/ \
    -v /dind-k8s/master/var/lib/kubelet/:/var/lib/kubelet/ \
    -v /dind-k8s/master/etc/docker/:/etc/docker/ \
    -v /dind-k8s/master/etc/kubernetes/:/etc/kubernetes/ \
    -v /dind-k8s/master/dind-k8s:/dind-k8s/ \
    -p 30080:30080 -p 30443:30443 -p 8080:8080 \
    -p 30000:30000 -p 30001:30001 -p 30002:30002 -p 30003:30003 -p 30004:30004 -p 30005:30005 \
    --hostname master \
    --name master \
    forsrc/dind:k8s /usr/sbin/init

docker run -d -it --privileged=true -d -it \
    --network net-dind-k8s \
    --ip 172.7.0.11 \
    -v /temp:/temp/ \
    -v /dind-k8s/etc/resolv.conf:/etc/resolv.conf \
    -v /dind-k8s/node1/var/lib/docker/:/var/lib/docker/ \
    -v /dind-k8s/node1/var/lib/kubelet/:/var/lib/kubelet/ \
    -v /dind-k8s/node1/etc/docker/:/etc/docker/ \
    -v /dind-k8s/node1/etc/kubernetes/:/etc/kubernetes/ \
    -v /dind-k8s/node1/dind-k8s:/dind-k8s/ \
    --hostname node1 \
    --name node1 \
    forsrc/dind:k8s /usr/sbin/init
  
docker run -d -it --privileged=true -d -it \
    --network net-dind-k8s \
    --ip 172.7.0.12 \
    -v /temp:/temp/ \
    -v /dind-k8s/etc/resolv.conf:/etc/resolv.conf \
    -v /dind-k8s/node2/var/lib/docker/:/var/lib/docker/ \
    -v /dind-k8s/node2/var/lib/kubelet/:/var/lib/kubelet/ \
    -v /dind-k8s/node2/etc/docker/:/etc/docker/ \
    -v /dind-k8s/node2/etc/kubernetes/:/etc/kubernetes/ \
    -v /dind-k8s/node2/dind-k8s:/dind-k8s/ \
    --hostname node2 \
    --name node2 \
    forsrc/dind:k8s /usr/sbin/init
```