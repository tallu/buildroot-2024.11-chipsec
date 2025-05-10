# Building
make defconfig && make

# Save Buildroot's configuration
make savedefconfig BR2_DEFCONFIG=.defconfig

# Save Kernel's configuration
make linux-update-defconfig

# Test with QEMU
./dev-scripts/run-qemu.sh
