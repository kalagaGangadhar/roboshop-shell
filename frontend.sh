source common.sh
echo -e "\e[36m>>>>>>>>>>>>> install nginx <<<<<<<<<<<<<\e[0m"
dnf install nginx -y &>>${log}
func_exit_status
echo -e "\e[36m>>>>>>>>>>>>> configure roboshop file <<<<<<<<<<<<<\e[0m"
cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log}
func_exit_status
echo -e "\e[36m>>>>>>>>>>>>> remove defaut content <<<<<<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/* &>>${log}
func_exit_status
echo -e "\e[36m>>>>>>>>>>>>> download frontend content <<<<<<<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}
func_exit_status
echo -e "\e[36m>>>>>>>>>>>>> move to nginx dir <<<<<<<<<<<<<\e[0m"
cd /usr/share/nginx/html &>>${log}
func_exit_status
echo -e "\e[36m>>>>>>>>>>>>> unzip the content <<<<<<<<<<<<<\e[0m"
unzip /tmp/frontend.zip &>>${log}
func_exit_status
echo -e "\e[36m>>>>>>>>>>>>> start the service <<<<<<<<<<<<<\e[0m"
systemctl enable nginx &>>${log}
systemctl restart nginx &>>${log}
func_exit_status