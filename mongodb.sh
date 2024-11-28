echo -e "\e[36m >>>>>>>>> copy Mongo-repo file <<<<<<<<< \e[0m"
p mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[36m >>>>>>>> Install Mongodb <<<<<<<<<<< \e[0m"
dnf install mongodb-org -y
echo -e "\e[36m >>>>>>>> replace Host address <<<<<<<<<< \e[0m"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
echo -e "\e[36m >>>>>>>> start mongod service <<<<<<<<<<< \e[0m"
systemctl enable mongod
systemctl restart mongod