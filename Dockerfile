FROM centos:centos7
MAINTAINER Emiliano Diaz 

# - Install basic packages + dotnet + ngnix + supervisor
ENV ROOT_PASS=password

RUN \
  yum update -y && \
  yum install -y epel-release && \
  yum install -y iproute python-setuptools hostname inotify-tools yum-utils which jq && \
  yum install --nogpgcheck -y openssh-server openssh-clients pwgen sudo hostname wget patch htop iftop vim mc links && \
  yum install -y libunwind libicu mlocate moreutils net-tools nginx && \
  yum clean all && \
  curl -sSL -o dotnet.tar.gz https://go.microsoft.com/fwlink/?linkid=843449 && \

  easy_install supervisor &&\

  ssh-keygen -q -b 1024 -N '' -t rsa -f /etc/ssh/ssh_host_rsa_key && \
  ssh-keygen -q -b 1024 -N '' -t dsa -f /etc/ssh/ssh_host_dsa_key && \
  ssh-keygen -q -b 521 -N '' -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key && \

  sed -i -r 's/.?UseDNS\syes/UseDNS no/' /etc/ssh/sshd_config && \
  sed -i -r 's/.?ChallengeResponseAuthentication.+/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config && \
  sed -i -r 's/.?PermitRootLogin.+/PermitRootLogin yes/' /etc/ssh/sshd_config && \

  mkdir -p /opt/dotnet && sudo tar zxf dotnet.tar.gz -C /opt/dotnet && \
  ln -s /opt/dotnet/dotnet /usr/local/bin && \
  rm dotnet.tar.gz

# Add supervisord conf, bootstrap.sh files
ADD container-files /

COPY container-files /

VOLUME ["/data"]

ENTRYPOINT ["/config/bootstrap.sh"]

EXPOSE 22 80
