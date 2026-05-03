#!/bin/sh

tr -dc '!-~' < /dev/urandom | head -c $1
