FROM forsrc/dind

RUN yum makecache fast

RUN sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

RUN yum install -y yum-utils device-mapper-persistent-data lvm2 ipvsadm ipset conntrack ntp

RUN echo -e "[kubernetes]\nname=Kubernetes\nbaseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg" >/etc/yum.repos.d/kubernetes.repo

RUN yum install -y kubelet-1.15.3 kubeadm-1.15.3 kubectl-1.15.3 nfs-utils

RUN systemctl enable docker
RUN systemctl enable kubelet

CMD [ "/usr/sbin/init"]
