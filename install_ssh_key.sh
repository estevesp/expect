#!/usr/bin/expect
# Setting environment variables
set timeout      10
set hostname     [lindex $argv 0]
set password     [lindex $argv 1]
set user         [exec whoami]
set now          [clock seconds]
set date         [clock format $now -format {%Y-%m-%d %H:%M:%S}]

#Main body of the expect script 

send_user " \n ################################################################ \n"; 
send_user " $date Installing SSH ID for $user on $hostname \n" 
send_user " ################################################################ \n\n";

spawn ssh-copy-id $hostname # stating the key copying using ssh-copy-id command

expect { 

#Handling the timeout case 
    timeout 
    { 
        send_user " ################################################################ \n"; 
        send_user " $date Failure installing SSH Key for $user on $hostname due to timeout \n"; 
        send_user " ################################################################ \n\n";
        exit 1 
    }
#Handling the end of file of the ssh handshake without user interaction, eof case 
    eof 
    { 

        send_user " ################################################################ \n"; 
        send_user " $date SSH Key is already added for $user on $hostname  \n"; 
        send_user " ################################################################ \n\n";
        exit 0
    }

#Handling the first time host login case, seding "yes"
    "*re you sure you want to continue connecting" {
        send "yes\r"
        exp_continue
    }

#Main case, seding password via std input
    "*assword*" {
        send "$password\r"
        interact
        send_user " ################################################################ \n"; 
        send_user " $date Successfully installed SSH Key on $hostname \n"; 
        send_user " ################################################################ \n\n"; 
        exit 0
    }
}
#end