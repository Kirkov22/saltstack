
flush_iptables:
  iptables.flush:
    - table: filter
    - family: ipv4
    - onchanges:
      - alternatives: set_legacy_iptables

flush_ip6tables:
  iptables.flush:
    - table: filter
    - family: ipv6
    - onchanges:
      - alternatives: set_legacy_ip6tables

set_legacy_iptables:
  alternatives.set:
    - name: iptables
    - path: /usr/sbin/iptables-legacy

set_legacy_ip6tables:
  alternatives.set:
    - name: ip6tables
    - path: /usr/sbin/ip6tables-legacy

{%- from 'k3s/map.jinja' import k3s with context %}

k3s_postgres_keys_dir:
  file.directory:
    - name: {{ k3s['postgres_path'] }}
    - user: {{ k3s['user']['name'] }}
    - group: {{ k3s['user']['name'] }}
    - dir_mode: 0700
    - makedirs: True

k3s_postgres_keys_ca:
  file.managed:
    - name: {{ k3s['postgres_path'] ~'/ca.crt' }}
    - contents: |
        {{ pillar['k3s_secret']['psql_certs']['ca'] | indent(width=8, indentfirst=False) }}
    - user: {{ k3s['user']['name'] }}
    - group: {{ k3s['user']['name'] }}
    - mode: 600
    - require:
      - file: k3s_postgres_keys_dir

k3s_postgres_keys_user:
  file.managed:
    - name: {{ k3s['postgres_path'] ~'/user.crt' }}
    - contents: |
        {{ pillar['k3s_secret']['psql_certs']['user_pub'] | indent(width=8, indentfirst=False) }}
    - user: {{ k3s['user']['name'] }}
    - group: {{ k3s['user']['name'] }}
    - mode: 600
    - require:
      - file: k3s_postgres_keys_dir

k3s_postgres_keys_user_key:
  file.managed:
    - name: {{ k3s['postgres_path'] ~'/user.key' }}
    - contents: |
        {{ pillar['k3s_secret']['psql_certs']['user_key'] | indent(width=8, indentfirst=False) }}
    - user: {{ k3s['user']['name'] }}
    - group: {{ k3s['user']['name'] }}
    - mode: 600
    - require:
      - file: k3s_postgres_keys_dir

k3s_prerequisites:
  pkg.installed:
    - names: {{ k3s['req_pkgs']|json }}

  file.directory:
    - name: {{ k3s['script']['path'] }}
    - user: {{ k3s['user']['name'] }}
    - group: {{ k3s['user']['name'] }}
    - mode: '0777'
    - makedirs: True
    - require:
      - pkg: k3s_prerequisites

k3s_script_downloaded:
  file.managed:
    - name: {{ k3s['script']['path'] ~'/' ~k3s['script']['name'] }}
    - source: {{ k3s['script']['source'] }}
    - source_hash: {{ k3s['script']['source_hash'] }}
    - user: {{ k3s['user']['name'] }}
    - group: {{ k3s['user']['name'] }}
    - mode: 744
    - require:
      - file: k3s_prerequisites

k3s_set_env_vars:
  file.managed:
    - name: /etc/environment
    - contents: |
{%- for var, value in k3s['env_vars'].items() %}
        {{ var }}='{{ value }}'
{%- endfor %}

k3s_clean_script:
  file.absent:
    - name: {{ k3s['script']['path'] ~'/' ~k3s['script']['name'] }}
    - onfail:
      - file: k3s_script_downloaded

k3s_install:
  cmd.run:
    - name: {{ k3s['script']['path'] ~'/' ~k3s['script']['name'] }}
    - unless: systemctl list-unit-files | grep -Fq 'k3s'
    - env:
    {%- for var, value in k3s['env_vars'].items() %}
      - {{ var }}: {{ value|yaml_encode }}
    {%- endfor %}
    - require:
      - pkg: k3s_prerequisites
      - file: k3s_script_downloaded
      - file: k3s_postgres_keys_ca
      - file: k3s_postgres_keys_user
      - file: k3s_postgres_keys_user_key

