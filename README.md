#Vagrant devenv for goip-sms-bank

Bootstrapping development environment for Django app.
Based on Ubuntu x64 LTS 12.04 (yuk).

Initialize with:

    cd current-repo/
    vagrant up

Then, get app to work with:

    mkdir app/
    git clone git@github://django-repo-name app

Login to development environment and setup web application:

    vagrant ssh
    cd /vagrant/app
    virtualenv venv
    source venv/bin/activate
    pip install -r requirements/dev.txt
    ./manage.py syncdb
    ./manage.py migrate

Build frontend modules:

    cd etc
    npm install
    ./node_modules/.bin/bower install
    ./node_modules/.bin/grunt build
    cd ..
    ./manage.py collectstatic

Launch application (without supervisor):

    gunicorn smsbank.wsgi

Suspend or destroy VM:

    vagrant suspend
    vagrant destroy

Repository folder is by default shared with vagrant host.
You may clone Django application into app/ (excluded from git) and
initialize it in development environment.

All packages, modules and settings are specified in `bootstrap.sh`.
Guest http port is forwarded to host as `8888` and may be changed in
`Vagrantfile`.

You may also initialize app via Makefile tasks (not tested for Ubuntu).
