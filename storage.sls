
install_zfs:
  pkg.installed:
    - name: zfsutils-linux

nfs server running:
  service.running:
    - name: nfs-server
    - enable: True
    - require:
      - pkg: install_nfs

nfs mount service running:
  service.running:
    - name: nfs-mountd
    - enable: True
    - require:
      - pkg: install_nfs

nfs v4 map service running:
  service.running:
    - name: nfs-idmapd
    - enable: True
    - require:
      - pkg: install_nfs

install_nfs:
  pkg.installed:
    - name: nfs-kernel-server

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
