apache2:
    pkg:
        - latest
    service:
        - running
        - enable: True
        - restart: True
        - watch:
            - a2enmod *
            - file: /etc/apache2/sites-enabled/*
            - file: /etc/apache2/sites-available/*
            - pkg: apache2
    file:
        - absent
        - name: /etc/apache2/sites-enabled/000-default.conf
