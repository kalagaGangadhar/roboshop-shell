echo -e "\e[36m >>>>>>>> copy service file <<<<<<<< \e[0m"
cp dispatch.service /etc/systemd/system/dispatch.service

echo -e "\e[36m >>>>>>>> install golang <<<<<<<< \e[0m"
dnf install golang -y

echo -e "\e[36m >>>>>>>> create user <<<<<<<< \e[0m"
useradd roboshop

echo -e "\e[36m >>>>>>>> download content <<<<<<<< \e[0m"
mkdir /app
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
cd /app

echo -e "\e[36m >>>>>>>> extract content <<<<<<<< \e[0m"
unzip /tmp/dispatch.zip
cd /app

echo -e "\e[36m >>>>>>>> install dependencies <<<<<<<< \e[0m"
go mod init dispatch
go get
go build

echo -e "\e[36m >>>>>>>> start dispatch service <<<<<<<< \e[0m"
systemctl daemon-reload
systemctl enable dispatch
systemctl start dispatch