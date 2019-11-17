#!/bin/bash

cd ../guestbook


sudo apt-get -y update
sudo apt-get -y install python3 python3-venv python3-dev
sudo apt-get -y install supervisor nginx

# env variable setup
python3 -m venv venv
pip install -r requirements.txt
pip install gunicorn pymysql
SECRET=`python3 -c "import uuid; print(uuid.uuid4().hex)"` 
echo "SECRET_KEY=$SECRET" >> .env
# echo "DATABASE_URL=mysql+pymysql://guestbook:temppassword@localhost:3306/guestbook" >> ../guestbook/.env
echo "export FLASK_APP=guestbook.py" >> ~/.profile

# flask db setup !!!!!! TEMP DB SHOULD BE MOVED TO RDS INSTANCE
flask db init
flask db migrate -m "init"
flask db upgrade

cd ../ubuntu_deployment

# gunicorn setup
sudo mv guestbook.conf.supervisord /etc/supervisor/conf.d/guestbook.conf
sudo supervisorctl reload

#nginx setup
sudo rm /etc/nginx/sites-enabled/default
sudo mv guestbook.nginx /etc/nginx/sites-enabled/guestbook
sudo service nginx reload
