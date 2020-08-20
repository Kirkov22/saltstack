base:
  '*':
    - packages
    - user
  'zaphkiel':
    - services
    - shares
  'choir*':
    - k3s
    - k3s_secret
    - postgres_keys
  'choir(0[2-9]|[1-9][0-9]).*':
    - match: pcre
    - k3s_node
