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
echo  "1. Create or Update DMC Stack"
echo  "2. Update the codebase on an Existing DMC Stack without altering the infrastructure"
read -n 1 choice

printf "\nYou chose $choice"
case $choice in [qQ]) exit;; esac
if [ $choice == 1 ]
  then


   if [ -f terraform.tfstate ]
     then
       terraform show
       printf "You have existing infrastructure on aws."

       printf "If you continue this script will edit that infrastructure in place.\n Would you like to continue? [y] [q to quit].\n You may wish to quit now and use terraform destroy to remove the infrastructure and rerun this script to make a new set"
       read tfstate
       case $tfstate in [qQ]) exit;; esac
   fi




    printf "\nCreating a new stack. \n Will need more information."
    ./createDevStack.sh $uname

    terraform plan
    printf  "\n Are you happy with the terrafom plan described above? \n Must answer yes or progam will not create your infrastructure. \n If you disagree go back and edit your terrafom.tfvars file manually and execute terraform apply.  [yes][q to quit] "

    read apply
    case $apply in [qQ]) exit;; esac
    if [ $apply == yes ]
      then

        terraform apply

        echo "Results of Sanity Test Front"
        cat frontSanityTest.log

        echo "Results of Sanity Test Rest"
        cat restSanityTest.log



        echo "Tightening the Security groups so that the machines can talk to one another."
        ./tightenSg

        echo "Lastly you must add your infrastructure to the appropriate LOAD BALANCER -- ex. ben-web in aws-west-2"

      else
       exit
    fi

  else
    printf "\nUpdating your existing infrastructure."

fi
