####### 29 IV 2020 ############################################################
## connect to the internet
## format disk
sfdisk /dev/sda
, 512M, U #efi partition
, 512M, L #boot partition
, 400G, V #lvm partition
write
## format partitions
mkfs.fat -F32  /dev/sda1
mkfs.ext2 /dev/sda2
cryptsetup luksFormat /dev/sda3
cryptestup open --type luks /dev/sda3 lvm #open encrypted partition
pvcreate /dev/mapper/lvm
vgcreate volume_group /dev/mapper/lvm
lvcreate -L 64G -n root volume_group
lvcreate -L 64G -n root volume_group
lvcreate -L 16G -n home volume_group
lvcreate -L 8G -n swap volume_group
lvcreate -l 100%FREE -n data volume_group
modprobe dm_mod
vgscan
vgchange -ay
mkfs.ext4 /dev/volume_group/root
mkfs.ext4 /dev/volume_group/home
mkfs.ext4 /dev/volume_group/data
mkswap /dev/volume_group/swap
## mount partitions
mount /dev/volume_group/root /mnt
mkdir /mnt/boot
mount /dev/sda2 /mnt/boot
mkdir /mnt/home
mount /dev/volume_group/home /mnt/home
swapon /dev/volume_group/swap
## install most essential packages
pacstrap -i /mnt base base-devel
## generate fstab
mkdir /mnt/.files
mount /dev/volume_group/data /mnt/.files
genfstab -U -p /mnt >> /mnt/etc/fstab
cat fstab-automount >> /mnt/etc/fstab #fstab-automount - template
## chroot
arch-chroot /mnt
## install git (package)
## download config repository
## install essential packages
## build kernel (run from config directory)
cp templates/mkinitcpio.conf /etc/mkinitcpio.conf
mkinitcpio -p linux
## install grub
cp templates/grub /etc/default/grub
mkdir /boot/EFI
mount /dev/sda1 /boot/EFI
grub-install --target=x86_64-efi --bootloader-id=grub --recheck
grub-mkconfig -o /boot/grub/grub.cfg
## set root password
passwd
## create regular user
useradd -m -g users -G wheel -s /bin/zsh archie
passwd archie
## enable sudo for wheel group
cp template/sudoers /etc/sudoers
## set timezone
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
## generate locales
echo -e "us_US.UTF-8 UTF-8 \n pl_PL.UTF-8 UTF-8 \n ja_JP.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
cp templates/locale.conf /etc/locale.conf
## enable mulilib repository
cp templates/pacman.conf /etc/pacman.conf
## transfer ownerships
chown archie:users install_scripts/install_third.sh
chown -R archie:users /.files
##### unmount everything and reboot ###########################################
## install graphics drivers (e.g. xf86-video-intel or xf86-video-nouveau)
## install necessary to boot into graphical enviroment
sudo pacman -Sy xorg-server xorg-xinit dmenu
## install terminal manager and window manager
## install xbanish (forked)
## link xinitrc
##### reboot and start graphical enviroment with startx #######################
## link zshrc
## install remaining packages
## link remaining files
## set variables in zshlocal
## copy hosts from config to /etc/hosts
## set up github
git config --global user.name "your name"
git config --global user.email "your email"
###### reboot #################################################################
## run fcitx-configtool and add mozc input method




