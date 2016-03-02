#!/bin/bash

echo "The following script will help you dmcdeploy and manage your development stack."
echo "###############################################################################################"

echo -n "What is your name. Each user will get a dir created that allows multiple people to use the same machine [ENTER][q to quit] "
read uname
if [ -z "$uname" ]
  then
    echo "No arguments supplied quitting"
    exit
fi
case $uname in [qQ]) exit;; esac

$name

if [ ! -d "~/$uname" ]; then
    # dir does not exist under that name make it
    echo "Creating your work dir in ~/$uname"
    mkdir ~/$uname
    cd ~/$uname/
    # clone dmcdeploy
    echo "Clonning dmcdeploy into your directory"
    git clone https://bitbucket.org/DigitalMfgCommons/dmcdeploy.git
fi

cd ~/$uname/dmcdeploy
echo "Updating the repo"
git pull

echo "Your code base is up to date.";
echo  "What would you like to do?  [ENTER][q to quit] "
echo  "1. Create New Stack"
echo  "2. Update an Existing Stack"
read -n 1 choice

printf "\nYou chose $choice"
case $name in [qQ]) exit;; esac
if [ $choice == 1 ]
  then
    printf "\nCreating a new stack. \n Will need more information."
    ./createDevStack.sh $uname
  else
    printf "\nUpdating your existing infrastructure."

fi
