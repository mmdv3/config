#!/bin/bash

while true; do
  string=$(cat /sys/class/power_supply/BAT0/capacity)"%"
  xsetroot -name " $(iwconfig|grep ESSID)|$(date)|BAT ${string} "
  sleep 2
done
