resource "null_resource" "domeProvision" {
  depends_on = ["azurerm_virtual_machine.dome","null_resource.activemqProvision"]
  provisioner "remote-exec" {
       inline = [
        "sudo apt-get update",
        "sudo apt-get -y install wget default-jdk tomcat7 unzip zip",
        "sudo service tomcat7 stop",
        "sudo rm *.war",
        "cd /var/lib/tomcat7/webapps/",
        "sudo wget --quiet https://s3-us-west-2.amazonaws.com/dmc-dev-deploy/DOME_WAR/DOMEApiServicesV7.war",
	"sudo unzip DOMEApiServicesV7.war WEB-INF/classes/config/config.properties",
        "sudo echo queue=tcp://${azurerm_network_interface.activeInt.private_ip_address}:61616 | sudo tee -a /var/lib/tomcat7/webapps/WEB-INF/classes/config/config.properties",
	"sudo zip --update DOMEApiServicesV7.war WEB-INF/classes/config/config.properties",
	"sudo rm -rf WEB-INF",
        "sudo service tomcat7 start"
       ]

       connection {
            host = "${azurerm_public_ip.domePubIp.ip_address}"
           user = "${var.dmcUser}"
           private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"

       }
  }
}
