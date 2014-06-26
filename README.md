#Vagrant development environment for goip-sms-bank

Bootstrapping development environment for Django app.
Based on Ubuntu x64 LTS 12.04 (yuk).

Initialize with:

    cd current-repo/
    mkdir app/
    git clone git@github://django-repo-name app
    vagrant up
    vagrant ssh
    cd /vagrant/app
    ???
    vagrant suspend
    ...
    vagrant destroy

Repository folder is by default shared with vagrant host.
You may clone Django application into app/ (excluded from git) and
initialize it in development environment.

All packages, modules and settings are specified in `bootstrap.sh`.
Guest http port is forwarded to host as `8888` and may be changed in
`Vagrantfile`.
