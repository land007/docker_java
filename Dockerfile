FROM openjdk:latest

MAINTAINER Yiqiu Jia <yiqiujia@hotmail.com>

RUN yum update -y \
	&& yum install -y initscripts net-tools vim*  curl wget unzip screen openssh-server git subversion locales \
	&& yum clean all
RUN locale -a && \
	useradd -s /bin/bash -m land007 && \
	echo "land007:1234567" | /usr/sbin/chpasswd && \
	sed -i "s/^land007:x.*/land007:x:0:1000::\/home\/land007:\/bin\/bash/g" /etc/passwd && \
	mkdir /var/run/sshd && \
	ssh-keygen -A

ADD java /java
RUN cd /java && javac Main.java && \
	ln -s /java ~/ && \
	ln -s /java /home/land007 && \
	mv /java /java_
WORKDIR /java
VOLUME ["/java"]
ADD check.sh / \
	analytics.sh / \
	start.sh / \
	task.sh /
RUN sed -i 's/\r$//' /*.sh && chmod +x /*.sh && \
	echo $(date "+%Y-%m-%d_%H:%M:%S") >> /.image_times && \
	echo $(date "+%Y-%m-%d_%H:%M:%S") > /.image_time && \
	echo "land007/java" >> /.image_names && \
	echo "land007/java" > /.image_name
	

EXPOSE 8080/tcp \
	22/tcp

CMD /task.sh ; /start.sh ; bash

#docker build -t land007/java:latest .
#docker stop java ; docker rm java ; docker run -it --privileged --name java land007/java:latest
