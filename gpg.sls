
install_gpg:
  pkg.installed:
    - name: {{ pillar['gpg'] }}
