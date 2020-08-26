
{%- from 'helm/map.jinja' import helm with context %}

{%- for pkg in helm['req_pkgs'] %}
helm_install_{{ pkg }}:
  pkg.installed:
    - name: {{ pkg }}

{%- endfor %}

{%- if helm['repo']['source'] != '' %}
helm_repo:
  pkgrepo.managed:
    - name: {{ helm['repo']['source'] }}
    - file: /etc/apt/sources.list.d/{{ helm['repo']['list_file'] }}
    - key_url: {{ helm['key'] }}
    - refresh: True
{% endif %}

helm_install:
  pkg.installed:
    - name: {{ helm['pkg'] }}
    - require:
      {%- if helm['repo']['source'] != '' %}
        - pkgrepo: helm_repo
      {%- endif %}
      {%- for pkg in helm['req_pkgs'] %}
        - pkg: helm_install_{{ pkg }}
      {%- endfor %}

