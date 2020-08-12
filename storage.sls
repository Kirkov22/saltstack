
install_zfs:
  pkg.installed:
    - name: {{ pillar['zfs'] }}

{% for service in pillar['nfs_services'] %}
{{service}} running:
  service.running:
    - name: {{ service }}
    - enable: True
    - require:
      - pkg: install_nfs
    - watch:
      - file: sync_exports
{% endfor %}

install_nfs:
  pkg.installed:
    - name: {{ pillar['nfs_server'] }}

sync_exports:
  file.managed:
    - name: /etc/exports
    - source: salt://nfs/exports
    - template: jinja
    - user: root
    - group: root
    - mode: 644

allow NFSv4 (TCP 2049) on LAN:
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

disallow NFSv4 (TCP 2049) from non-LAN:
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
