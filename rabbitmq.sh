echo -e "\e[36m >>>>>>>> rabbimq script rpm file <<<<<<<< \e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
echo -e "\e[36m >>>>>>>> Install rabbimq <<<<<<<< \e[0m"
dnf install rabbitmq-server -y
echo -e "\e[36m >>>>>>>> Start rabbimq service <<<<<<<< \e[0m"
systemctl enable rabbitmq-server
systemctl start rabbitmq-server
echo -e "\e[36m >>>>>>>> adding roboshop user and permissions <<<<<<<< \e[0m"
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"