#!/bin/bash

ifconfig tap0 down
ifconfig tap0 11.0.0.1 netmask 255.0.0.0
ifconfig tap0 up
