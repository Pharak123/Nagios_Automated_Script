#!/bin/bash

#Forloop to add 10 users 

for (( i=2; i<11; i=i+1 ))

do

#To add simple User

sudo useradd user$i;

#to get message for user added successfully

echo "User $i added Successfully"

#Now to set the password for that users

echo -e "user$i@@321\nuser$i@@321" | sudo passwd user$i

#to remove the users you may run below cmd

#sudo userdel --remove user$i

done
