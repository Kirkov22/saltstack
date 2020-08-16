k3s:
  req_pkgs:
    - curl
    - tar
    - gzip
  script:
    path: /tmp
    name: k3s-bootstrap.sh
    source: https://get.k3s.io
    source_hash: 4ec34d9075cb2d040aab5400638cb7e51ab8601ebf9a520983546e0c3851d36b4e6829e4ebf5cd709a82aef78cd3bab1c6ca55a050d89c1849ddbbc042c4014e
