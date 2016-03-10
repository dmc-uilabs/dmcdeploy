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
  printf "\nCleanup of Personal Identifiable information.\n"
  sed -i.bak 's/^access_key = ".*/access_key = ""/' terraform.tfvars
  sed -i.bak 's/^secret_key = ".*/secret_key = ""/' terraform.tfvars

  sed -i.bak 's/^export AWS_ACCESS_KEY_ID=".*/export AWS_ACCESS_KEY_ID=""/' tightenSgDev.sh
  sed -i.bak 's/^export AWS_SECRET_ACCESS_KEY=".*/export AWS_SECRET_ACCESS_KEY=""/' tightenSgDev.sh

  sed -i.bak 's/^export AWS_ACCESS_KEY_ID=".*/export AWS_ACCESS_KEY_ID=""/' tightenSg.sh
  sed -i.bak 's/^export AWS_SECRET_ACCESS_KEY=".*/export AWS_SECRET_ACCESS_KEY=""/' tightenSg.sh
  rm terraform.tfvars.bak
  rm tightenSgDev.sh.bak


  printf "\nAWS Keys have been removed from terraform.tfvars file as well as tightenSgDev.sh. \n Have a smooth day."

}


addPII () {
    printf "\nAdding AWS Personal Identifiable Information.\n"

    echo -n "AWS_ACCESS_KEY_ID [ENTER][q to quit] "
    read name
    if [ -z "$name" ]
      then
        echo "No arguments supplied quitting"
        exit
    fi
    case $name in [qQ]) exit;; esac
    export AWS_ACCESS_KEY_ID=$name


    echo -n "AWS_SECRET_ACCESS_KEY [ENTER][q to quit] "
    read sec
    if [ -z "$sec" ]
      then
        echo "No arguments supplied quitting"
        exit
    fi
    case $sec in [qQ]) exit;; esac
    export AWS_SECRET_ACCESS_KEY=$sec


    sed -i.bak "s|access_key = \"\"|access_key = \"$name\"|" terraform.tfvars
    sed -i.bak "s|secret_key = \"\"|secret_key = \"$sec\"|" terraform.tfvars

    sed -i.bak "s|export AWS_ACCESS_KEY_ID=\"\"|export AWS_ACCESS_KEY_ID=\"$name\"|" tightenSgDev.sh
    sed -i.bak "s|export AWS_SECRET_ACCESS_KEY=\"\"|export AWS_SECRET_ACCESS_KEY=\"$sec\"|" tightenSgDev.sh

}



#####
# Will extract value from terraform,state within the tags
#
# usage getFromTfVars key_full_path_front << will return the value for that key
#####
getFromTfVars () {
  var=$(awk  '/'$1'/{print $NF}' terraform.tfvars)
  removeQuotes $var
}
