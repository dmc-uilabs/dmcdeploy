#!/bin/bash


if grep --quiet "^Red Hat" /etc/redhat-release; then
  sudo rm /var/cache/yum/x86_64/7Server/timedhosts.txt; 
  sudo yum -y makecache fast; 
  sudo yum -y install yum-fastestmirror; 
  sudo yum -y install git-all java-1.8.0-openjdk wget
  sudo yum -y install ftp://fr2.rpmfind.net/linux/dag/redhat/el6/en/x86_64/dag/RPMS/axel-2.4-1.el6.rf.x86_64.rpm
  sudo yum -y update
  sudo systemctl stop firewalld
  sudo systemctl disable firewalld
fi

if grep --quiet "^CentOS" /etc/redhat-release; then
  sudo yum -y install ftp://fr2.rpmfind.net/linux/dag/redhat/el6/en/x86_64/dag/RPMS/axel-2.4-1.el6.rf.x86_64.rpm
  sudo sed -i 's|#mirror|mirror|' /etc/yum.repos.d/CentOS-Base.repo
  sudo yum -y makecache fast; 
  sudo yum -y install yum-fastestmirror; 
  sudo yum -y install epel-release
  sudo yum -y install git-all java-1.8.0-openjdk wget
  sudo systemctl stop firewalld
  sudo systemctl disable firewalld
fi
