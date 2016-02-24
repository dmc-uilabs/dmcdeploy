# README #

How to use this repository to create your stack.


last added on -- Feb. 23.16


1. create stack keys

- use the keymaker.sh script found in the devtools folder

\#$1 -- the number of keys needed
\#$2 -- the prefix of the keys
\#$3 -- the region where to send the keys us-east-1  or us-west-2
\#$4 -- the location where your keys should be stored

ex.
./keymaker.sh 4 alpha-2-15 us-east-1 ~/Desktop/keys

the names of the generated keys can be found in a file called keyNameZ

ex
2016_02_15_10_22_15_alpha-2-15_1
2016_02_15_10_22_15_alpha-2-15_2
2016_02_15_10_22_15_alpha-2-15_3
2016_02_15_10_22_15_alpha-2-15_4

the actual keys are placed in the ~/Desktop/keys


2. edit the terraform tfvars file

-- first add the key names and locations to the 4 machines

-- edit the stack prefix

-- ensure each machine in the stack is created from the commit needed


3. terraform plan

-- ensure that you are creating the stack you mean to be creating
5 new instances -- 4 machines and 1 security group


4. terraform apply

-- actually create the infrastructure

5. run stack test automated test to ensure stack is functional


6. move the stack to the apropriate load balancer




7. lock down the security groups

-- call script to lock down the security groups

8. run human tests to ensure stack is operational
-- log in
-- click around
