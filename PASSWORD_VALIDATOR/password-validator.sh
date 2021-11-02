#!/bin/bash
USER_PASS="$1" # get the password as a command line argument 

LEN_OF_PASS=$(echo ${#USER_PASS}) # returns the number of chars from passed argumnt 

if [ $LEN_OF_PASS -lt 10 ]; then # check if number of chars from passed argument is not greater then 10
        echo -e "\e[31m Password must contain at least 10 characters"
        (exit 1)
        
elif [[ $USER_PASS !=  *[[:digit:]]* ]]; then
        echo -e  "\e[31m Password must contain digit"
        (exit 1)

elif   ! [[ $USER_PASS =~ [[:upper:]] ]] ; then
        echo -e "\e[31m Password must contains  upper case"
        (exit 1)

elif ! [[ $USER_PASS =~ [[:lower:]] ]]; then
        echo -e " \e[31m Password mustcontain lower case"
        (exit 1)
    
else
     echo -e  "\e[32m Very good password"
     (exit 0)
    
fi




