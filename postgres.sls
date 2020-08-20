

setup_postgres_repo:
  pkgrepo.managed:
{% if grains['os_family'] == 'Debian' %}
    - name: deb http://apt.postgresql.org/pub/repos/apt/ focal-pgdg main
    - file: /etc/apt/sources.list.d/postgres.list
    - key_url: https://www.postgresql.org/media/keys/ACCC4CF8.asc
    - refresh: True
{% endif %}

install_postgres_server:
  pkg.latest:
    - name: postgresql-12
    - require:
      - pkgrepo: setup_postgres_repo

set_data_location:
  file.line:
    - name: /etc/postgresql/12/main/postgresql.conf
    - content: data_directory = '/tank/postgres/postgresql/12/main'
    - match: data_directory
    - mode: replace

postgres_enable_tls:
  file.line:
    - name: /etc/postgresql/12/main/postgresql.conf
    - content: ssl = on #enables TLS
    - match: ssl\s*=\s*
    - mode: replace

postgres_tls_set_ca:
  file.line:
    - name: /etc/postgresql/12/main/postgresql.conf
    - content: ssl_ca_file = '/tank/postgres/auth/ca.crt'
    - match: ssl_ca_file
    - mode: replace

postgres_tls_set_cert:
  file.line:
    - name: /etc/postgresql/12/main/postgresql.conf
    - content: ssl_cert_file = '/tank/postgres/auth/zaphkiel-postgres.crt'
    - match: ssl_cert_file
    - mode: replace

postgres_tls_set_key:
  file.line:
    - name: /etc/postgresql/12/main/postgresql.conf
    - content: ssl_key_file = '/tank/postgres/auth/zaphkiel-postgres.key'
    - match: ssl_key_file
    - mode: replace
