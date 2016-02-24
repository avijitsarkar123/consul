#!/bin/bash

counter=1
while [ $counter -le 100 ]
do
	consulkey=$(consul keygen)

  backslash=$(echo "$consulkey" | grep '\\')
  frontslash=$(echo "$consulkey" | grep '/')

  if [[ "${frontslash}" = ''  &&  "${backslash}" = '' ]]
  then
    echo "Generated consul key: $consulkey"
    break;
  fi

  (( counter++ ))

done
