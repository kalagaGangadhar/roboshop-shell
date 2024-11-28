echo -e "\e[36m >>>>>>>> copy mongo repo file <<<<<<<< \e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m >>>>>>>> enable nodejs-18 <<<<<<<< \e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y

echo -e "\e[36m >>>>>>>> install nodejs <<<<<<<< \e[0m"
dnf install nodejs -y

echo -e "\e[36m >>>>>>>> copy service file <<<<<<<< \e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[36m >>>>>>>> create user <<<<<<<< \e[0m"
useradd roboshop

echo -e "\e[36m >>>>>>>> download content <<<<<<<< \e[0m"
mkdir /app
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo -e "\e[36m >>>>>>>> extract content <<<<<<<< \e[0m"
unzip /tmp/catalogue.zip


echo -e "\e[36m >>>>>>>> install dependencies <<<<<<<< \e[0m"
npm install

echo -e "\e[36m >>>>>>>> install mongo-client <<<<<<<< \e[0m"
dnf install mongodb-org-shell -y

echo -e "\e[36m >>>>>>>> load schema to mongodb <<<<<<<< \e[0m"
mongo --host mongodb.kroboshop.online </app/schema/catalogue.js

echo -e "\e[36m >>>>>>>> start catalogue service <<<<<<<< \e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue
