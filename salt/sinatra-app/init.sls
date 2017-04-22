/etc/apache2/sites-available/simple-sinatra-app.conf:
    file.managed:
        - source: salt://sinatra-app/simple-sinatra-app.conf
        - user: root
        - group: root
        - mode: '0644'
        - require:
            - pkg: apache2

Enable proxy and proxy_http modules:
    apache_module.enabled:
        - names:
            - proxy
            - proxy_http

Restart Apache2 Service:
    service.running:
        name: apache2
        restart: True
