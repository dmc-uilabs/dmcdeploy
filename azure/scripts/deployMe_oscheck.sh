#!/bin/bash


if grep --quiet "^Red Hat" /etc/redhat-release; then
  sudo yum -y install git
fi

if grep --quiet "^CentOS" /etc/redhat-release; then
  sudo yum -y install git-all
  sudo sed -i 's|#mirror|mirror|' /etc/yum.repos.d/CentOS-Base.repo
fi
