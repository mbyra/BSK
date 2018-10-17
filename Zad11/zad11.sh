#!/bin/bash

mkdir documents
mkdir tasks
mkdir solutions

file="$1"
friend="$2"
tasks="$3"

# creating an imaginary friend
useradd $friend

# giving him proper access rights
setfacl -d -m u:$friend:rw documents/
setfacl -d -m u:$friend:rwx tasks/
setfacl -d -m u:$friend:rwx -R solutions/

while IFS=' ', read -r uid first last
do
	# printf 'user id : %s, first name : %s, last name : %s\n' "$uid" "$first" "$last"
	# creating user
	useradd $uid
	
	# creating his tasks
	counter=1
	while [ $counter -le $tasks ]
	do
		mkdir -m 700 solutions/$uid-$counter
		# add fake solution for testing
		((counter++))
	done

	# setting appropriate access rights
	setfacl -d -m u:$uid:r documents/
	setfacl -d -m u:$uid:r tasks/

	counter=1
	while [ $counter -le $tasks ]
	do
		setfacl -m u:$uid:rwx solutions/$uid-$counter/
		((counter++))
	done


done < "$file"
