cp user.servie /etc/systemd/system/user.service
cp mongo.repo /etc/yum.repos.d/mongo.repo
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y

useradd roboshop
mkdir /app
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
unzip /tmp/user.zip
cd /app
npm install
systemctl daemon-reload
dnf install mongodb-org-shell -y
mongo --host mongodb.groboshop.online </app/schema/user.js
systemctl enable user
systemctl restart user