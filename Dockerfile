FROM openjdk:latest

MAINTAINER Yiqiu Jia <yiqiujia@hotmail.com>

RUN yum update -y \
	&& yum install -y initscripts net-tools vim*  curl wget unzip screen openssh-server git subversion locales \
#	gcc-c++ make openssl-devel \
#	&& yum groupinstall -y Chinese-support \
	&& yum clean all
RUN locale -a
#ENV LC_ALL zh_CN.UTF-8
#RUN sed -i 's/en_US.UTF-8/zh_CN.UTF-8/g' /etc/sysconfig/i18n
#RUN sed -i 's/#Port 22/Port 20022/g' /etc/ssh/sshd_config

RUN useradd -s /bin/bash -m land007
RUN echo "land007:1234567" | /usr/sbin/chpasswd
#land007:x:1000:1000::/home/land007:/bin/bash
RUN sed -i "s/^land007:x.*/land007:x:0:1000::\/home\/land007:\/bin\/bash/g" /etc/passwd

RUN mkdir /var/run/sshd
#RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' 
RUN ssh-keygen -A

ADD java /java
RUN cd /java && javac Main.java && \
	ln -s /java ~/ && \
	ln -s /java /home/land007 && \
	mv /java /java_
WORKDIR /java
VOLUME ["/java"]
ADD check.sh /
RUN sed -i 's/\r$//' /check.sh && \
	chmod a+x /check.sh

RUN echo $(date "+%Y-%m-%d_%H:%M:%S") >> /.image_times && \
	echo $(date "+%Y-%m-%d_%H:%M:%S") > /.image_time  && \
	echo "land007/java" >> /.image_names  && \
	echo "land007/java" > /.image_name 
ADD analytics.sh /
ADD start.sh /
RUN chmod +x /*.sh

EXPOSE 8080
EXPOSE 22/tcp

CMD /start.sh ; bash

#docker stop java ; docker rm java ; docker run -it --privileged --name java land007/java:latest
