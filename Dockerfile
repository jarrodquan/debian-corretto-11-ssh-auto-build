FROM jarrodquan/debian-corretto-11:latest

ARG ROOT_PASSWORD=123456

LABEL MAINTAINER="Jarrod Quan <jarrodquan@gmail.com>"

#安装OpenSSH
RUN apt-get install --no-install-recommends -y openssh-server \
  && mkdir /var/run/sshd \
  && echo "root:${ROOT_PASSWORD}" | chpasswd \
  && sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/" /etc/ssh/sshd_config \
  && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

#配置docker-entrypoint.sh
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT [ "docker-entrypoint.sh" ]

EXPOSE 22