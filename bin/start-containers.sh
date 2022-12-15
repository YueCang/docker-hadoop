#!/bin/bash

# the default node number is 3
N=${1:-3}

echo "Create a Hadoop network on docker"
sudo docker network create --driver=bridge hadoop

# start hadoop master container
sudo docker rm -f hadoop-master &> /dev/null
echo "start hadoop-master container..."
sudo docker run -itd \
                --net=hadoop \
                -p 50070:50070 \
                -p 8088:8088 \
                --name hadoop-master \
                --hostname hadoop-master \
                cang13146/hadoop &> /dev/null


# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	sudo docker rm -f hadoop-worker$i &> /dev/null

	echo "start hadoop-worker$i container..."
	
    sudo docker run -itd \
                --net=hadoop \
                --name hadoop-worker$i \
                --hostname hadoop-worker$i \
                cang13146/hadoop &> /dev/null

	i=$(( $i + 1 ))
done 

# get into hadoop master container
sudo docker exec -it hadoop-master bash
