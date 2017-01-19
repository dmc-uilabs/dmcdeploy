resource "null_resource" "domeProvision" {
  depends_on = ["azurerm_virtual_machine.dome","null_resource.activemqProvision"]
  provisioner "remote-exec" {
       inline = [
        "sudo apt-get update",
        "sudo apt-get -y install wget default-jdk tomcat7",
        "sudo service tomcat7 stop",
        "sudo rm *.war",
        "cd /var/lib/tomcat7/webapps/",
        "sudo wget --quiet https://s3-us-west-2.amazonaws.com/dmc-dev-deploy/DOME_WAR/DOMEApiServicesV7.war",
        "echo two",
        "sudo service tomcat7 start",
        "sleep 10",
        "echo end",
        "sudo service tomcat7 stop",
        "echo queue=tcp://${azurerm_network_interface.activeInt.private_ip_address}:61616 | sudo tee -a /var/lib/tomcat7/webapps/DOMEApiServicesV7/WEB-INF/classes/config/config.properties",
        "sudo mv /var/lib/tomcat7/webapps/DOMEApiServicesV7.war /tmp",
        "sudo service tomcat7 start"

       ]

       connection {
            host = "${azurerm_public_ip.domePubIp.ip_address}"
           user = "${var.dmcUser}"
           private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"

       }
  }
}
