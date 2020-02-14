#!/bin/sh

i3status | while :
do	
  read line
  string=$(xdotool getactivewindow getwindowname) 
  if [[ ${#string} -ge 40 ]]
  then
	string=${string: -40}
  fi
  echo "$string | $line" || exit 1
done
