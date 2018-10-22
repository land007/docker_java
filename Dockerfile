FROM land007/debian:latest

MAINTAINER Yiqiu Jia <yiqiujia@hotmail.com>

# Install Java.
RUN apt-get install -y software-properties-common
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV CLASSPATH .:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
ENV PATH $PATH:$JAVA_HOME/bin
RUN echo 'export JAVA_HOME=/usr/lib/jvm/java-8-oracle' >> /etc/profile && echo 'export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar' >> /etc/profile && echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /etc/profile

# Define working directory.
RUN mkdir /java
#ADD java /java
WORKDIR /java
RUN ln -s /java ~/
RUN ln -s /java /home/land007
RUN mv /java /java_
VOLUME ["/java"]
ADD check.sh /
RUN sed -i 's/\r$//' /check.sh
RUN chmod a+x /check.sh

ENV CodeMeter_Server 192.168.86.8
RUN apt-get install -y libfontconfig1 libfreetype6 libice6 libsm6
ADD codemeter_6.70.3152.500_amd64.deb /tmp
RUN dpkg -i /tmp/codemeter_6.70.3152.500_amd64.deb && rm -f /tmp/codemeter_6.70.3152.500_amd64.deb
RUN service codemeter start && service codemeter status && cmu -l
RUN echo '[ServerSearchList\Server1]' >> /etc/wibu/CodeMeter/Server.ini
RUN service codemeter start && service codemeter status && cmu -k


ADD start.sh /
RUN sed -i 's/\r$//' /start.sh
RUN chmod a+x /start.sh
CMD /check.sh /java ; /etc/init.d/ssh start ; service codemeter start ; sleep 2 ; /start.sh
EXPOSE 8080

#docker stop java ; docker rm java ; docker run -it --privileged --name java land007/java:codemeter
