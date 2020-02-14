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
data_size=100%FREE
#  see sfdisk(8)
efi_type=U
boot_type=L
lvm_type=V

root_id=arch_root
home_id=arch_home
swap_id=arch_swap
data_id=arch_data

### script ##################################
#  partition disk 
echo "--partitioning--"
echo -e	" label: gpt \n \
	, $efi_size, $efi_type \n \
	, $boot_size, $boot_type \n \
	, $lvm_size, $lvm_type " | sfdisk $disk
mkfs.fat -F32 /dev/sda1 	#  efi partition
mkfs.ext2 /dev/sda2 		#  boot partiton
cryptsetup luksFormat /dev/sda3 #  lvm partiton
cryptsetup open --type luks /dev/sda3 lvm	#  lvm can be any name
pvcreate /dev/mapper/lvm
vgcreate volume_group /dev/mapper/lvm
lvcreate -L $root_size -n $root_id volume_group
lvcreate -L $home_size -n $home_id volume_group
lvcreate -L $swap_size -n $swap_id volume_group
	#lvcreate -L $steam_size -n $steam_id volume_group
lvcreate -l $data_size -n $data_id volume_group
#  
modprobe dm_mod
vgscan
vgchange -ay
#  format partitions
echo "--partition formatting--"
mkfs.ext4 /dev/volume_group/$root_id
mkfs.ext4 /dev/volume_group/$home_id
mkswap 	/dev/volume_group/$swap_id
	#mkfs.ext4 /dev/volume_group/$steam_id
mkfs.ext4 /dev/volume_group/$data_id
#  mount necessary shit before downloading base packages
echo "--mount #1--"
mount /dev/volume_group/$root_id /mnt
mkdir /mnt/boot
mount /dev/sda2 /mnt/boot
mkdir /mnt/home
mount /dev/volume_group/$home_id /mnt/home
swapon /dev/volume_group/$swap_id
#  install base packages
echo "--pacstrap--"
pacstrap -i /mnt base base-devel
#  mount the rest(don't do that before pacstrap), generate fstab
echo "--mount #2,fstab--"
mkdir /mnt/.files
mount /dev/volume_group/$data_id /mnt/.files
	#mkdir /mnt/.steam_partition
	#mount /dev/volume_group/$steam_id /mnt/.steam_partition
genfstab -U -p /mnt >> /mnt/etc/fstab
cat fstab-automount >> /mnt/etc/fstab

### exit ####################################
echo "--exit--"
echo "Now run arch-chroot /mnt"
exit 0





