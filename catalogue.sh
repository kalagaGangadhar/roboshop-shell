cp catalogue.servie /etc/systemd/system/catalogue.service
cp mongo.repo /etc/yum.repos.d/mongo.repo
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y

useradd roboshop
mkdir /app
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip
cd /app
npm install
systemctl daemon-reload
dnf install mongodb-org-shell -y
mongo --host mongodb.groboshop.online </app/schema/catalogue.js
systemctl enable catalogue
systemctl restart catalogue