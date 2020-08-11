install neovim:
  pkg.installed:
    - name: neovim

clone neovim git repo:
  git.latest:
    - name: https://github.com/Kirkov22/neovim.git
    - target: /home/kirkov/.config/nvim
    - rev: HEAD
    - branch: master
    - user: kirkov
