#!/bin/bash
host=$1
port=$2
path_from=$3
path_to=$4

#rsync -e ssh --remove-source-files 
#rsync -vz -e ssh -p $2 rsync@$1:$3 $4
rsync -avz --remove-source-files    --include='*.csv' --exclude '*' -e="ssh -p $2" rsync@$1:$3   $4


