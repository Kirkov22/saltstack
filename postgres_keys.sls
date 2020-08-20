
/auth:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 0700

{%- set cert = pillar['psql_cert_files'] %}
/auth/ca.crt:
  file.managed:
    - contents: |
        {{ cert['ca'] | indent(width=8, indentfirst=False) }}
    - user: root
    - group: root
    - mode: 600
    - require:
      - file: /auth

{%- for user in cert['users'] %}
/auth/{{ user['name'] }}.crt:
  file.managed:
    - contents: |
        {{ user['pub'] | indent(width=8, indentfirst=False) }}
    - user: root
    - group: root
    - mode: 600
    - require:
      - file: /auth

/auth/{{ user['name'] }}.key:
  file.managed:
    - contents: |
        {{ user['key'] | indent(width=8, indentfirst=False) }}
    - user: root
    - group: root
    - mode: 600
    - require:
      - file: /auth
{%- endfor %}
