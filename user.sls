
pimary_user_{{ pillar['primary_user']['name'] }}:
  user.present:
    - name: {{ pillar['primary_user']['name'] }}
    - groups:
{% for group in pillar['primary_user']['groups'] %}
      - {{ group }}
{% endfor %}
    - uid: {{ pillar['primary_user']['uid'] }}
    - allow_uid_change: True
    - gid: {{ pillar['primary_user']['gid'] }}
    - allow_gid_change: True
    - password: {{ pillar['primary_user']['password'] }}
    - require:
      - group: {{ pillar['primary_user']['name'] }}_primary_group

{{ pillar['primary_user']['name'] }}_primary_group:
  group.present:
    - name: {{ pillar['primary_user']['primary_group'] }}
    - gid: {{ pillar['primary_user']['gid'] }}

disable_chime:
  file.line:
    - name: /etc/inputrc
    - content: set bell-style none
    - match: set\s+bell-style\s+none
    - mode: replace
