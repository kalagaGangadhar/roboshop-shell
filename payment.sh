echo -e "\e[36m >>>>>>>> copy mongo repo file <<<<<<<< \e[0m"
cp payment.service /etc/systemd/system/payment.service
echo -e "\e[36m >>>>>>>> Install python <<<<<<<< \e[0m"
dnf install python36 gcc python3-devel -y
echo -e "\e[36m >>>>>>>> create user <<<<<<<< \e[0m"
useradd roboshop
echo -e "\e[36m >>>>>>>> download content <<<<<<<< \e[0m"
mkdir /app
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app
echo -e "\e[36m >>>>>>>> extract content  <<<<<<<< \e[0m"
unzip /tmp/payment.zip
cd /app
echo -e "\e[36m >>>>>>>> Install dependencies <<<<<<<< \e[0m"
pip3.6 install -r requirements.txt
echo -e "\e[36m >>>>>>>> start payment service <<<<<<<< \e[0m"
systemctl daemon-reload
systemctl enable payment
systemctl start payment