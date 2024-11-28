echo -e "\e[36m >>>>>>>> disable mysql module <<<<<<<<< \e[0m"
dnf module disable mysql -y
echo -e "\e[36m >>>>>>>> copy mysql repo <<<<<<<<< \e[0m"
cp mysql.repo /etc/yum.repos.d/mysql.repo
echo -e "\e[36m >>>>>>>> install mysql <<<<<<<<< \e[0m"
dnf install mysql-community-server -y
echo -e "\e[36m >>>>>>>> start mysql service <<<<<<<<< \e[0m"
systemctl enable mysqld
systemctl start mysqld
echo -e "\e[36m >>>>>>>> set mysql password <<<<<<<<< \e[0m"
mysql_secure_installation --set-root-pass RoboShop@1