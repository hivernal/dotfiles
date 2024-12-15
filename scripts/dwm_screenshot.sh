#!/bin/bash

# scrot -o -s /dev/stdout | xclip -t image/png -selection clipboard -i
maim -s | xclip -t image/png -selection clipboard -i
