{% if grains['os_family'] == 'Debian' %}
nfs_services:
  - nfs-server
  - nfs-mountd
  - nfs-idmapd

{% elif grains['os_family'] == 'RedHat' %}
nfs_services:

{% endif %}
