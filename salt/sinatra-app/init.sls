a2ensite - simple-sinatra-app.conf:
    file.managed:
        - name: /etc/apache2/sites-available/simple-sinatra-app.conf
        - source: salt://sinatra-app/simple-sinatra-app.conf
        - user: root
        - group: root
        - mode: '0644'
        - require:
            - pkg: apache2
    file.symlink:
        - name: /etc/apache2/sites-enabled/simple-sinatra-app.conf
        - target: /etc/apache2/sites-available/simple-sinatra-app.conf
        - require:
            - pkg: apache2
            - file: /etc/apache2/sites-available/simple-sinatra-app.conf

a2enmod - Enable proxy and proxy_http modules:
    apache_module.enabled:
        - names:
            - proxy
            - proxy_http
