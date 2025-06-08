#!/usr/bin/bash

tr -dc '!-~' < /dev/urandom | head -c $1
