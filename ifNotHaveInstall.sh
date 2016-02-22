#!/bin/bash

## will check if provided program exists if not try to install it from appropriate repo


    if hash $1 2>/dev/null; then
        echo "have $1 no need to install"
    else
        echo "don't got $1 install"
        sudo apt-get install $1 -y
        sudo yum install $1 -y

        echo "Installed $1"
        $1 --version

    fi
