echo -e "\e[35m>>>>>>>> create catalogue service <<<<<<<<<\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service>>/tmp/catalogue.log
echo -e "\e[35m>>>>>>>> create mongo repo <<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo>>/tmp/catalogue.log
echo -e "\e[35m>>>>>>>> disable default nodejs <<<<<<<<<\e[0m"
dnf module disable nodejs -y>>/tmp/catalogue.log
echo -e "\e[35m>>>>>>>> enable nodejs18 <<<<<<<<<\e[0m"
dnf module enable nodejs:18 -y>>/tmp/catalogue.log
echo -e "\e[35m>>>>>>>> install nodejs <<<<<<<<<\e[0m"
dnf install nodejs -y>>/tmp/catalogue.log
echo -e "\e[35m>>>>>>>> add application user <<<<<<<<<\e[0m"
useradd roboshop>>/tmp/catalogue.log
echo -e "\e[35m>>>>>>>> remove app directory <<<<<<<<<\e[0m"
rm -rf /app>>/tmp/catalogue.log
echo -e "\e[35m>>>>>>>> making app directory <<<<<<<<<\e[0m"
mkdir /app>>/tmp/catalogue.log
echo -e "\e[35m>>>>>>>> download catalogue zip file <<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip>>/tmp/catalogue.log
echo -e "\e[35m>>>>>>>> extract the catalogue zip file <<<<<<<<<\e[0m"
cd /app>>/tmp/catalogue.log
unzip /tmp/catalogue.zip>>/tmp/catalogue.log
echo -e "\e[35m>>>>>>>> install dependencies <<<<<<<<<\e[0m"
cd /app>>/tmp/catalogue.log
npm install>>/tmp/catalogue.log
echo -e "\e[35m>>>>>>>> reload daemon service <<<<<<<<<\e[0m"
systemctl daemon-reload>>/tmp/catalogue.log
echo -e "\e[35m>>>>>>>> install mongodb shell <<<<<<<<<\e[0m"
dnf install mongodb-org-shell -y>>/tmp/catalogue.log
echo -e "\e[35m>>>>>>>> load schema to mongodb <<<<<<<<<\e[0m"
mongo --host mongodb.groboshop.online </app/schema/catalogue.js>>/tmp/catalogue.log
echo -e "\e[35m>>>>>>>> enable catalogue service <<<<<<<<<\e[0m"
systemctl enable catalogue>>/tmp/catalogue.log
echo -e "\e[35m>>>>>>>> restart catalogue service <<<<<<<<<\e[0m"
systemctl restart catalogue>>/tmp/catalogue.log
