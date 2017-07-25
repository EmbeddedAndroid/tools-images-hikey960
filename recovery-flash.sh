#!/bin/bash -e

DEVICE=$1
IMG_FOLDER=${PWD}

if [ "${DEVICE}" == "" ]; then
	DEVICE=/dev/ttyUSB1
fi

sudo ./hikey_idt -c config -p ${DEVICE}

echo "Look at serial console, and press the 'f' key to get into fastboot mode."

# partition table
fastboot flash ptable ${IMG_FOLDER}/prm_ptable.img

# bootloader
fastboot flash xloader ${IMG_FOLDER}/sec_xloader.img
fastboot flash fastboot ${IMG_FOLDER}/l-loader.bin
fastboot flash fip ${IMG_FOLDER}/fip.bin

# kernel and rootfs
wget http://builds.96boards.org/snapshots/reference-platform/openembedded/morty/hikey960/rpb/77/boot-0.0+AUTOINC+7efa39f363-c906d2a849-r0-hikey960-20170725140122-77.uefi.img
fastboot flash boot ${IMG_FOLDER}/boot-0.0+AUTOINC+7efa39f363-c906d2a849-r0-hikey960-20170725140122-77.uefi.img
wget http://builds.96boards.org/snapshots/reference-platform/openembedded/morty/hikey960/rpb/77/rpb-console-image-hikey960-20170725140122-77.rootfs.img.gz
gunzip -d ${IMG_FOLDER}/rpb-console-image-hikey960-20170725140122-77.rootfs.img.gz
fastboot flash system ${IMG_FOLDER}/rpb-console-image-hikey960-20170725140122-77.rootfs.img
