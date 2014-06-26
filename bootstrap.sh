#!/usr/bin/env bash

# Update thy system
apt-get update

# Install required packages
apt-get install -y git python-pip python-virtualenv python-dev
apt-get install -y nginx rubygems
gem install sass
gem install compass

# Installing fresh node from ppa (oh my debian! such stable!)
apt-get install -y software-properties-common python-software-properties
add-apt-repository -y ppa:chris-lea/node.js
apt-get update
apt-get install -y g++ nodejs

# Configure and install database
debconf-set-selections <<< 'mysql-server mysql-server/root_password password pass'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password pass'
apt-get install -y mysql-server libmysqlclient-dev

# Install additional tools
apt-get install -y vim mc zsh curl

# Change shell for vagrant user
chsh -s /usr/bin/zsh vagrant;
sudo -u vagrant echo '# no need to call a wizard!' >> /home/vagrant/.zshrc

# Setup basic vim config
sudo -u vagrant mkdir -p /home/vagrant/.vim/autoload
sudo -u vagrant curl -fLo /home/vagrant/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim

sudo -u vagrant cat > /home/vagrant/.vimrc << EOL
call plug#begin()
Plug 'tpope/vim-sensible'
call plug#end()
EOL

sudo -u vagrant vim +PlugInstall +qall

# Configure services: database and proxy/assets server
mysql -uroot -ppass -e "CREATE DATABASE sms_bank CHARACTER SET utf8 COLLATE utf8_general_ci;"

cat > /etc/nginx/sites-enabled/smsbank << EOL
    server {

        listen 80;
        server_name localhost;

        # serve static files
        location /static/ {
            alias /vagrant/app/etc/static_collected/;
            location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
                expires 30d;
                log_not_found off;
            }
        }

        # reverse-proxy gunicorn server
        location / {
            proxy_pass_header Server;
            proxy_set_header Host \$http_host;
            proxy_redirect off;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Scheme \$scheme;
            proxy_connect_timeout 10;
            proxy_read_timeout 10;
            proxy_pass http://127.0.0.1:8000/;
        }

    }
EOL

service nginx restart
