FROM ubuntu

RUN apt-get update
RUN apt-get install -y wget openjdk-8-jre ssh

ARG HADOOP_VERSION=3.2.0

RUN wget http://ftp.itu.edu.tr/Mirror/Apache/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
RUN mkdir /hadoop
RUN tar -xvzf hadoop-${HADOOP_VERSION}.tar.gz -C /hadoop --strip-components 1
RUN rm hadoop-${HADOOP_VERSION}.tar.gz

COPY hadoop /hadoop/etc/hadoop

RUN ssh-keygen -t rsa -b 4096 -P '' -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN chmod 400 ~/.ssh/authorized_keys

ENV HADOOP_HOME=/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin

RUN hdfs namenode -format

VOLUME /hadoop/etc/hadoop
VOLUME /hadoop/logs
EXPOSE 9870
EXPOSE 8088

WORKDIR /hadoop
COPY run.sh run.sh
RUN chmod +x run.sh
CMD ./run.sh
