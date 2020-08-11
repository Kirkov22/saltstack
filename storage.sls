
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
