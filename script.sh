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
echo -e "$Y Logout and Login again $N"

echo -e "$R Docker Installation Successfully Completed $N"

# Kubectl Installation 

echo -e "$G Kubectl Installation $N"

curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.31.0/2024-09-12/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv kubectl /usr/local/bin/kubectl
kubectl version

echo -e "$G Docker Installation Successfully Completed $N"

# eksctl Installation

echo -e "$Y Docker Installation Successfully Completed $N"

ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

# (Optional) Verify checksum
# curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check

tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz

mv /tmp/eksctl /usr/local/bin

echo -e "$G Docker Installation Successfully Completed $N"

