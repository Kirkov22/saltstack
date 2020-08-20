base:
  '*':
    - packages
    - user
  'zaphkiel':
    - services
    - shares
  'choir*':
    - k3s_secret
  'choir(0[2-9]|[1-9][0-9]).*':
    - match: pcre
    - k3s
