echo ">>>>>>>>> create catalogue service <<<<<<<<<<"
cp catalogue.service /etc/systemd/system/catalogue.service
echo ">>>>>>>>> create mongo repo <<<<<<<<<<"
cp mongo.repo /etc/yum.repos.d/mongo.repo
echo ">>>>>>>>> disable default nodejs <<<<<<<<<<"
dnf module disable nodejs -y
echo ">>>>>>>>> enable nodejs18 <<<<<<<<<<"
dnf module enable nodejs:18 -y
echo ">>>>>>>>> install nodejs <<<<<<<<<<"
dnf install nodejs -y
echo ">>>>>>>>> add application user <<<<<<<<<<"
useradd roboshop
echo ">>>>>>>>> remove app directory <<<<<<<<<<"
rm -rf /app
echo ">>>>>>>>> making app directory <<<<<<<<<<"
mkdir /app
echo ">>>>>>>>> download catalogue zip file <<<<<<<<<<"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
echo ">>>>>>>>> extract the catalogue zip file <<<<<<<<<<"
cd /app
unzip /tmp/catalogue.zip
echo ">>>>>>>>> install dependencies <<<<<<<<<<"
cd /app
npm install
echo ">>>>>>>>> reload daemon service <<<<<<<<<<"
systemctl daemon-reload
echo ">>>>>>>>> install mongodb shell <<<<<<<<<<"
dnf install mongodb-org-shell -y
echo ">>>>>>>>> load schema to mongodb <<<<<<<<<<"
mongo --host mongodb.groboshop.online </app/schema/catalogue.js
echo ">>>>>>>>> enable catalogue service <<<<<<<<<<"
systemctl enable catalogue
echo ">>>>>>>>> restart catalogue service <<<<<<<<<<"
systemctl restart catalogue
