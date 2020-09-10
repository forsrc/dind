
yum install -y corosync pacemaker pcs
ssh k8s-node1  "yum install -y corosync pacemaker pcs"
ssh k8s-node2  "yum install -y corosync pacemaker pcs"

echo "hacluster:hacluster" | chpasswd
ssh k8s-node1  "echo 'hacluster:hacluster' | chpasswd"
ssh k8s-node2  "echo 'hacluster:hacluster' | chpasswd"

cat /etc/corosync/corosync.conf.example > /etc/corosync/corosync.conf
ssh k8s-node1 "cat /etc/corosync/corosync.conf.example > /etc/corosync/corosync.conf"
ssh k8s-node2 "cat /etc/corosync/corosync.conf.example > /etc/corosync/corosync.conf"

HA_CMD="systemctl enable pacemaker && systemctl enable pcsd && systemctl enable corosync && systemctl start pcsd && systemctl start corosync"
sh -c         "$HA_CMD"
ssh k8s-node1 "$HA_CMD"
ssh k8s-node2 "$HA_CMD"

pcs cluster auth -u hacluster -p hacluster k8s-master k8s-node1 k8s-node2
pcs cluster setup --name k8s-hacluster k8s-master k8s-node1 k8s-node2 --force
pcs cluster start  --all
pcs cluster enable --all

pcs status cluster
pcs status corosync
