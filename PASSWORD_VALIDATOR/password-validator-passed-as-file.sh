#!/bin/bash
# check if the argument -f is passed and if so read the contect of the file, 
# if not read the argument  ans save it in the var "user_pass" 
if [ "$1"  == "-f" ]; then
   USER_PASS="$(cat $2)";
else
   USER_PASS="$1" 
fi

LEN_OF_PASS=$(echo ${#USER_PASS}) # returns the number of chars from passed argumnt 

if [ ${LEN_OF_PASS} -lt 10 ]; then # check if number of chars from passed argument is not greater then 10
        echo -e "\e[31m Password most contain at least 10 characters"
        (exit 1)
        
elif [[ ${USER_PASS} !=  *[[:digit:]]* ]]; then
        echo -e  "\e[31m Password most contain digits"
        (exit 1)


elif   ! [[ ${USER_PASS} =~ [[:upper:]] ]] ; then
        echo -e "\e[31m Password most contain  upper case"
        (exit 1)

elif ! [[ ${USER_PASS} =~ [[:lower:]] ]]; then
        echo -e " \e[31m Password most contain lower case"
        (exit 1)
    
else
     echo -e  "\e[32m Very good password"
     (exit 0)
fi 

