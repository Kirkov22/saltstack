
setup_azlux_repo:
  pkgrepo.managed:
{% if grains['os_family'] == 'Debian' %}
    - name: deb http://packages.azlux.fr/debian/ buster main
    - file: /etc/apt/sources.list.d/azlux.list
    - key_url: https://azlux.fr/repo.gpg.key
    - refresh: True
{% endif %}

install_log2ram:
  pkg.installed:
    - name: log2ram
    - require:
      - pkgrepo: setup_azlux_repo

log2ram_running:
  service.running:
    - name: log2ram
    - enable: True
    - require:
      - pkg: install_log2ram
