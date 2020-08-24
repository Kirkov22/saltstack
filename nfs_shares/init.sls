
{%- from 'nfs_shares/map.jinja' import shares with context %}

nfs_required_pkg:
  pkg.installed:
    - pkgs:
      {%- for pkg in shares['required_pkgs'] %}
      - {{ pkg }}
      {%- endfor %}

{%- for share in pillar['shares'] %}
nfs_shares_{{ share['comment'] }}:
  mount.mounted:
    - name: {{ share['mnt'] }}
    - device: {{ share['host'] ~':' ~share['path'] }}
    - fstype: nfs4
    - mkmnt: True
    - mount: True
    - persist: True
    - config: {{ shares['fstab_path'] }}
    - require:
      - pkg: nfs_required_pkg

{%- endfor %}
