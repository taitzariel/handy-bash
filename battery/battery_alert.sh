#!/bin/bash
# from https://devicetests.com/get-battery-notifications-ubuntu

while true
do
 battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)'`
 if [ $battery_level -le 40 ]
 then
 notify-send "Begin charging" "Battery level is ${battery_level}%!"
 elif [ $battery_level -ge 80 ]
 then
 notify-send "Unplug charger" "Battery level is ${battery_level}%!"
 fi
 sleep 60
done
