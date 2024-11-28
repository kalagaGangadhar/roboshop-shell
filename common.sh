log=/tmp/roboshop.log
echo -e "\e[36m >>>>>>>> copy mongo repo file <<<<<<<< \e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

echo -e "\e[36m >>>>>>>> enable nodejs-18 <<<<<<<< \e[0m"
dnf module disable nodejs -y &>>${log}
dnf module enable nodejs:18 -y &>>${log}

echo -e "\e[36m >>>>>>>> install nodejs <<<<<<<< \e[0m"
dnf install nodejs -y &>>${log}

echo -e "\e[36m >>>>>>>> copy {component} service file <<<<<<<< \e[0m"
cp {component}.service /etc/systemd/system/{component}.service &>>${log}

echo -e "\e[36m >>>>>>>> create user <<<<<<<< \e[0m"
useradd roboshop &>>${log}

echo -e "\e[36m >>>>>>>> remove old content <<<<<<<< \e[0m"
rm -rf /app

echo -e "\e[36m >>>>>>>> download content <<<<<<<< \e[0m"
mkdir /app
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/{component}.zip &>>${log}
cd /app

echo -e "\e[36m >>>>>>>> extract content <<<<<<<< \e[0m"
unzip /tmp/{component}.zip &>>${log}


echo -e "\e[36m >>>>>>>> install dependencies <<<<<<<< \e[0m"
npm install &>>${log}

echo -e "\e[36m >>>>>>>> install mongo-client <<<<<<<< \e[0m"
dnf install mongodb-org-shell -y &>>${log}

echo -e "\e[36m >>>>>>>> load schema to mongodb <<<<<<<< \e[0m"
mongo --host mongodb.kroboshop.online </app/schema/{component}.js &>>${log}

echo -e "\e[36m >>>>>>>> start {component} service <<<<<<<< \e[0m"
systemctl daemon-reload &>>${log}
systemctl enable {component} &>>${log}
systemctl restart {component} &>>${log}
