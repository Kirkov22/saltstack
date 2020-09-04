base:
  '*':
    - packages
    - user
  'zaphkiel':
    - services
    - shares
    - samba
  'choir*':
    - k3s_secret
    - shares
    - psql_ids
  'choir(0[2-9]|[1-9][0-9]).*':
    - match: pcre
    - k3s
