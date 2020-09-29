
{%- from 'postgres/map.jinja' import psql with context %}

postgres_setup_repo:
  pkgrepo.managed:
    - name: {{ psql.repo.name }}
    - file: {{ psql.repo.file }}
    - key_url: {{ psql.repo.key_url }}
    - refresh: True

postgres_install_server:
  pkg.latest:
    - name: {{ psql.pkg }}
    - require:
      - pkgrepo: postgres_setup_repo

postgres_set_data_location:
  file.line:
    - name: /etc/postgresql/{{ psql.version }}/main/postgresql.conf
    - content: data_directory = {{ psql.data_location }}
    - match: data_directory
    - mode: replace

postgres_enable_tls:
  file.line:
    - name: /etc/postgresql/{{ psql.version }}/main/postgresql.conf
    - content: ssl = on #enables TLS
    - match: ssl\s*=\s*
    - mode: replace

postgres_tls_set_ca:
  file.line:
    - name: /etc/postgresql/{{ psql.version }}/main/postgresql.conf
    - content: ssl_ca_file = '/tank/postgres/auth/ca.crt'
    - match: ssl_ca_file
    - mode: replace

postgres_tls_set_cert:
  file.line:
    - name: /etc/postgresql/{{ psql.version }}/main/postgresql.conf
    - content: ssl_cert_file = '/tank/postgres/auth/zaphkiel-postgres.crt'
    - match: ssl_cert_file
    - mode: replace

postgres_tls_set_key:
  file.line:
    - name: /etc/postgresql/{{ psql.version }}/main/postgresql.conf
    - content: ssl_key_file = '/tank/postgres/auth/zaphkiel-postgres.key'
    - match: ssl_key_file
    - mode: replace

postgres_stop_service:
  cmd.run:
    - name: service postgresql stop
    - prereq:
      - file: postgres_remove_initd

postgres_remove_initd:
  file.absent:
    - name: /etc/init.d/postgresql

postgres_service:
  service.running:
    - name: {{ psql.service }}
    - enable: True
    - require:
      - file: postgres_remove_initd
