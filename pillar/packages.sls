{% if grains['os_family'] == 'Debian' %}
zfs: zfsutils-linux
nfs_server: nfs-kernel-server
neovim: neovim
git: git

{% elif grains['os_family'] == 'RedHat' %}
zfs:
nfs_server:
neovim:
git:

{% endif %}
