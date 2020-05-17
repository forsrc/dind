echo 262144 > /sys/module/nf_conntrack/parameters/hashsize
  
kubectl delete -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
sleep 3

SUBNET_ENV_1="mkdir -p /run/flannel/ && echo FLANNEL_NETWORK=10.244.0.0/16 > /run/flannel/subnet.env && echo FLANNEL_SUBNET=10.244.0.1/24 >> /run/flannel/subnet.env && echo FLANNEL_MTU=1450 >> /run/flannel/subnet.env && echo FLANNEL_IPMASQ=true >> /run/flannel/subnet.env"
SUBNET_ENV_2="mkdir -p /run/flannel/ && echo FLANNEL_NETWORK=10.244.0.0/16 > /run/flannel/subnet.env && echo FLANNEL_SUBNET=10.244.0.2/24 >> /run/flannel/subnet.env && echo FLANNEL_MTU=1450 >> /run/flannel/subnet.env && echo FLANNEL_IPMASQ=true >> /run/flannel/subnet.env"
SUBNET_ENV_3="mkdir -p /run/flannel/ && echo FLANNEL_NETWORK=10.244.0.0/16 > /run/flannel/subnet.env && echo FLANNEL_SUBNET=10.244.0.3/24 >> /run/flannel/subnet.env && echo FLANNEL_MTU=1450 >> /run/flannel/subnet.env && echo FLANNEL_IPMASQ=true >> /run/flannel/subnet.env"
docker exec k8s-master sh -c "$SUBNET_ENV_1"
docker exec k8s-node1  sh -c "$SUBNET_ENV_2"
docker exec k8s-node2  sh -c "$SUBNET_ENV_3"


kubectl apply  -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
