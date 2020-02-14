#!/bin/bash
#  running this script before reboot(just after install) is silly 

### variables ###############################
#  possibly fallback values for variables if no values are exported by post_chroot.sh
any_path=/.files/repository/any
config_path=/.files/repository/config
other_path=/.files/repository/other

regular_packages=$(echo $(cat downloads|grep '#regular:'|sed 's/#.*$//g'|tr -d '\n'))
aur_packages=$(echo $(cat downloads|grep '#AUR:'|sed 's/#.*$//g'|tr -d '\n'))
forks=$(echo $(cat downloads|grep '#fork:'|sed 's/#.*$//g'|tr -d '\n'))
repositories=$(echo $(cat downloads|grep '#repo:'|sed 's/#.*$//g'|tr -d '\n'))
target_user_home=/home/archie
my_github=https://github.com/mmdv3
aur=https://aur.archlinux.org

start_dir=$(pwd)
## script ##################################
#  download packages
sudo pacman -Syu $regular_packages
# 
echo "--fixes--"
fc-cache #  just to double check if fonts got installed correctly
##  clone repositories
echo "--clone repos--"
cd /.files
mkdir repository
mkdir fork
mkdir aur
cd /.files/repository
for repository in $repositories
do
	git clone $my_github/$repository
done
#
echo "--references--"
mkdir $target_user_home/.config
mkdir $target_user_home/.vim
mkdir $target_user_home/.config/zathura
ln -s  /.files					$target_user_home/Files

ln -sf $config_path/infokey 		 	$target_user_home/.infokey
ln -sf $config_path/config/i3			$target_user_home/.config/i3
ln -sf $config_path/config/i3status		$target_user_home/.config/i3status
ln -sf $config_path/vim/filetype.vim	 	$target_user_home/.vim/filetype.vim
ln -sf $config_path/vim/ftplugin		$target_user_home/.vim/ftplugin
ln -sf $config_path/vimrc			$target_user_home/.vimrc
ln -sf $config_path/xinitrc			$target_user_home/.xinitrc
ln -sf $config_path/Xresources			$target_user_home/.Xresources
ln -sf $config_path/zathura/zathurarc		$target_user_home/.config/zathura/zathurarc
ln -sf $config_path/zshrc			$target_user_home/.zshrc
#
echo "--local files--"
cp	$other_path/templates/zshlocal $target_user_home/zshlocal
cp	$other_path/templates/xlocal $target_user_home/xlocal
cp $other_path/templates/30-touchpad.conf /etc/X11/xorg.conf.d
#  AUR
echo "--AUR packages--"
cd /.files/aur
for package in $aur_packages
do
	git clone $aur/$package
	cd $package
	makepkg -si
	cd ../
done
#  forks
echo "--clone forks--"
cd /.files/fork
for fork in $forks
do
	git clone $my_github/$fork
	cd $fork
	echo "- $fork -"
	sudo make install
	cd ../
done

### exit#####################################
cd $start_dir
exit 0


