#!/bin/bash
# from https://devicetests.com/get-battery-notifications-ubuntu

while true
do
    battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)'`
    acpi -b | grep charging
    is_charging="$?"  # 0 discharging, 1 charging
    if [ $is_charging == 0 ] && [ $battery_level -le 40 ]; then
        notify-send "Begin charging" "Battery level is ${battery_level}%!"
    elif [ $is_charging == 1 ] && [ $battery_level -ge 80 ]; then
        notify-send "Unplug charger" "Battery level is ${battery_level}%!"
    fi
    sleep 60
done
