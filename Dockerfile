FROM ubuntu:18.10

RUN apt-get update

RUN apt-get install -y apt-transport-https ca-certificates curl software-properties-common lxc dmsetup

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update
RUN apt-get install -y --no-install-recommends docker-ce


ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

VOLUME /var/lib/docker

EXPOSE 2375 2376

CMD ["wrapdocker"]
