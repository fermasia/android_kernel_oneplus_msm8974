#!/bin/bash
TOOLCHAIN="/home/nando/dev/toolchains/uber49/bin"
JOBS="-j$(grep -c ^processor /proc/cpuinfo)"
echo "Cleaning old files"
rm -f ../AnykernelCYANO/dtb
rm -f ../AnykernelCYANO/zImage
echo "Making kernel"
DATE_START=$(date +"%s")

make clean && make mrproper

export ARCH=arm
export SUBARCH=arm
make CROSS_COMPILE=$TOOLCHAIN/arm-eabi- cyanogenmod_bacon_defconfig
make CROSS_COMPILE=$TOOLCHAIN/arm-eabi- $JOBS
echo "End of compiling kernel!"

DATE_END=$(date +"%s")
echo
DIFF=$(($DATE_END - $DATE_START))
echo "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."

../ramdisk_one_plus_one/dtbToolCM -2 -o ../AnykernelCYANO/dtb -s 2048 -p ../cyano/scripts/dtc/ ../cyano/arch/arm/boot/
cp arch/arm/boot/zImage ../AnykernelCYANO/zImage
cd ../AnykernelCYANO/
zipfile="CYAN-v"$1".zip"
zip -r -9 $zipfile *
mv CYAN-v*.zip ../OUT/
