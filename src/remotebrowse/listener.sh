#!/bin/bash

port=1234
browser=chromium-browser

listen_and_open_in_browser() {
  nc -l $port | while read line; do
    echo "received $line"
    $browser $line & disown
  done
}

while true; do
  listen_and_open_in_browser
done
