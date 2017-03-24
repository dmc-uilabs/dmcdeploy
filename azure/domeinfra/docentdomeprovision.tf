resource "null_resource" "docentdomeProvision" {
  count = "${var.docent_status}"
  depends_on = ["azurerm_virtual_machine.docentdome"]


  provisioner "remote-exec" {
       inline = [
        "sudo apt-get update",
        "sudo apt-get -y install wget default-jdk tomcat7 unzip zip",
        "sudo service tomcat7 stop",
        "sudo rm *.war",
        "cd /var/lib/tomcat7/webapps/",
        "sudo wget --quiet https://s3-us-west-2.amazonaws.com/dmc-dev-deploy/DOME_WAR/DOMEApiServicesV7.war",
	"sudo unzip DOMEApiServicesV7.war WEB-INF/classes/config/config.properties",
        "sudo echo queue=tcp://10.0.12.4:61616 | sudo tee -a /var/lib/tomcat7/webapps/WEB-INF/classes/config/config.properties",
	"sudo zip --update DOMEApiServicesV7.war WEB-INF/classes/config/config.properties",
	"sudo rm -rf WEB-INF",
        "cd ~",
        "curl -s https://nodejs.org/dist/v6.10.1/node-v6.10.1-linux-x64.tar.xz -o node-v6.10.1-linux-x64.tar.xz",
        "tar -xf node-v6.10.1-linux-x64.tar.xz",
        "sudo mv node-v6.10.1-linux-x64 /usr/local/node",
        "cd /usr/local/bin",
        "sudo ln -s /usr/local/node/bin/node",
        "sudo ln -s /usr/local/node/lib/node_modules/npm/bin/npm-cli.js npm",
        "npm -g install aws-sdk",
        "echo NODE_PATH=/usr/local/node/lib/node_modules | sudo tee -a /etc/default/tomcat7",
        "sudo service tomcat7 start",
        "rm /home/dmcAdmin/node-v6.10.1-linux-x64.tar.xz"
       ]

       connection {
            host = "${azurerm_public_ip.docentdomePubIp.ip_address}"
           user = "${var.dmcUser}"
           private_key  = "${file("${var.sshKeyPath}/docentv03242017")}"

       }
  }
}
