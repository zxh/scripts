echo "                                                              "
echo "                                                              "
echo "██╗    ██╗███████╗██╗      ██████╗ ██████╗ ███╗   ███╗███████╗"
echo "██║    ██║██╔════╝██║     ██╔════╝██╔═══██╗████╗ ████║██╔════╝"
echo "██║ █╗ ██║█████╗  ██║     ██║     ██║   ██║██╔████╔██║█████╗  "
echo "██║███╗██║██╔══╝  ██║     ██║     ██║   ██║██║╚██╔╝██║██╔══╝  "
echo "╚███╔███╔╝███████╗███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║███████╗"
echo " ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝"
echo "                                                              "
echo "                                                              "

echo "Start to initialize user for this system."
echo -n "1. Check executor's permission..."
if [ `whoami` == "root" ];then
	echo "OK!"
else
	echo "ERROR."
	exit 1
fi

echo -e "2. New fish name: \c"
read new_user
adduser $new_user
if [ $? -eq 0 ];then
	echo "3. Create user [$new_user]...OK!"
else
	echo "3. Create user [$new_user]...ERROR."
	exit 1
fi
password=`cat /proc/sys/kernel/random/uuid`
echo $password | passwd $new_user --stdin
echo "4. Set [$new_user] password, COPY it: $password"
read -p "5. Paste [$new_user] ssh_key here: "
ssh_key=$REPLY
echo "------------------------------------------------------"
echo "--------------- ssh key print begin ------------------"
echo "------------------------------------------------------"
echo "ssh_key: $ssh_key"
echo "------------------------------------------------------"
echo "---------------- ssh key print end -------------------"
echo "------------------------------------------------------"
su - $new_user <<END_USER
cd ~
mkdir .ssh
cd .ssh/
echo $ssh_key >> authorized_keys
chmod 600 authorized_keys
chmod 700 ~/.ssh
END_USER

echo -n "6. Does he needs the root permissions? (y/n) "
read root_permission
echo "$root_permission"
if [ $root_permission = "y" ];then
	usermod -g root $new_user
	echo "" >> /etc/sudoers
	echo "# user: $new_user config start" >> /etc/sudoers
	echo "$new_user		ALL=(ALL)       ALL" >> /etc/sudoers
	echo "$new_user		ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
	echo "# user: $new_user config end" >> /etc/sudoers
	echo "User [$new_user] already has root permission."
elif [ $root_permission = "n" ];then
	echo "Fine. No need to add root permission."
else
	echo "What?? I can't understand.."
	exit 1
fi
echo "User $new_user created! Bye~"
