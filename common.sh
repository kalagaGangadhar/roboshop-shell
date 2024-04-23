 log=/tmp/roboshop.log
 func_exit_status() {
   if [ $? -eq 0 ]; then
     echo -e "\e[32m SUCCESS \e[0m"
   else
     echo -e "\e[31m FAILURE \e[0m"
   fi
 }
func_apppreq(){
  echo -e "\e[36m>>>>>>>>>>>>>>>>> copying ${component} service file <<<<<<<<<<<<<<<<<<\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
  func_exit_status
  echo -e "\e[36m>>>>>>>>>>>>>>>>> add user roboshop <<<<<<<<<<<<<<<<<<\e[0m"
  id roboshop &>>${log}
  if [ $? -ne 0 ]; then
    useradd roboshop &>>${log}
  fi
  func_exit_status
  echo -e "\e[36m>>>>>>>>>>>>>>>>> remove old content directory <<<<<<<<<<<<<<<<<<\e[0m"
  rm -rf /app &>>${log}
  func_exit_status
  echo -e "\e[36m>>>>>>>>>>>>>>>>> make app directory <<<<<<<<<<<<<<<<<<\e[0m"
  mkdir /app &>>${log}
  func_exit_status
  echo -e "\e[36m>>>>>>>>>>>>>>>>> download ${component} service content <<<<<<<<<<<<<<<<<<\e[0m"
  curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
  func_exit_status
  cd /app &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>>>>> unzip the content <<<<<<<<<<<<<<<<<<\e[0m"
  unzip /tmp/${component}.zip &>>${log}
  func_exit_status
  cd /app
}


func_systemd(){
  echo -e "\e[36m>>>>>>>>>>>>>>>>> start ${component} service <<<<<<<<<<<<<<<<<<\e[0m"
  systemctl daemon-reload &>>${log}
  systemctl enable ${component} &>>${log}
  systemctl restart ${component} &>>${log}
  func_exit_status
}

func_schema_setup() {
  if [ "${schema_type}" == "mongodb" ]; then
    echo -e "\e[36m>>>>>>>>>>>>  INstall Mongo Client  <<<<<<<<<<<<\e[0m"  | tee -a /tmp/roboshop.log
    yum install mongodb-org-shell -y &>>${log}
    func_exit_status

    echo -e "\e[36m>>>>>>>>>>>>  Load User Schema  <<<<<<<<<<<<\e[0m"  | tee -a /tmp/roboshop.log
    mongo --host mongodb.rdevopsb72.online </app/schema/${component}.js &>>${log}
    func_exit_status
  fi

  if [ "${schema_type}" == "mysql" ]; then
    echo -e "\e[36m>>>>>>>>>>>>  Install MySQL Client   <<<<<<<<<<<<\e[0m"
    yum install mysql -y &>>${log}
    func_exit_status

    echo -e "\e[36m>>>>>>>>>>>>  Load Schema   <<<<<<<<<<<<\e[0m"
    mysql -h mysql.rdevopsb72.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}
    func_exit_status
  fi

}


func_nodejs(){
echo -e "\e[36m>>>>>>>>>>>>>>>>> coping mongo repo file <<<<<<<<<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
func_exit_status
echo -e "\e[36m>>>>>>>>>>>>>>>>> install nodejs <<<<<<<<<<<<<<<<<<\e[0m"
dnf module disable nodejs -y &>>${log}
dnf module enable nodejs:18 -y &>>${log}
dnf install nodejs -y &>>${log}
func_exit_status
func_apppreq
echo -e "\e[36m>>>>>>>>>>>>>>>>> install dependencies <<<<<<<<<<<<<<<<<<\e[0m"
npm install &>>${log}
func_exit_status

func_schema_setup
func_systemd
}

func_java(){
  echo -e "\e[36m>>>>>>>>>>>>>>>>> instal maven <<<<<<<<<<<<<<<<<<\e[0m"
  dnf install maven -y &>>${log}
  func_exit_status
  func_apppreq
  echo -e "\e[36m>>>>>>>>>>>>>>>>> install dependencies <<<<<<<<<<<<<<<<<<\e[0m"
  mvn clean package &>>${log}

  mv target/shipping-1.0.jar ${component}.jar &>>${log}
  func_exit_status
  func_schema_setup
  func_systemd
}

func_python(){
  echo -e "\e[36m>>>>>>>>>>>>>>>>> instal python <<<<<<<<<<<<<<<<<<\e[0m"
  dnf install python36 gcc python3-devel -y &>>${log}
  func_exit_status
  func_apppreq
  sed -i "s/rabbitmq_app_password/${rabbitmq_app_password}" /etc/systemd/system/${component}.service
  echo -e "\e[36m>>>>>>>>>>>>>>>>> install dependencies <<<<<<<<<<<<<<<<<<\e[0m"
  pip3.6 install -r requirements.txt &>>${log}
  func_exit_status
  func_systemd

}

func_golang(){
  echo -e "\e[36m>>>>>>>>>>>>>>>>> instal go lang <<<<<<<<<<<<<<<<<<\e[0m"
  dnf install golang -y &>>${log}
  func_exit_status
  func_apppreq
  echo -e "\e[36m>>>>>>>>>>>>>>>>> install dependencies <<<<<<<<<<<<<<<<<<\e[0m"
  go mod init dispatch &>>${log}
  go get &>>${log}
  go build &>>${log}
  func_exit_status
  func_systemd
}