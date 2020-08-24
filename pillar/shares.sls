{#
Each share should have the following contents
  - comment: <This value is not used>
    host: < Hostname for the NFS share>
    path: <Path to the NFS share>
    mnt: < Mountpoint for NFS clients>
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
    host: zaphkiel.orchid.street
    path: /tank/nextcloud
    mnt: /mnt/nextcloud
    hosts:
      - 192.168.2.51
      - 192.168.2.52
      - 192.168.2.53
    options:
      - rw
      - sync
      - root_squash
      - no_subtree_check
