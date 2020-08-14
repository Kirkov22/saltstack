
install neovim:
  pkg.installed:
    - name: {{ pillar['neovim'] }}

install_git:
  pkg.installed:
    - name: {{ pillar['git'] }}

clone neovim git repo:
  git.latest:
    - name: https://github.com/Kirkov22/neovim.git
    - target: /home/kirkov/.config/nvim
    - rev: HEAD
    - branch: master
    - user: kirkov
    - require:
      - sls: user
