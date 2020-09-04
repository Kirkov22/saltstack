
{%- from 'samba/map.jinja' import samba with context %}

{%- for pkg in samba['pkgs'] %}
samba_install_{{ pkg }}:
  pkg.installed:
    - name: {{ pkg }}

{%- endfor %}

samba_share_config:
  file.managed:
    - name: {{ samba['share_file'] }}
    - source: salt://samba/smb.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: True

samba_import_config:
  file.append:
    - name: /etc/samba/smb.conf
    - text: include={{ samba['share_file'] }}
    - require:
      {%- for pkg in samba['pkgs'] %}
        - pkg: samba_install_{{ pkg }}
      {%- endfor %}

samba_service:
  service.running:
    - name: {{ samba['service'] }}
    - require:
      {%- for pkg in samba['pkgs'] %}
        - pkg: samba_install_{{ pkg }}
      {%- endfor %}
    - watch:
      - file: samba_share_config
      - file: samba_import_config

samba_iptables_allow_lan:
  iptables.append:
  - table: filter
  - chain: INPUT
  - jump: ACCEPT
  - match:
    - state
    - tcp
    - comment
  - connstate: NEW,ESTABLISHED,RELATED
  - source: '192.168.2.0/24'
  - dports:
    - 139
    - 445
  - protocol: tcp
  - comment: "Allow local SMB"
  - save: True

samba_iptables_disallow_wan:
  iptables.append:
  - table: filter
  - chain: INPUT
  - jump: DROP
  - match:
    - comment
  - connstate: NEW
  - source: 'not 192.168.2.0/24'
  - dports:
    - 139
    - 445
  - protocol: tcp
  - comment: "Drop non-local SMB"
  - save: True
