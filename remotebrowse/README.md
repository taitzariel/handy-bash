# click on link in windows, open in linux guest browser
1. run remotebrowsedaemon
1. copy remote-browser.bat to c:\tmp
1. select a browser that won't be used in windows (e.g.firefox)
1. change default apps Web browser to firefox
1. find ProgId of firefox at
   HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\Shell\Associations\URLAssociations\(http|https)\UserChoice
   (https://stackoverflow.com/questions/32354861/how-to-find-the-default-browser-via-the-registry-on-windows-10)
1. backup [HKEY_CLASSES_ROOT\FirefoxURL-E7CF176E110C211B\shell\open\command]
   and edit it to instead point to "c:\tmp\remote-browser.bat" %1

