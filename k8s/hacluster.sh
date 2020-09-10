
yum install -y pacemaker pcs
ssh k8s-node1  "yum install -y pacemaker pcs"
ssh k8s-node2  "yum install -y pacemaker pcs"

echo "hacluster:hacluster" | chpasswd
ssh k8s-node1  "echo 'hacluster:hacluster' | chpasswd"
ssh k8s-node2  "echo 'hacluster:hacluster' | chpasswd"

cat /etc/corosync/corosync.conf.example > /etc/corosync/corosync.conf
ssh k8s-node1 "cat /etc/corosync/corosync.conf.example > /etc/corosync/corosync.conf"
ssh k8s-node2 "cat /etc/corosync/corosync.conf.example > /etc/corosync/corosync.conf"

systemctl enable pcsd && systemctl enable corosync && systemctl start pcsd && systemctl start corosync
ssh k8s-node1 "systemctl enable pcsd && systemctl enable corosync && systemctl start pcsd && systemctl start corosync"
ssh k8s-node2 "systemctl enable pcsd && systemctl enable corosync && systemctl start pcsd && systemctl start corosync"

pcs cluster auth -u hacluster -p hacluster k8s-master k8s-node1 k8s-node2
pcs cluster setup --name cluster  k8s-node1 k8s-node2 --force
pcs cluster start --all
