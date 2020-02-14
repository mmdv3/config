#!/bin/bash
#  before running the script make sure that internet connection is established
#!/bin/bash
#  template for arch install scripts

### variables ###############################
disk=/dev/sda
#  after install 64G of free space is left on hp laptop hard disk
efi_size=512M
boot_size=512M
lvm_size=400G
root_size=64G
home_size=16G
swap_size=8G
steam_size=96G
data_size=100%FREE
#  see sfdisk(8)
efi_type=U
boot_type=L
lvm_type=V

root_id=arch_root
home_id=arch_home
swap_id=arch_swap
steam_id=arch_steam
data_id=arch_data




#
arch-chroot /mnt
pacman -S vim dialog wpa_supplicant grub efibootmgr dosfstools os-prober mtools linux-headers
#  create initial ramdisk enviroment
#+ now you manually have to add 'encrypt' and 'lvm2' to HOOKS, just after 'block'
vim /etc/mkinitcpio.conf
mkinitcpio -p linux
#  GRUB install
#+ add 'cryptdevice=/dev/sda3:volume_group' to GRUB_CMDLINE_LINUX_DEFAULT
vim /etc/default/grub
mkdir /boot/EFI
mount /dev/sda1 /boot/EFI
grub-install --target=x86_64-efi --bootloader-id=arch_grub --recheck
grub-mkconfig -o /boot/grub/grub.cfg
#  set root password
passwd
#  prepare for shutdown
exit
umount -a 

### exit#####################################
echo "Are we done here?"
exit 0




