#!/bin/bash
set -e

make savedefconfig BR2_DEFCONFIG=.defconfig
