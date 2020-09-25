curl -sSL https://get.docker.com/ | sh

echo 262144 > /sys/module/nf_conntrack/parameters/hashsize

sudo swapoff -a

wget https://raw.githubusercontent.com/forsrc/dind/master/k8s/init.sh

sudo chmod +x ./init.sh

./init.sh
