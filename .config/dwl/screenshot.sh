#!/bin/bash

wayshot --stdout	-s "$(slurp)"	| wl-copy
