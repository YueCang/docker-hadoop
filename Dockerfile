FROM ubuntu

# 镜像的作者  
MAINTAINER lyb

WORKDIR /root

# 修改apt-get镜像源
RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak && \ 
	sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && \
	sed -i s@/security.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && \
	apt-get clean


# 安装jdk
RUN apt-get update && apt-get install -y openjdk-8-jdk

# 安装必要的工具
RUN apt-get install -y openssh-server openssh-client net-tools vim wget && \
	ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
	cat .ssh/id_rsa.pub >> .ssh/authorized_keys && \
	echo "service ssh start" >> ~/.bashrc

# 下载hadoop
COPY tar/hadoop-3.3.1.tar.gz /root 

RUN	tar -xzvf /root/hadoop-3.3.1.tar.gz -C /usr/local && \
    mv /usr/local/hadoop-3.3.1 /usr/local/hadoop && \
    rm /root/hadoop-3.3.1.tar.gz

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME=/usr/local/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin 
ENV HDFS_NAMENODE_USER=root
ENV HDFS_DATANODE_USER=root
ENV HDFS_SECONDARYNAMENODE_USER=root
ENV YARN_RESOURCEMANAGER_USER=root
ENV YARN_NODEMANAGER_USER=root

RUN mkdir $HADOOP_HOME/logs

COPY config/* /tmp/

RUN mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/workers $HADOOP_HOME/etc/hadoop/workers

RUN hdfs namenode -format

CMD [ "sh", "-c", "service ssh start; bash"]
