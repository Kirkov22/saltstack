
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

{%- set k = pillar['k3s'] %}
install_k3s_prerequisites:
  pkg.installed:
    - names: {{ k['req_pkgs']|json }}
    - require_in:
      - file: install_k3s_prerequisites

  file.directory:
    - name: {{ k['script']['path'] }}
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True
    - require:
      - pkg: install_k3s_prerequisites

k3s_script_downloaded:
  file.managed:
    - name: {{ k['script']['path'] ~'/' ~k['script']['name'] }}
    - source: {{ k['script']['source'] }}
    - source_hash: {{ k['script']['source_hash'] }}
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: install_k3s_prerequisites

clean_k3s_script:
  file.absent:
    - name: {{ k['script']['path'] ~'/' ~k['script']['name'] }}
    - onfail:
      - file: k3s_script_downloaded

install_k3s:
  cmd.run:
    - name: {{ k['script']['path'] ~'/' ~k['script']['name'] }}
    - unless: systemctl list-unit-files | grep -Fq 'k3s'
    - require:
      - file: k3s_script_downloaded
