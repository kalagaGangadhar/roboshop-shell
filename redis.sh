echo -e "\e[36m >>>>>>>> download remirepo for redis <<<<<<<< \e[0m"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
echo -e "\e[36m >>>>>>>> enable redis 6.2 <<<<<<<< \e[0m"
dnf module enable redis:remi-6.2 -y
echo -e "\e[36m >>>>>>>> install redis <<<<<<<< \e[0m"
dnf install redis -y
echo -e "\e[36m >>>>>>>> replacing host address <<<<<<<< \e[0m"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf
echo -e "\e[36m >>>>>>>> start redis service <<<<<<<< \e[0m"
systemctl enable redis
systemctl restart redis