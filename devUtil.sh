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