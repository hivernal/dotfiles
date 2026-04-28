#!/usr/bin/env bash

tr -dc '!-~' < /dev/urandom | head -c $1
