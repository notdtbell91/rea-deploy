ssh:
    service:
        - running
        - enabled: True
        - restart: True
        - watch:
            - file: /etc/ssh/sshd_config

/etc/ssh/sshd_config:
    file.managed:
        - source: salt://ssh/sshd_config
        - user: root
        - group: root
        - mode: '0600'
