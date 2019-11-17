#!/bin/bash

cd ../guestbook


sudo apt-get -y update
sudo apt-get -y install python3 python3-venv python3-dev
sudo apt-get -y install supervisor nginx

# env variable setup
python3 -m venv venv
source venv/bin/activate
pip install wheel
pip install -r requirements.txt
SECRET=`python3 -c "import uuid; print(uuid.uuid4().hex)"` 
echo "SECRET_KEY=$SECRET" >> .env
export FLASK_APP=guestbook.py
echo "export FLASK_APP=guestbook.py" >> ~/.profile

# flask db setup !!!!!! TEMP DB SHOULD BE MOVED TO RDS INSTANCE
flask db init
flask db migrate -m "init"
flask db upgrade

cd ../ubuntu_deployment

# flask web setup
sudo cp guestbook.conf.supervisord /etc/supervisor/conf.d/guestbook.conf
sudo supervisorctl reload

#nginx setup
sudo rm /etc/nginx/sites-enabled/default
sudo cp guestbook.nginx /etc/nginx/sites-enabled/guestbook
sudo service nginx reload