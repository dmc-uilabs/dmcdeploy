# README #

How to use this repository to create your stack.


Last changed on -- Feb. 23.16
<br />
<br />


### Create stack keys -- Optional step

Use the keymaker.sh script found in the devtools folder. ***Can only be used from a linux based development environment*** Skip this step if you plan on using already existing keys.
> ###### Variables needed for the script: <br />
>#$1 -- the number of keys needed
>#$2 -- the prefix of the keys
>#$3 -- the region where to send the keys us-east-1  or us-west-2
>#$4 -- the location where your keys should be stored

`
./keymaker.sh 4 alpha-2-15 us-east-1 ~/Desktop/keys `

The names of the generated keys can be found in a file called keyNameZ

`2016_02_15_10_22_15_alpha-2-15_1
2016_02_15_10_22_15_alpha-2-15_2
2016_02_15_10_22_15_alpha-2-15_3
2016_02_15_10_22_15_alpha-2-15_4
`
<br />

The actual keys are placed in the location specified by $4


### Edit the terraform.tfvars file

- Add the key names and locations to the machines

- Edit the stack prefix

- Ensure each machine in the stack is created from the commit hash you want. Use 'hot' if you want the latest commit that has passed all the tests.


### $ terraform plan

- Ensure that you are creating the stack you mean to be creating.



### $ terraform apply

- actually create the infrastructure

### Review the sanityTest.log results

- During stack creation a number of automated tests are run to ensure the infrastructure has been deployed properly. The results of these tests are downloaded locally for your inspection.

- frontSanityTest.log
- restSanityTest.log


### Move the stack to the appropriate load balancer

- Should match the ServerUrl variable that was set during the stack creation.


### Lock down the security groups
- Edit tightenSg.sh to include your aws key and aws secret
- $ ./tightenSg.sh --- to lock down the security groups [at the moment can only  be run from a linux machine]
- #### on windows dev environments the security groups must be set manually from the aws web console

### Human tests to ensure stack is operational
- log in
- click around
