apache2:
    pkg:
        - latest
    service:
        - running
        - enable: True
        - restart: True
        - watch:
            - file: /etc/apache2/sites-enabled/*
            - a2enmod *
            - pkg: apache2
    file:
        - absent
        - name: /etc/apache2/sites-enabled/000-default.conf
