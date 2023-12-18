echo -e "\e[35m>>>>>>>> create catalogue service <<<<<<<<<\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service
echo -e "\e[35m>>>>>>>> create mongo repo <<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[35m>>>>>>>> disable default nodejs <<<<<<<<<\e[0m"
dnf module disable nodejs -y
echo -e "\e[35m>>>>>>>> enable nodejs18 <<<<<<<<<\e[0m"
dnf module enable nodejs:18 -y
echo -e "\e[35m>>>>>>>> install nodejs <<<<<<<<<\e[0m"
dnf install nodejs -y
echo -e "\e[35m>>>>>>>> add application user <<<<<<<<<\e[0m"
useradd roboshop
echo -e "\e[35m>>>>>>>> remove app directory <<<<<<<<<\e[0m"
rm -rf /app
echo -e "\e[35m>>>>>>>> making app directory <<<<<<<<<\e[0m"
mkdir /app
echo -e "\e[35m>>>>>>>> download catalogue zip file <<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
echo -e "\e[35m>>>>>>>> extract the catalogue zip file <<<<<<<<<\e[0m"
cd /app
unzip /tmp/catalogue.zip
echo -e "\e[35m>>>>>>>> install dependencies <<<<<<<<<\e[0m"
cd /app
npm install
echo -e "\e[35m>>>>>>>> reload daemon service <<<<<<<<<\e[0m"
systemctl daemon-reload
echo -e "\e[35m>>>>>>>> install mongodb shell <<<<<<<<<\e[0m"
dnf install mongodb-org-shell -y
echo -e "\e[35m>>>>>>>> load schema to mongodb <<<<<<<<<\e[0m"
mongo --host mongodb.groboshop.online </app/schema/catalogue.js
echo -e "\e[35m>>>>>>>> enable catalogue service <<<<<<<<<\e[0m"
systemctl enable catalogue
echo -e "\e[35m>>>>>>>> restart catalogue service <<<<<<<<<\e[0m"
systemctl restart catalogue
