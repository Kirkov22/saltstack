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
