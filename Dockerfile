FROM land007/ubuntu:latest

MAINTAINER Yiqiu Jia <yiqiujia@hotmail.com>

ENV JVM_VERSION jdk1.8.0_181
# ADD install/$JVM_VERSION-linux-x64.tar.gz /usr/local
RUN cd /tmp && wget http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-linux-x64.tar.gz && tar -C /usr/local -xzf jdk-8u181-linux-x64.tar.gz && rm -f jdk-8u181-linux-x64.tar.gz
ENV JAVA_HOME /usr/local/$JVM_VERSION
ENV CLASSPATH .:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
ENV PATH $PATH:$JAVA_HOME/bin

RUN echo 'export JVM_VERSION=jdk1.8.0_181' >> /etc/profile && echo 'export JAVA_HOME=/usr/local/$JVM_VERSION' >> /etc/profile && echo 'export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar' >> /etc/profile && echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /etc/profile


#docker stop java ; docker rm java ; docker run -it --privileged --name java land007/java:latest
