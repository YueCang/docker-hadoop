#!/bin/bash
  
# the default node number is 3
N=${1:-3}

# stop hadoop master container
echo "stop hadoop-master container..."
sudo docker container stop hadoop-master


# stop hadoop slave container
i=1
while [ $i -lt $N ]
do
    echo "stop hadoop-worker$i container..."
    sudo docker container stop hadoop-worker$i

    i=$(( $i + 1 ))
done
