#!/bin/bash
#importing devUtil
source ./devUtil.sh

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

if [[ ! -d ~/$uname ]];
   then
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
echo  "1. Create a new DMC Stack"
echo  "2. Update an existing DMC Stack Infrastructure"
echo  "3. Update the codebase on an Existing DMC Stack without altering the infrastructure"
echo  "4. Destroy existing DMC Stack Infrastructure"
read -n 1 choice

printf "\nYou chose $choice"
case $choice in [qQ]) exit;; esac
if [ $choice == 1 ]
  then


   if [ -f terraform.tfstate ]
     then
       terraform show
       printf "You have existing infrastructure on aws."

       printf "If you continue this script will edit that infrastructure in place.\n Would you like to continue? [y] [q to quit].\n You may wish to quit now and use terraform destroy to remove the infrastructure and rerun this script to make a new set.\n"
       read tfstate
       case $tfstate in [qQ]) exit;; esac
   fi




    printf "\nCreating a new stack. \n Will need more information."
    printf "\nWhat kind of stack would you like to deploy?"
    printf "\n1. Developmnet Stack"
    printf "\n2. Production Stack"
    read -n 1 schoice
    if [ $schoice == 1 ]; then
      printf "\nCreating Developmnet Stack"
      ./populateTerraformtfvarsDev.sh $uname
    else
      printf "\n Production Stack"
      printf "\n That part is not yet automated."

    fi

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
        echo "Link the Stack Machines Together"
        ./linkMachines.sh
        echo "Tightening the Dev Security groups where apropriate for the Dev Stack."
        ./tightenSgDev.sh
        echo "Lastly you must add your infrastructure to the appropriate LOAD BALANCER -- ex. ben-web in aws-west-2"

        echo "Great Job Pal. "
      else
       exit
    fi
    removePII
fi


if [ $choice == 2 ]
  then
  addPII
  printf "\nUpdating your existing infrastructure."
  printf "\n At the moment only the infrastructure found on the front end machine can be updated without destroying the rest of the stack. \n Do you wish to upgrade the infrastructure underpinning the frontend machine? [yes to upgrade ][q to quit]"
  read taintfront
  case $taintfront
    in [qQ])
     exit
     ;;
     yes)
       terrafom taint aws_instance.fornt
       terrafom apply
     ;;
  esac

  removePII
fi

if [ $choice == 3 ]
  then

    if [ ! -f terraform.tfstate ]; then
      printf "\nNo terrafom.tfstate found EXITING.\n Ensure you have a running stack."
      exit
    fi

  source ./updateStack.sh
  addPII
  printf "\nWhich instance do you wish to update? [q to quit]\n"
  echo  "1. Front End Machine"
  echo  "2. Rest Machine"
  echo  "3. Db Machine"
  echo  "4. Solr Machine"
  echo  "5. Update all stack components to latest available builds. "
  read -n 1 iupdate
  case $iupdate
     in [qQ])
       exit;;
      1)

      serverURL=$(removeQuotes $serverURL)
      printf "\nWhich build do you wish to deploy? [hot -- latest] [ commit hash -- for particular build] [q to quit]\n"
      read fbuild
      case $fbuild in [qQ]) exit;; esac
      printf "updating the front with $serverURL >> from commit $fbuild"
      updateFront $serverURL $fbuild


      ;;
      2)
      printf "\nWhich build do you wish to deploy on the rest machine? [hot -- latest] [ commit hash -- for particular build] [q to quit]\n"
      read fbuild
      case $fbuild in [qQ]) exit;; esac
      printf "\nUpdating the rest machine  >> from commit $fbuild"
      updateRest $fbuild

      ;;
      3)
       printf "\nWhich build do you wish to deploy on the db machine? [hot -- latest] [ commit hash -- for particular build] [q to quit]\n"
       read fbuild
       case $fbuild in [qQ]) exit;; esac
       printf "\nUpdating the db machine  >> from commit $fbuild"
       updateDb $fbuild

      ;;
     4)
        printf "solr"
      ;;

      5)
         printf "\Updating the entire stack"
         updateFront hot
         updateRest hot
         updateDb hot
         updateSolr hot
       ;;

  esac
   removePII
fi

if [ $choice == 4 ]
  then
    addPII
    printf "\nYour infrastructure will be obliterated."
    terraform destroy
    removePII
fi
