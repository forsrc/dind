FROM ubuntu:18.10

RUN apt-get update

RUN apt-get install -y apt-transport-https ca-certificates curl software-properties-common lxc iptables

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update
RUN apt-get install -y docker-ce


COPY ./dind /usr/local/bin/
RUN chmod +x /usr/local/bin/dind

COPY ./dockerd-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/dockerd-entrypoint.sh

VOLUME /var/lib/docker

EXPOSE 2375 2376

ENTRYPOINT ["dockerd-entrypoint.sh"]

CMD []
