echo -e "\e[36m>>>>>>>>>>>>  Install Nginx   <<<<<<<<<<<<\e[0m"
dnf install nginx -y

echo -e "\e[36m>>>>>>>>>>>>  Copy RoboShop Configuration  <<<<<<<<<<<<\e[0m"
cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[36m>>>>>>>>>>>>  Clean Old content  <<<<<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[36m>>>>>>>>>>>>  Download Application Content   <<<<<<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html

echo -e "\e[36m>>>>>>>>>>>>  Extract Application Content  <<<<<<<<<<<<\e[0m"
unzip /tmp/frontend.zip

echo -e "\e[36m>>>>>>>>>>>>  Start Nginx Service  <<<<<<<<<<<<\e[0m"
systemctl enable nginx
systemctl start nginx