#!/bin/bash



nessus () {
  curl -s -L https://github.com/ericchiang/pup/releases/download/v0.4.0/pup_v0.4.0_linux_amd64.zip | funzip | sudo tee /usr/local/bin/pup >/dev/null; sudo chmod 755 /usr/local/bin/pup
  TOKEN=`curl -s https://www.tenable.com/products/nessus/agent-download | pup 'div#timecheck text{}'`
  curl -L -s "http://downloads.nessus.org/nessus3dl.php?file=Nessus-6.10.2-es7.x86_64.rpm&licence_accept=yes&t=$TOKEN" -o /tmp/nessus.rpm
  sudo rpm -i /tmp/nessus.rpm
  sudo /opt/nessus_agent/sbin/nessuscli agent link --key=$1 --host=cloud.tenable.com --port=443
  sudo systemctl enable nessusd
  sudo systemctl start nessusd
}

nessus $1
