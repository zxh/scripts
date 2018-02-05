echo -n "Which user you want to delete? Write it: "
read delete_user
userdel $delete_user
groupdel $delete_user
echo ""
echo "Attention!!! If you have give user [$delete_user] root permission, remember to delete content in /etc/sudoers !!!"
echo ""
