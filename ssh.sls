include:
  - user

{{ pillar['primary_user']['name'] }}_ssh_key:
  ssh_auth.present:
    - name: AAAAC3NzaC1lZDI1NTE5AAAAIGoEEXa1YW2nRoZPX+oiUGypye793R2hxx5+ZXIDCiam
    - user: {{ pillar['primary_user']['name'] }}
    - enc: ed25519
    - comment: Uriel-2020-08-14
    - require:
      - sls: user

sshd_running:
  service.running:
    - name: sshd
    - enable: True
    - watch:
      - file: ssh_disable_cleartext_pw

ssh_disable_cleartext_pw:
  file.line:
    - name: /etc/ssh/sshd_config
    - content: PasswordAuthentication no
    - match: PasswordAuthentication
    - mode: replace
