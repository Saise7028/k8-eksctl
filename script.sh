#!/bin/bash

# Re-sizeing the Disk Space

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "installing the script with root previliges"
    exit 1
fi    
echo "Resizeing the Disk Volume"
df -hT
lsblk
growpart /dev/xvda 4  # t2.micro is /dev/xvda and t3.micro is /dev/nvme0n1 4
lvextend -l +50%FREE /dev/RootVG/rootVol
lvextend -l +50%FREE /dev/RootVG/varVol
xfs_growfs /
xfs_growfs /var
df -hT

