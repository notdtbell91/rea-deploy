apache2:
    pkg:
        - latest
    service:
        - running
        - enable: True
        - restart: True
        - watch:
            - file: /etc/apache2/sites-enabled/*
            - file: /etc/apache2/mods-enabled/*
            - pkg: apache2
