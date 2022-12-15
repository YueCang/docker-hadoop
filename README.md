## 构建docker镜像

1. 下载镜像所需要的配置文件

   ```shell
   git clone https://github.com/YueCang/docker-hadoop.git
   ```

   

2. 下载hadoop压缩包

   ```shell
   wget -b https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-3.3.1/hadoop-3.3.1.tar.gz .
   
   mkdir tar
   mv hadoop-3.3.1.tar.gz tar/
   ```

   - 在docker-hadoop路径下创建 tar，并将下载的hadoop移动进去

3. 进行镜像的构建

   ```shell
   docker build -t cang13146/hadoop .
   
   # 查看镜像
   docker images
   
   REPOSITORY         TAG       IMAGE ID       CREATED         SIZE
   cang13146/hadoop         latest    621b8ea781ed   7 hours ago     2.57GB
   ```

   - 在Dockerfile文件路径下构建镜像

## 启动容器

1. 启动容器前，我们需要构建容器的网络

   ```shell
   docker network create --driver=bridge hadoop
   
   # 查看网络构建情况
   docker network ls
   NETWORK ID     NAME      DRIVER    SCOPE
   757e19bf44a4   hadoop    bridge    local
   ```

2. 启动容器

   ```shell
   bin/start-container.sh
   ```

3. 在hadoop-master中启动hadoop集群

   ```shell
   # 启动集群
   start-all.sh
   
   # 停止集群
   stop-all.sh
   ```

   