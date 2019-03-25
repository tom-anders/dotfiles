#!/usr/bin/python

import os
import pywal

#Update wall color scheme and reload polybar
os.system("wal --backend colorz --iterative -i $HOME/Pictures/Wallpapers -o $HOME/.config/polybar/launch.sh")

#Path to current wallpaper
image = pywal.wallpaper.get()

#Update lockscreen image
os.system("betterlockscreen -u " + image)



