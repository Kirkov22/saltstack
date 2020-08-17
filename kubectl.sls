
setup_kubernetes_repo:
  pkgrepo.managed:
{% if grains['os_family'] == 'Debian' %}
    - name: deb https://apt.kubernetes.io/ kubernetes-xenial main
    - file: /etc/apt/sources.list.d/kubernets.list
    - key_url: https://packages.cloud.google.com/apt/doc/apt-key.gpg
    - refresh: True
{% endif %}

install_kubectl:
  pkg.installed:
    - name: kubectl
    - require:
      - pkgrepo: setup_kubernetes_repo

