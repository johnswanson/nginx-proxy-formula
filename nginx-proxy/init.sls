{% from "nginx-proxy/map.jinja" import nginx_proxy with context %}

include:
  - nginx

/etc/nginx/ssl.conf:
  file.managed:
    - source: salt://nginx-proxy/ssl.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 0755

openssl req -x509 -batch -config /etc/nginx/ssl.conf -nodes -days 365 -newkey rsa:1024 -keyout {{ nginx_proxy.key }} -out {{ nginx_proxy.cert }}:
  cmd.run:
    - creates: {{ nginx_proxy.cert }}
    - user: root
    - shell: /bin/bash
    - require:
      - file: /etc/nginx/ssl.conf
    - prereq:
      - file: /etc/nginx/sites-available/proxy.conf
      - pkg: nginx

/etc/nginx/sites-available:
  file.directory:
    - user: www-data
    - group: www-data
    - mode: 0755
    - prereq:
      - pkg: nginx

/etc/nginx/sites-available/proxy.conf:
  file.managed:
    - source: salt://nginx-proxy/proxy.conf
    - template: jinja
    - context:
      port: {{ nginx_proxy.port }}
      key: {{ nginx_proxy.key }}
      cert: {{ nginx_proxy.cert }}
    - user: www-data
    - group: www-data
    - mode: 0755
    - prereq:
      - pkg: nginx

/etc/nginx/sites-enabled/proxy.conf:
  file.symlink:
    - target: /etc/nginx/sites-available/proxy.conf
    - force: false
    - require:
      - file: /etc/nginx/sites-available/proxy.conf
    - prereq:
      - pkg: nginx
