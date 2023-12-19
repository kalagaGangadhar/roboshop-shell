mysql_root_passwd=$1
if [ -z "${mysql_root_passwd}" ]; then
  echo mysql root passwd is missing
  exit 1
fi
dnf module disable mysql -y
cp mysql.repo /etc/yum.repos.d/mysql.repo
dnf install mysql-community-server -y
systemctl enable mysqld
systemctl restart mysqld
mysql_secure_installation --set-root-pass ${mysql_root_passwd}
