log=/tmp/roboshop.log

func_appprereq(){
  echo -e "\e[35m>>>>>>>> create ${component} service <<<<<<<<<\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
  echo -e "\e[35m>>>>>>>> add application user <<<<<<<<<\e[0m"
  useradd roboshop &>>${log}
  echo -e "\e[35m>>>>>>>> cleaning up existing content <<<<<<<<<\e[0m"
  rm -rf /app &>>${log}
  echo -e "\e[35m>>>>>>>> making app directory <<<<<<<<<\e[0m"
  mkdir /app &>>${log}
  echo -e "\e[35m>>>>>>>> download ${component} zip file <<<<<<<<<\e[0m"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
  echo -e "\e[35m>>>>>>>> extract the ${component} zip file <<<<<<<<<\e[0m"
  cd /app &>>${log}
  unzip /tmp/${component}.zip &>>${log}
  cd /app &>>${log}
}

func_systemd(){
  echo -e "\e[35m>>>>>>>> start ${component} service <<<<<<<<<\e[0m"
  systemctl daemon-reload &>>${log}
  systemctl enable ${component} &>>${log}
  systemctl restart ${component} &>>${log}
}

func_nodejs(){

  echo -e "\e[35m>>>>>>>> create mongo repo <<<<<<<<<\e[0m"
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
  echo -e "\e[35m>>>>>>>> disable default nodejs <<<<<<<<<\e[0m"
  dnf module disable nodejs -y &>>${log}
  echo -e "\e[35m>>>>>>>> enable nodejs18 <<<<<<<<<\e[0m"
  dnf module enable nodejs:18 -y &>>${log}
  echo -e "\e[35m>>>>>>>> install nodejs <<<<<<<<<\e[0m"
  dnf install nodejs -y &>>${log}
  echo -e "\e[35m>>>>>>>> install dependencies <<<<<<<<<\e[0m"
  func_appprereq
  npm install &>>${log}
  echo -e "\e[35m>>>>>>>> install mongodb shell <<<<<<<<<\e[0m"
  dnf install mongodb-org-shell -y &>>${log}
  echo -e "\e[35m>>>>>>>> load schema to mongodb <<<<<<<<<\e[0m"
  mongo --host mongodb.groboshop.online </app/schema/${component}.js &>>${log}
  func_systemd
}

func_java(){
  echo -e "\e[35m>>>>>>>> install maven <<<<<<<<<\e[0m"
  dnf install maven -y
  func_appprereq
  echo -e "\e[35m>>>>>>>> install dependencies <<<<<<<<<\e[0m"
  mvn clean package
  mv target/shipping-1.0.jar shipping.jar
  dnf install mysql -y
  mysql -h mysql.groboshop.online -uroot -pRoboShop@1 < /app/schema/shipping.sql
  func_systemd
}

func_python(){
  echo -e "\e[35m>>>>>>>> install python <<<<<<<<<\e[0m"
  dnf install python36 gcc python3-devel -y
  func_appprereq
  echo -e "\e[35m>>>>>>>> install dependencies <<<<<<<<<\e[0m"
  pip3.6 install -r requirements.txt
  func_systemd
}

func_golang(){
  echo -e "\e[35m>>>>>>>> install golang <<<<<<<<<\e[0m"
  dnf install golang -y
  func_appprereq
  echo -e "\e[35m>>>>>>>> install dependencies <<<<<<<<<\e[0m"
  go mod init dispatch
  go get
  go build
  func_systemd
}