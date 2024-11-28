echo -e "\e[36m >>>>>>>> install maven <<<<<<<< \e[0m"
dnf install maven -y
echo -e "\e[36m >>>>>>>> copy service file <<<<<<<< \e[0m"
cp shipping.service /etc/systemd/system/shipping.service
echo -e "\e[36m >>>>>>>> create user <<<<<<<< \e[0m"
useradd roboshop
echo -e "\e[36m >>>>>>>> download content <<<<<<<< \e[0m"
mkdir /app
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app
echo -e "\e[36m >>>>>>>> extract content <<<<<<<< \e[0m"
unzip /tmp/shipping.zip
cd /app
echo -e "\e[36m >>>>>>>> install dependencies  <<<<<<<< \e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar
echo -e "\e[36m >>>>>>>> install mysql-client <<<<<<<< \e[0m"
dnf install mysql -y
echo -e "\e[36m >>>>>>>> Load schema <<<<<<<< \e[0m"
mysql -h mysql.kroboshop.online -uroot -pRoboShop@1 < /app/schema/shipping.sql
echo -e "\e[36m >>>>>>>> start shipping service  <<<<<<<< \e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl start shipping