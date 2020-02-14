#!/bin/bash
#  run the script from repo directory 

### variables ###############################
#  possibly fallback values for variables if no values are exported by post_chroot.sh
any_path=/.files/repository/any
config_path=/.files/repository/config
other_path=/.files/repository/other

disk=/dev/sda
#  after install 64G of free space is left on hp laptop hard disk
efi_size=512M
boot_size=512M
lvm_size=400G
root_size=64G
home_size=16G
swap_size=8G
data_size=100%FREE
#  see sfdisk(8)
efi_type=U
boot_type=L
lvm_type=V

root_id=arch_root
home_id=arch_home
swap_id=arch_swap
data_id=arch_data

essential_packages=$(echo $(cat downloads|grep '#essential:'|sed 's/#.*$//g'|tr -d '\n'))
### script ##################################


#
pacman -S $essential_packages
#  create initial ramdisk enviroment
cp ./mkinitcpio.conf /etc/mkinitcpio.conf #  encrypt, lvm2 hooks
mkinitcpio -p linux
#  GRUB install
cp ./grub /etc/default/grub
mkdir /boot/EFI
mount /dev/sda1 /boot/EFI
grub-install --target=x86_64-efi --bootloader-id=arch_grub --recheck
grub-mkconfig -o /boot/grub/grub.cfg
#  set root password
echo "--set root password--"
passwd
#  create user archie
echo "--create regular user--"
useradd -m -g users -G wheel -s /bin/zsh archie	#  until zsh is present you cannot log in as archie
passwd archie	
#  enable sudo for wheel group
echo "--enable sudo--"
cp ./sudoers /etc/sudoers
#  set timezone
echo "--timezone--"
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
#  generate locales
echo "--generate locales--"
echo -e "en_US.UTF-8 UTF-8 \n pl_PL.UTF-8 UTF-8 \n ja_JP.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
cp locale.conf /etc/locale.conf
#  enable multilib repository
echo "--enable multilib--"
cp ./pacman.conf /etc/pacman.conf
#  make install after reboot easier
echo "--transfer ownerships--"
chown archie:users install-third.sh
chown -R archie:users /.files
	#chown -R archie:users /.steam_partition
### exit#####################################
echo "Remember to unmount everything before a reboot"
exit 0


