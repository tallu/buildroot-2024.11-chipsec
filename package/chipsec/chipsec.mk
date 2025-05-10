################################################################################
#
# chipsec
#
################################################################################

CHIPSEC_VERSION = 1.13.11
CHIPSEC_SITE = $(call github,chipsec,chipsec,$(CHIPSEC_VERSION))
CHIPSEC_SETUP_TYPE = setuptools
CHIPSEC_LICENSE = GPL-2.0
CHIPSEC_LICENSE_FILES = LICENSE
CHIPSEC_DEPENDENCIES = linux host-nasm

# needed in order to build chipsec's LKM against Buildroot's kernel
CHIPSEC_ENV += CROSS_COMPILE=$(TARGET_CROSS) KSRC=$(LINUX_DIR)

$(eval $(python-package))
