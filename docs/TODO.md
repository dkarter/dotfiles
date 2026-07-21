# To Do

## Herdr

- [ ] super-l toggle last workspace like in tmux (mapped to prefix+shift-L)
  - [ ] doesn't look like herdr has that built in right now - could be a pull request
- [ ] show prs with draft status and link
- [ ] open dev dir
- [ ] refactor @bin/herdr-commands to smaller scripts
- [ ] ability to change themes easily and in a synchronized way with: ghostty,
      herdr, nvim, lualine - the key is to have a fuzzy finder that shows a list of
      themes with both light and dark themes and the ability to preview them as I
      scroll (so it reloads all the apps mentioned config - similar to how Omarchy
      does that - maybe we can browse the source). If I abort, it should reset back
      to the previously configured theme. The biggest pain right now is lualine and
      all the tweaks I made to it (which admittedly would be nice to keep).
      Another tricky thing would be making sure themes are supported across all the
      apps in question. Maybe it would require a mapping between them for differences
      in name

# Done

- [x] insert file with super-shift-. with a popup
- [x] it would be cool if there was a way to show the space/worktree title when it's focused
- [x] resize panes with alt+hjkl
- [x] seamless navigation with neovim (like I have in tmux between muxer panes and nvim splits)
- [x] keybinds to navigate spaces and worktrees up and down - ctrl+[/] in herdr, cmd+[/] via ghostty
- [x] vim test integration
- [x] keybind to quickly jump to PR
- [x] better jump to space/worktree - using tv (fuzzy finder) maybe + herdr popup - the built in one is too cluttered because it contains the panes - but I do want to steal the "state" of the agents idea from it
