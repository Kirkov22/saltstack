
{%- from 'psql_ids/map.jinja' import psql_ids with context %}

psql_ids_dir:
  file.directory:
    - name: {{ psql_ids['postgres_cert_path'] }}
    - user: {{ psql_ids['user'] }}
    - group: {{ psql_ids['user'] }}
    - dir_mode: 0700
    - makedirs: True

psql_ids_root_ca:
  file.managed:
    - name: {{ psql_ids['postgres_cert_path'] ~psql_ids['ca_crt_name'] }}
    - contents: |
        {{ pillar['psql_cert_files']['ca'] | indent(width=8, indentfirst=False) }}
    - user: {{ psql_ids['user'] }}
    - group: {{ psql_ids['user'] }}
    - mode: 600
    - require:
      - file: psql_ids_dir

{%- for user in pillar['psql_cert_files']['users'] %}
psql_ids_{{ user['name'] }}_crt:
  file.managed:
    - name: {{ psql_ids['postgres_cert_path'] ~user['name'] ~'/' ~psql_ids['user_crt_name'] }}
    - contents: |
        {{ user['pub'] | indent(width=8, indentfirst=False) }}
    - user: {{ psql_ids['user'] }}
    - group: {{ psql_ids['user'] }}
    - mode: 600
    - makedirs: True
    - dir_mode: 0700
    - require:
      - file: psql_ids_dir

psql_ids_{{ user['name'] }}_key:
  file.managed:
    - name: {{ psql_ids['postgres_cert_path'] ~user['name'] ~'/' ~psql_ids['user_key_name'] }}
    - contents: |
        {{ user['key'] | indent(width=8, indentfirst=False) }}
    - user: {{ psql_ids['user'] }}
    - group: {{ psql_ids['user'] }}
    - mode: 600
    - makedirs: True
    - dir_mode: 0700
    - require:
      - file: psql_ids_dir
{%- endfor %}
