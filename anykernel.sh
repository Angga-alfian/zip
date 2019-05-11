# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() {
kernel.string=AnyKernel2 by osm0sis @ xda-developers
do.devicecheck=0
do.modules=0
do.cleanup=1
do.cleanuponabort=0
} # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;
initd=/system/etc/init.d/;
patch=/tmp/anykernel/patch;
postboot = /vendor/bin/init.qcom.post_boot.sh

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;

# Mount partitions as rw
mount /system;
mount /vendor;
mount -o remount,rw /system;
mount -o remount,rw /vendor;

## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
chmod -R 750 $ramdisk/*;
chmod -R 755 $ramdisk/sbin;
chown -R root:root $ramdisk/*;

#Rename init.post-boot script
mv $postboot $postboot.bak

## AnyKernel install
dump_boot;

# begin ramdisk changes

#Remove old kernel stuffs from ramdisk
ui_print "cleaning up..."
 rm -rf $ramdisk/init.special_power.sh
 rm -rf $ramdisk/init.spectrum.rc
 rm -rf $ramdisk/init.spectrum.sh
 rm -rf $ramdisk/init.boost.rc

# backup post-boot script
if [ ! -f /vendor/bin/init.qcom.post_boot.sh.bkp ]; then
	cp -rpf /vendor/bin/init.qcom.post_boot.sh /vendor/bin/init.qcom.post_boot.sh.bkp;
fi

# replace post-boot script
cp -rpf $patch/init.qcom.post_boot.sh /vendor/bin/init.qcom.post_boot.sh;

# set permissions for post-boot script
chmod 0755 /vendor/bin/init.qcom.post_boot.sh

# rearm perfboostsconfig.xml
if [ ! -f /vendor/etc/perf/perfboostsconfig.xml ]; then
	mv /vendor/etc/perf/perfboostsconfig.xml.bkp /vendor/etc/perf/perfboostsconfig.xml;
fi

# rearm commonresourceconfigs.xml
if [ ! -f /vendor/etc/perf/commonresourceconfigs.xml ]; then
	mv /vendor/etc/perf/commonresourceconfigs.xml.bkp /vendor/etc/perf/commonresourceconfigs.xml;
fi

# rearm targetconfig.xml
if [ ! -f /vendor/etc/perf/targetconfig.xml ]; then
	mv /vendor/etc/perf/targetconfig.xml.bkp /vendor/etc/perf/targetconfig.xml;
fi

# rearm targetresourceconfigs.xml
if [ ! -f /vendor/etc/perf/targetresourceconfigs.xml ]; then
	mv /vendor/etc/perf/targetresourceconfigs.xml.bkp /vendor/etc/perf/targetresourceconfigs.xml;
fi

# rearm powerhint.xml
if [ ! -f /vendor/etc/powerhint.xml ]; then
	mv /vendor/etc/powerhint.xml.bkp /vendor/etc/powerhint.xml;
fi

# end ramdisk changes

write_boot;

## end install

