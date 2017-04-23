/etc/apache2/sites-available/simple-sinatra-app.conf:
    file.managed:
        - source: salt://sinatra-app/simple-sinatra-app.conf
        - user: root
        - group: root
        - mode: '0644'
        - require:
            - pkg: apache2

/etc/apache2/sites-enabled/simple-sinatra-app.conf:
    file.symlink:
        - target: /etc/apache2/sites-available/simple-sinatra-app.conf
        - require:
            - pkg: apache2
            - file: /etc/apache2/sites-available/simple-sinatra-app.conf

a2enmod - Enable proxy and proxy_http modules:
    apache_module.enabled:
        - names:
            - proxy
            - proxy_http

ruby-bundler:
    pkg:
        - latest

/opt/rea-cruitment:
    file.directory:
        - user: www-data
        - group: www-data
        - makedirs: True

git clone rea-cruitment/simple-sinatra-app:
    git.latest:
        - name: https://github.com/rea-cruitment/simple-sinatra-app.git
        - target: /opt/rea-cruitment/simple-sinatra-app
        - user: www-data
        - force_clone: True
        - require:
            - file: /opt/rea-cruitment

bundle install:
    cmd.run:
        - name: bundle install
        - cwd: /opt/rea-cruitment/simple-sinatra-app
        - runas: www-data
        - watch:
            - git: https://github.com/rea-cruitment/simple-sinatra-app.git
        - require:
            - git clone rea-cruitment/simple-sinatra-app
            - pkg: ruby-bundler

simple-sinatra-app_unit:
    file.managed:
        - name: /etc/systemd/system/simple-sinatra-app.service
        - source: salt://sinatra-app/simple-sinatra-app.service
    module.run:
        - name: service.systemctl_reload
        - onchanges:
            - file: simple-sinatra-app_unit

simple-sinatra-app_running:
    service.running:
        - name: simple-sinatra-app
        - watch:
            - module: simple-sinatra-app_unit
