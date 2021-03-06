base:
  '*':
    - packages
    - user
  'zaphkiel':
    - services
    - samba
    - k3s_secret
    - k3s
  'choir*':
    - k3s_secret
    - psql_ids
    - nfs
  'choir(0[2-9]|[1-9][0-9]).*':
    - match: pcre
    - k3s
