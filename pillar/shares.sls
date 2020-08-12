{#
Each share should have the following contents
  - comment: <This value is not used>
    path: <Path to the NFS share>
    hosts:
      - <Hostname / IP / IP Range #1>
      - ...
      - <Hostname / IP / IP Range #N>
    options:
      - <NFS option #1>
      - ...
      - <NFS option #N>
#}

shares:
  - comment: nextcloud
    path: /tank/nextcloud
    hosts:
      - 192.168.2.51
    options:
      - rw
      - sync
      - root_squash
      - no_subtree_check
