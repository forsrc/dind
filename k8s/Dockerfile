FROM forsrc/dind

RUN yum makecache fast

RUN sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config

RUN yum install -y yum-utils device-mapper-persistent-data lvm2 ipvsadm ipset conntrack ntp

RUN echo -e "[kubernetes]\nname=Kubernetes\nbaseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg" >/etc/yum.repos.d/kubernetes.repo

RUN yum install -y kubelet kubeadm kubectl nfs-utils bash-completion
RUN kubectl version --short --client

RUN rm -rf /var/cache/yum/* && yum clean all

RUN systemctl enable docker
RUN systemctl enable kubelet

VOLUME /var/lib/docker/
VOLUME /var/lib/kubelet/
VOLUME /var/lib/etcd/
VOLUME /etc/kubernetes/

CMD [ "/usr/sbin/init"]
