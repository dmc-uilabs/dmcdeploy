#!/bin/bash

#remove quotes form variable
removeQuotes(){
    echo "$1" | sed -e 's/^"//'  -e 's/"$//'
}




#check if program exists if not install it
ifNotHaveInstall (){

    if hash $1 2>/dev/null; then
        echo "have $1 no need to install"
    else
        echo "don't got $1 install"
        sudo apt-get install $1 -y
        sudo yum install $1 -y

        echo "Installed $1"
        $1 --version

    fi
}

removePII () {
  printf "Cleanup of Personal Identifiable information"
  sed -i.bak 's/^access_key = ".*/access_key = ""/' terraform.tfvars
  sed -i.bak 's/^secret_key = ".*/secret_key = ""/' terraform.tfvars

  sed -i.bak 's/^export AWS_ACCESS_KEY_ID=".*/export AWS_ACCESS_KEY_ID=""/' tightenSgDev.sh
  sed -i.bak 's/^export AWS_SECRET_ACCESS_KEY=".*/export AWS_SECRET_ACCESS_KEY=""/' tightenSgDev.sh
  rm terraform.tfvars.bak
  rm tightenSgDev.sh.bak


  printf "AWS Keys have been removed from terraform.tfvars file as well as tightenSgDev.sh. \n Have a smooth day."

}
