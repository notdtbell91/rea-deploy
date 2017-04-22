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

git clone rea-cruitment/simple-sinatra-app:
    git.latest:
        - name: https://github.com/rea-cruitment/simple-sinatra-app.git
        - target: /opt/simple-sinatra-app
        - force_clone: True

bundle install:
    cmd.run:
        - name: bundle install
        - cwd: /opt/simple-sinatra-app
        - watch:
            - git: https://github.com/rea-cruitment/simple-sinatra-app.git
        - require:
            - git clone rea-cruitment/simple-sinatra-app

rackup:
    cmd.run:
        - name: bundle exec rackup -D
        - cwd: /opt/simple-sinatra-app
        - require:
            - bundle install
