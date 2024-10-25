#!/bin/bash

# Re-sizeing the Disk Space

USERID=$(id -u)

    R="\e[31m"
    G="\e[32m"
    Y="\e[33m"
    N="\e[0m"

if [ $USERID -ne 0 ]
then
    echo -e "$R installing the script with root previliges $N"
    exit 1
fi    
echo -e "$G Resizeing the Disk Volume $N"
df -hT
lsblk
growpart /dev/xvda 4  # t2.micro is /dev/xvda and t3.micro is /dev/nvme0n1 4
lvextend -l +50%FREE /dev/RootVG/rootVol
lvextend -l +50%FREE /dev/RootVG/varVol
xfs_growfs /
xfs_growfs /var
df -hT

# Installing Docker
echo -e "$G Docker Installation $N"
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user
echo -e "$G Logout and Login again $N"

