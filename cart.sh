echo -e "\e[36m >>>>>>>> copy service file <<<<<<<< \e[0m"
cp cart.service /etc/systemd/system/cart.service

echo -e "\e[36m >>>>>>>> enable nodejs-18 <<<<<<<< \e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y

echo -e "\e[36m >>>>>>>> install nodejs <<<<<<<< \e[0m"
dnf install nodejs -y

echo -e "\e[36m >>>>>>>> copy service file <<<<<<<< \e[0m"
cp cart.service /etc/systemd/system/cart.service

echo -e "\e[36m >>>>>>>> create user <<<<<<<< \e[0m"
useradd roboshop

echo -e "\e[36m >>>>>>>> download content <<<<<<<< \e[0m"
mkdir /app
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app

echo -e "\e[36m >>>>>>>> exract content <<<<<<<< \e[0m"
unzip /tmp/cart.zip


echo -e "\e[36m >>>>>>>> install dependencies <<<<<<<< \e[0m"
npm install

echo -e "\e[36m >>>>>>>> start cart service <<<<<<<< \e[0m"
systemctl daemon-reload
systemctl enable cart
systemctl restart cart
