# Preface
A Buildroot project that builds Linux image (bzImage). The Linux image
includes chipsec.


# Building
$ make defconfig && make

A Dockerfile is provided for building from inside a container.


# Save Buildroot's configuration
$ make savedefconfig BR2_DEFCONFIG=.defconfig


# Save Kernel's configuration
$ make linux-update-defconfig


# Test with QEMU
The Linux image can be tested with QEMU.
A ready-to-run script was created for that
$ sudo ./dev-scripts/run-qemu.sh

Notice: this script was not tested from the contianer
