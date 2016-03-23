FROM centos:7
MAINTAINER Chao Wang <739904116@qq.com>

RUN mv /etc/localtime /etc/localtime.bak
RUN ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# NTP
RUN yum -y install ntp

# EPEL
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# Supervisord
RUN yum install python-setuptools -y
RUN easy_install supervisor
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisord.conf

# sshd
RUN yum install -y openssh-server openssh-clients passwd

RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN sed -ri 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config && echo 'root:changeme' | chpasswd

# crontab 
RUN yum install -y cronie
RUN yum install -y crontabs 

COPY cron_ppp /etc/ppp/cron_ppp
RUN chmod +x  /etc/ppp/cron_ppp
COPY update_route /etc/ppp/update_route
RUN chmod +x  /etc/ppp/update_route

RUN echo "*/60 * * * * cd /etc/ppp && /bin/sh cron_ppp"  >> /var/spool/cron/root 
RUN echo "*/1 * * * * cd /etc/ppp && /bin/sh update_route" >> /var/spool/cron/root 
RUN sed -ri 's/session    required/session    sufficient/g' /etc/pam.d/crond

# Squid
RUN yum -y install squid 
COPY squid.conf /etc/squid/squid.conf

# iptables
RUN yum -y install iptables-services
COPY iptables /etc/sysconfig/iptables

# wvdial 
RUN yum -y install wvdial
COPY wvdial.conf /etc/wvdial.conf
RUN yum -y install ppp ppp-devel 
RUN mkdir /var/run/lock

# route ifconfig 
RUN yum -y install net-tools 

EXPOSE 22 80

COPY start.sh /usr/bin/start.sh
RUN chmod +x  /usr/bin/start.sh
ENTRYPOINT ["/usr/bin/start.sh"]
