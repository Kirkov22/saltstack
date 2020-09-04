{%- from 'nfs/map.jinja' import nfs with context %}
{%- if nfs['role']=='server' %}

{%- for pkg in nfs['server-pkgs'] %}
nfs_install_{{ pkg }}:
  pkg.installed:
    - name: {{ pkg }}
{%- endfor %}

nfs_exports_file:
  file.managed:
    - name: {{ nfs['exports_file'] }}
    - source: salt://nfs/exports
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      {%- for pkg in nfs['server-pkgs'] %}
      - pkg: nfs_install_{{ pkg }}
      {%- endfor %}

{%- for service in nfs['services'] %}
nfs_service_{{ service }}:
  service.running:
    - name: {{ service }}
    - enable: True
    - require:
      {%- for pkg in nfs['server-pkgs'] %}
      - pkg: nfs_install_{{ pkg }}
      {%- endfor %}
    - watch:
      - file: nfs_exports_file
{%- endfor %}

nfs_allow_lan:
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
  - dport: 2049
  - protocol: tcp
  - comment: "Allow local NFSv4"
  - save: True

nfs_disallow_wan:
  iptables.append:
  - table: filter
  - chain: INPUT
  - jump: DROP
  - match:
    - comment
  - connstate: NEW
  - source: 'not 192.168.2.0/24'
  - dport: 2049
  - protocol: tcp
  - comment: "Drop non-local NFSv4"
  - save: True

{%- elif nfs['role']=='client' %}

{%- for pkg in nfs['client-pkgs'] %}
nfs_install_{{ pkg }}:
  pkg.installed:
    - name: {{ pkg }}
{%- endfor %}

{%- for share in nfs['shares'] %}
nfs_shares_{{ share['comment'] }}:
  mount.mounted:
    - name: {{ share['mnt'] }}
    - device: {{ share['host'] ~':' ~share['path'] }}
    - fstype: nfs4
    - mkmnt: True
    - mount: True
    - persist: True
    - config: {{ nfs['fstab_path'] }}
    - user: root
    - require:
      {%- for pkg in nfs['client-pkgs'] %}
      - pkg: nfs_install_{{ pkg }}
      {%- endfor %}
{%- endfor %}

{%- endif %}
