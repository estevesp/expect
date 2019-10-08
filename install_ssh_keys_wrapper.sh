#!/bin/bash
# Author:    Pedro Esteves
# Date:     2019-07-10

# Setting environment variables
install_ssh_key_script="./install_ssh_key.sh" # set the location of the install_ssh_key.sh script
host_list=$1
password=$2

#Main body of the wrapper script 
host_list=$(cat ./$host_list) # reading host list file
password=$(cat ./$password)   # reading pwd file
for host in $host_list        # looping through the host list file and invoking the install_ssh_key.sh scrit.
    do
    {
        #echo "Entering loop $host $password"
        $install_ssh_key_script $host $password 
    }
done
#end