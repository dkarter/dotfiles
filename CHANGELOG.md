# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

## [28.0.0](https://github.com/dkarter/dotfiles/compare/v27.1.0...v28.0.0) (2026-01-06)


### ⚠ BREAKING CHANGES

* **yazi:** improve tv plugin to accept channels
* **nvim:** change ClaudeCode mappings to match open code

### Features

* add gbsum - git branch summary ([1fd102c](https://github.com/dkarter/dotfiles/commit/1fd102cf2a2dfc06588cf35a1ebcd75ff64eac72))
* **brew:** add ffmpeg + ffmpegthumbnailer ([b81721f](https://github.com/dkarter/dotfiles/commit/b81721f0175fcc24ea1265c824676f5d73031f07))
* **hyprland,walkr:** automatic migration update from Omarchy ([b9f896c](https://github.com/dkarter/dotfiles/commit/b9f896c9b8b16f757f561d3ffc7a22490cb8f445))
* **mise:** add 7zip ([b314e25](https://github.com/dkarter/dotfiles/commit/b314e2533ce5bafbfd416a1a923b69d7b2a0ff29))
* **mise:** add lnr (linear cli) ([5f829c2](https://github.com/dkarter/dotfiles/commit/5f829c2a8bd33bff4654e0a9ab85f4b313c2c61b))
* **mise:** add resvg ([293e7fa](https://github.com/dkarter/dotfiles/commit/293e7fa91deebdf041bff6e7bc5cfc2388467c56))
* **mise:** add yazi file manager ([3abab98](https://github.com/dkarter/dotfiles/commit/3abab98b9025334b6324a262504dbab0bd7167f9))
* **nvim:** add yazi.nvim ([fc93e0a](https://github.com/dkarter/dotfiles/commit/fc93e0a796087621f5b6fee1970cd971da17a738))
* **task:** add yazi tasks to setup scripts ([6a63fa9](https://github.com/dkarter/dotfiles/commit/6a63fa92e5b47656cf9c6e45b9159ff3d34fc30e))
* **tmux,ghostty:** fuzzy insert file at cursor for AI agents ([73a1cfc](https://github.com/dkarter/dotfiles/commit/73a1cfc514a61b2c054e81e6be593d8f35b6ad09))
* **tmux:** add shallow clone option to tmux-fork-repo ([d144e24](https://github.com/dkarter/dotfiles/commit/d144e24b0b89a1b1f075099167dbe701b025eeca))
* **tv:** add `tv brew` ([7a1db7d](https://github.com/dkarter/dotfiles/commit/7a1db7d515d01f68e5f8d0c0c6b74c444512bc1d))
* **tv:** add tv channel completion with ctrl+t ([c118add](https://github.com/dkarter/dotfiles/commit/c118addcd2ae49f281e02cfb73f58a77a7a09127))
* **tv:** add tv elixir-modules channel ([101e4ce](https://github.com/dkarter/dotfiles/commit/101e4ce36a42075d04a2482340e9de705b523988))
* **tv:** add zoxide tv channel ([ea9d9ee](https://github.com/dkarter/dotfiles/commit/ea9d9ee945c6b0fb34576cf27cfe92a70e0ac820))
* **yazi:** add default config ([06e99ee](https://github.com/dkarter/dotfiles/commit/06e99eed066c5097d6e87cf458870a07649602bf))
* **yazi:** replace fzf plugin with tv plugin ([45a2f62](https://github.com/dkarter/dotfiles/commit/45a2f6230f1f12140a1316eeff7ee05e536835a9))
* **yazi:** use catppuccin-mocha theme ([9d34895](https://github.com/dkarter/dotfiles/commit/9d34895b81b07c9ee4b3ebc540c7e9ddb74b27d0))
* **zsh:** add alias for tailscale from MAS ([73e3c8a](https://github.com/dkarter/dotfiles/commit/73e3c8a7a00c91f2c67450d19130ff1f1fce3a1f))
* **zsh:** add alias for tv git-diff (tgd) ([5e80e82](https://github.com/dkarter/dotfiles/commit/5e80e8268ee391cf3c74112cd02b1a3f0ee291b8))
* **zsh:** add mise install alias (mi) ([7886571](https://github.com/dkarter/dotfiles/commit/78865710695b4f13bc01f8955f76029b82ed4345))
* **zsh:** add opencode completions ([87c5c08](https://github.com/dkarter/dotfiles/commit/87c5c088237af84fd256e13f9866886e3deb4290))
* **zsh:** add tt alias ([e6cf9da](https://github.com/dkarter/dotfiles/commit/e6cf9da0ec56b9c5552844af88179a540f115a63))
* **zsh:** add yazi alias (y) ([1b08cc9](https://github.com/dkarter/dotfiles/commit/1b08cc996c063d44e97f7babb5b43d2725ed757e))


### Bug Fixes

* expand TPM_DIR to prevent dangerous ~ dir from getting created ([ed9b66a](https://github.com/dkarter/dotfiles/commit/ed9b66a3f3af1e1b02a294b6cc6e85a220caead0))
* **git:** ignore local claude files in nested dirs ([d6ad76d](https://github.com/dkarter/dotfiles/commit/d6ad76d4964513c6efb0b1db4481905c61772254))
* **hypr:** conflicts with tmux + ghostty workflow ([170f3c9](https://github.com/dkarter/dotfiles/commit/170f3c97d5c095a35179273d06e842c403ef0bdf))
* **mise:** add postinstall hook for installing git hooks ([b487f82](https://github.com/dkarter/dotfiles/commit/b487f828d154bb3c85bc57b12ab9c32a24609422))
* **mise:** switch most ubi -&gt; github backend ([84eb8f7](https://github.com/dkarter/dotfiles/commit/84eb8f77bb4379f83ec4697e38186ad68029dd11))
* **mise:** ubi -&gt; github ([95e0d1e](https://github.com/dkarter/dotfiles/commit/95e0d1ee0a61ce8f101e0a88f8b8dde5bd0086cc))
* **mise:** update deprecated settings title ([9133e80](https://github.com/dkarter/dotfiles/commit/9133e80406307fb0ed75cae01ceb7b054c112319))
* **nvim:** add &lt;leader&gt;as for sending to claude code in normal mode ([3ccb16a](https://github.com/dkarter/dotfiles/commit/3ccb16ace1c845b721ae61d08fb0efd828a922a7))
* **nvim:** auto detect syntax for bun executable scripts ([b81e966](https://github.com/dkarter/dotfiles/commit/b81e9668f98303af0a7f00afeb416300d90fb513))
* **nvim:** remove unused mappings for claude code ([fc01ef5](https://github.com/dkarter/dotfiles/commit/fc01ef5135855125a96311e50d681d230cef19b8))
* **starship:** set memory usage threshold to 90% ([d5e7335](https://github.com/dkarter/dotfiles/commit/d5e733538f2dc93f335944a92ad7839cf8bf080a))
* **tmux:** disable annoying tmux-fingers install wizard ([8a088b0](https://github.com/dkarter/dotfiles/commit/8a088b0e053a65f3e507e77e783a1459ab0e08c9))
* **tv:** add aliases to shell_integration.channel_triggers ([6878dd0](https://github.com/dkarter/dotfiles/commit/6878dd0ecc526c0018f1c5e6da08aa73db1fea3e))
* **tv:** add ga and gap aliases to triggers ([beb5c16](https://github.com/dkarter/dotfiles/commit/beb5c166bda8da0c4bd653b5eb8380d6bf3ad483))
* **tv:** improve git-diff channel to show untracked files ([bfb4760](https://github.com/dkarter/dotfiles/commit/bfb4760bcff2c098b7e64071f66189366a9d47ae))
* **tv:** zsh-history was not returning results ([b9da1b7](https://github.com/dkarter/dotfiles/commit/b9da1b75e7187395e1d9cfe0ecf64b111bd3f80e))
* **v:** lint error ([a45d21f](https://github.com/dkarter/dotfiles/commit/a45d21f7c3e3898cde95ab4477acc7f4510b688e))
* **yazi:** add smart-enter for more intuitive enter ([fff9e36](https://github.com/dkarter/dotfiles/commit/fff9e3603d7631d9367a875287c27e49fc3d100b))
* **yazi:** improve tv plugin to accept channels ([1496c29](https://github.com/dkarter/dotfiles/commit/1496c29de03f407bd905442bee752a354dc28c08))
* **yazi:** show hidden files by default ([649d049](https://github.com/dkarter/dotfiles/commit/649d04988616bd30b87af2117cd12a5e24d5c8c3))
* **zsh:** bump pgtmp postgres to v18 ([e3204f0](https://github.com/dkarter/dotfiles/commit/e3204f0f351996f09de42b57eccf9155b4282bff))
* **zsh:** improve ls aliases ([4bba5eb](https://github.com/dkarter/dotfiles/commit/4bba5eb1ee55fae1b3035ff4b5ba953d73b0dd81))


### Performance Improvements

* **mise:** use wireman from ubi ([92d5c6d](https://github.com/dkarter/dotfiles/commit/92d5c6dde3fecede248117253a290b6fb20d04f2))


### Code Refactoring

* **nvim:** change ClaudeCode mappings to match open code ([f3e2d06](https://github.com/dkarter/dotfiles/commit/f3e2d067b09a1576cc1b1572159ecc41d73ad4da))

## [27.1.0](https://github.com/dkarter/dotfiles/compare/v27.0.0...v27.1.0) (2025-12-24)


### Features

* **nvim:** add ability to toggle elixir map keys ([11c9ffe](https://github.com/dkarter/dotfiles/commit/11c9ffe1ab150ba239310bd7ed7c1d2c25d52beb)), closes [#65](https://github.com/dkarter/dotfiles/issues/65)
* **nvim:** add Elixir deep map key toggle + mapping ([b99717a](https://github.com/dkarter/dotfiles/commit/b99717a0a77008e12163149d48cecfeadbf11d05))


### Bug Fixes

* **nvim:** disable built in UI for claudecode nvim ([031895a](https://github.com/dkarter/dotfiles/commit/031895ac57f4ca109d131e2de527408f428607e5))
* **task:** gh:release task stopped working ([cb57a97](https://github.com/dkarter/dotfiles/commit/cb57a979ae072ddd3ed613449c8fb0bd646ca5f6))

## [27.0.0](https://github.com/dkarter/dotfiles/compare/v26.1.0...v27.0.0) (2025-12-23)


### ⚠ BREAKING CHANGES

* **nvim:** add more snacks.nvim mappings

### Features

* **arch:** add hyprland + walker configs ([5c21430](https://github.com/dkarter/dotfiles/commit/5c214302eae89091753c89256f4304881ac5256e))
* **brew:** add Ghostty ([2adacc9](https://github.com/dkarter/dotfiles/commit/2adacc9808aac61a1ed02b3a2f359959508627cb))
* **elephant:** add config ([a407b5d](https://github.com/dkarter/dotfiles/commit/a407b5d7f634c7b49a7aafade854619088e942d8))
* **ghostty,tmux:** add cmd-shift-o -&gt; tmux-open-dev-dir ([33878ee](https://github.com/dkarter/dotfiles/commit/33878eead47b6ad6eba40dc1bf2ea8a1448e1407))
* **homebrew:** add updated sudo-touchid package with tmux support ([7a617a2](https://github.com/dkarter/dotfiles/commit/7a617a29a77d5225b049f48245ddb02bded71208))
* **mise:** add html2markdown cli ([507e361](https://github.com/dkarter/dotfiles/commit/507e361543c629386f533de5d30bd5de1beda32d))
* **mise:** add nushell ([725b946](https://github.com/dkarter/dotfiles/commit/725b9460b6b08ee630a0c9fd9f29750aa2e16563))
* **mise:** add redis alias ([a91986e](https://github.com/dkarter/dotfiles/commit/a91986e6794d9170c61a50b32a2f860ae7e51ec4))
* **nushell:** add basic config ([e4d1035](https://github.com/dkarter/dotfiles/commit/e4d1035d8bac8a63e7d7644ab38246b57511cb16))
* **nushell:** add gaa alias ([eefde97](https://github.com/dkarter/dotfiles/commit/eefde973f899f6cb83fbdc14e0b37b3d0764f9ac))
* **nushell:** add local env loading ([aaf3cb3](https://github.com/dkarter/dotfiles/commit/aaf3cb3bc6ccc76c71a09f261c1c805fa69c3947))
* **nushell:** improve nushell config ([d4ab2de](https://github.com/dkarter/dotfiles/commit/d4ab2de0e7e3ed9d7b2bc5675fc9dd095ada0d24))
* **nvim:** add embedded language lsp support ([de6a5d4](https://github.com/dkarter/dotfiles/commit/de6a5d4227e5a02ee4aaea9375c12b01fc45304b))
* **nvim:** add injections for mise tasks ([38f132d](https://github.com/dkarter/dotfiles/commit/38f132da67d713d354e749310ba3f9f2c1796345))
* **nvim:** add more snacks.nvim mappings ([371465a](https://github.com/dkarter/dotfiles/commit/371465ae952130f7f601b7f7df7ce091c0ca0c8a))
* **nvim:** improve opencode integration ([72612e5](https://github.com/dkarter/dotfiles/commit/72612e50d66531c79162e2c8c4f53708409fc96e))
* **opencode:** add vim compatible keybindings for scrolling ([bba5115](https://github.com/dkarter/dotfiles/commit/bba5115f4e622893b78263edf9ede20286ae35ec))
* **opencode:** support transparent background ([835cbff](https://github.com/dkarter/dotfiles/commit/835cbfffd6dba0201bad326a257aca6d29346f98))
* **starship:** improve prompt ([568d734](https://github.com/dkarter/dotfiles/commit/568d734e8b21fc94baaf86e81a5fc24d8d25d769))
* **task:** add basic arch linux support (Omarchy) ([622f325](https://github.com/dkarter/dotfiles/commit/622f325a1fb5a9df47075d900adeb773d169736c))
* **task:** add task to install rosetta 2 ([0a5b9ee](https://github.com/dkarter/dotfiles/commit/0a5b9ee2a57ef70543f3978f6e812f75c66a1e3b))
* **tmux:** improve tmux-new-session, create a dir if not exists ([9d6ccae](https://github.com/dkarter/dotfiles/commit/9d6ccaef986d924676f5d770179e764257263488))
* **tv:** add dev-dirs ([69e407f](https://github.com/dkarter/dotfiles/commit/69e407f816625f4d66fa170c12e4eae6839439e8))
* **tv:** add tv fuzzy finder and replace zsh fzf integration ([0c7b689](https://github.com/dkarter/dotfiles/commit/0c7b689660b8c840c4a798aef766ab25231e609f))
* **zsh,tmux,ghostty:** add linear issue creation support ([d7d8eda](https://github.com/dkarter/dotfiles/commit/d7d8eda8d399d6db5cfe2fb9f31917bde83921ce))
* **zsh:** add bat completions ([e2ad27d](https://github.com/dkarter/dotfiles/commit/e2ad27d1ba2d6509533b955e9feb8f802503e48d))
* **zsh:** add completions for ripgrep ([e494f5c](https://github.com/dkarter/dotfiles/commit/e494f5c22520a373732acbb1e0de47fd0bed49ed))
* **zsh:** add completions for sesh ([4000ef4](https://github.com/dkarter/dotfiles/commit/4000ef4015430d14be13175de6123c20f2b7bc9c))
* **zsh:** add mdcurl command - curl webpages as markdown ([4f3bcd4](https://github.com/dkarter/dotfiles/commit/4f3bcd4019ddfadcd1946a9357dbd3efd6e92576))
* **zsh:** add tmux-open-dev-dir script ([f944ab1](https://github.com/dkarter/dotfiles/commit/f944ab12b164d5a4d7afb8f41346d3aa687e7d25))
* **zsh:** add vimhelp command ([f22739d](https://github.com/dkarter/dotfiles/commit/f22739d8a5c6b4e778c81a900c7f910bf3b2741f))


### Bug Fixes

* **arch:** add lsof ([a186b20](https://github.com/dkarter/dotfiles/commit/a186b20f4713ebc0a913420258ee3b5f1e7ed2f0))
* **arch:** add missing packages for erlang ([9e2e50f](https://github.com/dkarter/dotfiles/commit/9e2e50f9db88095ae29ad79a44bce3c1b70db30d))
* **arch:** update settings for latest omarchy ([f72ac93](https://github.com/dkarter/dotfiles/commit/f72ac93b1edca9ddaffe434cc774a4c36e6e2c63))
* **claude:** improve formatting of neovim-lua-expert description ([11e8e3f](https://github.com/dkarter/dotfiles/commit/11e8e3fde9742a43402fc8b82322377ddfd3d6aa))
* **hypr:** add missing/incorrect unbinds ([a460f88](https://github.com/dkarter/dotfiles/commit/a460f883333ef3ed4b019e9bb5d1a89db4a09083))
* **hypr:** keybindings typo and move unbind to top ([b329d23](https://github.com/dkarter/dotfiles/commit/b329d232556c719beb18a52285d8e0fcaaf401ce))
* **hypr:** more sensible keybinds for moving windows ([41bf35e](https://github.com/dkarter/dotfiles/commit/41bf35ead9361ac0d64427eb91a1147c6ef3bc94))
* **hypr:** properly unbind existing bindings ([0c33ee8](https://github.com/dkarter/dotfiles/commit/0c33ee8569b2d846b7bec79ec487208a4c8d4611))
* **lazygit:** auto-migrate config ([2890b20](https://github.com/dkarter/dotfiles/commit/2890b2075344a33942d02a17509a707a9673035a))
* **mise:** improve Apple Silicon support ([b27c7af](https://github.com/dkarter/dotfiles/commit/b27c7af362a737b45b78dbb035fe0d5c136e6690))
* **mise:** use committed from ubi ([1f20c19](https://github.com/dkarter/dotfiles/commit/1f20c1972c88122d2cf0ffeb413ac7d3b0a39121))
* **nushell:** local loading ([c1f563d](https://github.com/dkarter/dotfiles/commit/c1f563d090067951db3a869ec6ee0da8d2edf0b5))
* **nushell:** restore macos builtin open ([03a9965](https://github.com/dkarter/dotfiles/commit/03a99658a61e8056289471e7bd46d18a07454e72))
* **nvim:** add border to oil popup ([f35aca7](https://github.com/dkarter/dotfiles/commit/f35aca7a3eaf51fd55a2a0a8ed27e9105149fc6c))
* **nvim:** only load mise injections in mise files ([fad0f25](https://github.com/dkarter/dotfiles/commit/fad0f25cc146a977da3223c11944e7a666d02bcd))
* **nvim:** open claude code diffs in new tab ([025e226](https://github.com/dkarter/dotfiles/commit/025e226e92973c8ea9a3d3b2a1b41c66802a6862))
* **nvim:** update repo for mini.bracketed ([a5d37b2](https://github.com/dkarter/dotfiles/commit/a5d37b2eeaf7c29e86322439a689837262166abb))
* **nvim:** use dprint to format zsh when configured ([9e4e447](https://github.com/dkarter/dotfiles/commit/9e4e44790b5c174026204b742fefb84b7074c393))
* **opencode:** add editor_open mapping + remove new line mapping ([8704a1e](https://github.com/dkarter/dotfiles/commit/8704a1e3db17ffa6bec5e7147d68c52f5949dcd8))
* **opencode:** use opencode-transparent as the theme ([5e7fc23](https://github.com/dkarter/dotfiles/commit/5e7fc2350c2f5a50a6978084384560815627340a))
* **ripgrep:** fix web type wildcard + remove rails config ([24df70e](https://github.com/dkarter/dotfiles/commit/24df70ee7bfe8c720b9175aea30f47f3418c8314))
* **ripgrep:** make ripgrep always show hidden files ([6e6c246](https://github.com/dkarter/dotfiles/commit/6e6c24607da4737625e89e69225bb2973a484899))
* **ripgrep:** update fe type and rename to web ([f3390c8](https://github.com/dkarter/dotfiles/commit/f3390c881bd0a2fff6a7a0cf5b42b3c734598c67))
* **task:** add arch:sync to task sync ([b8113e6](https://github.com/dkarter/dotfiles/commit/b8113e69b7e4cca9f9f21c9525753a25c9ee4504))
* **task:** default shell support for arch linux ([c1c9508](https://github.com/dkarter/dotfiles/commit/c1c95086acba9e850300137e513b13928c27fd8c))
* **task:** make comp:generate more robust ([12c7de0](https://github.com/dkarter/dotfiles/commit/12c7de0a2278455ab36cce8bac007cbff5a0715e))
* **task:** zsh default shell fix for macos ([b5aae6a](https://github.com/dkarter/dotfiles/commit/b5aae6a9edd5766f0cc9100235b0955a9d53aa85))
* **typos:** ignore commands in toml files for tv ([d264649](https://github.com/dkarter/dotfiles/commit/d264649fbdda3f3c6b189e00d3578d75b08b6800))
* **walker:** auto update ([931c27a](https://github.com/dkarter/dotfiles/commit/931c27ab85a50b6a521ae62e6f2d703477aebc54))
* **walker:** remove unused options ([64d17ad](https://github.com/dkarter/dotfiles/commit/64d17ad39b95a1ee3936f8466d2aa9d6aadd0566))
* **zinit:** remove unused configs ([87340a3](https://github.com/dkarter/dotfiles/commit/87340a30f5536114fb40f9f062d2cc420fac0da7))
* **zsh:** use less instead of bat for paginating treep ([c3ca7ec](https://github.com/dkarter/dotfiles/commit/c3ca7ec7c7fd9db8d3a342a314363dd7f7b6606a))

## [26.1.0](https://github.com/dkarter/dotfiles/compare/v26.0.0...v26.1.0) (2025-11-03)


### Features

* **nvim:** add mappings for new Snacks gh (github) feature ([0409d10](https://github.com/dkarter/dotfiles/commit/0409d10dfe41702c9d8d190b2460c51e9058cd04))


### Bug Fixes

* **ci:** add build deps ([42a132d](https://github.com/dkarter/dotfiles/commit/42a132d6950884286050ac77ad6172a2448cc855))
* hard-coded paths should ~ / $HOME when possible ([#373](https://github.com/dkarter/dotfiles/issues/373)) ([aff43b6](https://github.com/dkarter/dotfiles/commit/aff43b694d8758e95268b57786ef25388a8d0c66))
* **mise:** add missing plugins (lua + rebar) ([2a41354](https://github.com/dkarter/dotfiles/commit/2a41354bfff43ab9115f9e57315c0eaef96c046f))
* **mise:** use mise forks for lua + rebar asdf plugins ([4153a97](https://github.com/dkarter/dotfiles/commit/4153a972e2faf0d7c495b8eba44cd783fcedd582)), closes [#375](https://github.com/dkarter/dotfiles/issues/375)

## [26.0.0](https://github.com/dkarter/dotfiles/compare/v25.1.0...v26.0.0) (2025-11-01)


### ⚠ BREAKING CHANGES

* **nvim:** remove ethersync
* **nvim:** add <leader>!! for running markdown code blocks
* **nvim:** correct mapping conflict for treesitter text-objects

### Features

* **ghostty:** add shader animation for v1.2.0 ([48280b5](https://github.com/dkarter/dotfiles/commit/48280b581eabc2dd6512a12d780d8992a038b645))
* **ghostty:** allow desktop notifications ([076caa6](https://github.com/dkarter/dotfiles/commit/076caa645f52db9b8fba89c0d712d5fc55832b67))
* **mise:** add opencode ([9534c2d](https://github.com/dkarter/dotfiles/commit/9534c2d64d03faa055b96fd75a6993c1d14659a6))
* **nvim:** add &lt;leader&gt;!! for running markdown code blocks ([530ad63](https://github.com/dkarter/dotfiles/commit/530ad636791cc3078e8dda3c180b5c7b29a541d7))
* **nvim:** add new picker mappings ([9445358](https://github.com/dkarter/dotfiles/commit/944535846e7fb4a208db7bac317e5fd371499541))
* **nvim:** add notif for &lt;leader&gt;bo ([4bc25df](https://github.com/dkarter/dotfiles/commit/4bc25df732bcf0dc6347d77660116e45eb02ceeb))
* **nvim:** add rest client (Kulala) ([9127760](https://github.com/dkarter/dotfiles/commit/9127760836a0d4d5a7ab69bd41b1a33706807be4))
* **nvim:** add ssh_config treesitter ([811c33b](https://github.com/dkarter/dotfiles/commit/811c33b98d2d38c84bc340d55ac8c988c58c18c8))
* **nvim:** format zsh files with shfmt ([356f554](https://github.com/dkarter/dotfiles/commit/356f5549fd8c9a31be1e1d3d36ee3bf6eb59b2a1))
* **opencode:** add pair programming agent ([6c8d485](https://github.com/dkarter/dotfiles/commit/6c8d485952e1a28edf30c99e9b485157ab479a34))
* **task:** add banner to install and sync ([0ff4e36](https://github.com/dkarter/dotfiles/commit/0ff4e36f24f9731227d1afac9cd5f955a6a864d9))
* **tmux,ghostty:** add mapping for forking repos in new session ([63809eb](https://github.com/dkarter/dotfiles/commit/63809eb533ee22e127cf6c13195f40be15a761ae))
* **tmux,ghostty:** add new session keybind (super+shift+N) ([82f56c5](https://github.com/dkarter/dotfiles/commit/82f56c5c03e309343f1bda45eb314f5dc99702bb))
* **zsh:** add another alias for mise registry + fzf ([9317373](https://github.com/dkarter/dotfiles/commit/931737367fd6d4caba889eedcd0e50237d27f9ae))
* **zsh:** add completions for bun ([0ce43c9](https://github.com/dkarter/dotfiles/commit/0ce43c9cee6b3674dc8b4b4e05b91370990be4f0))
* **zsh:** add gwip alias ([2b6ddec](https://github.com/dkarter/dotfiles/commit/2b6ddec0432319e39370ebf499a37873225dd0c7))
* **zsh:** add helm completions ([7de141b](https://github.com/dkarter/dotfiles/commit/7de141bbea0507e9b2bad5d45b161024fe9787fa))
* **zsh:** set nvim as default MANPAGER program ([#370](https://github.com/dkarter/dotfiles/issues/370)) ([3ff7258](https://github.com/dkarter/dotfiles/commit/3ff725811c44e8c19e0da033bc50f23620634f5a))


### Bug Fixes

* **ci:** remove package name from release please ([3c6ff68](https://github.com/dkarter/dotfiles/commit/3c6ff68f21034ccc817d34cd2a2b40c5554f570a))
* **ci:** update location of release please action ([19bd15b](https://github.com/dkarter/dotfiles/commit/19bd15b2afa069311de10b036f7a19b5cdf1a117))
* **ghostty:** add padding to account for macOS Tahoe ([745aa35](https://github.com/dkarter/dotfiles/commit/745aa35a3578e5603ea2b8f2069db3fb9dfa5828))
* **ghostty:** correct casing for theme name ([fd48caf](https://github.com/dkarter/dotfiles/commit/fd48caffaa87276ff72151cebcc5906334815c35))
* **ghostty:** numeric shortcuts stopped working ([7c0aff0](https://github.com/dkarter/dotfiles/commit/7c0aff0f351eea61bcdce5057eda13c1509c7a69))
* **ghostty:** theme name was incompatible ([bf8fd62](https://github.com/dkarter/dotfiles/commit/bf8fd62514b5d501eb56d4e8c7b7ab0462ba03ad))
* **git:** ignore .expert folder ([bbd27fa](https://github.com/dkarter/dotfiles/commit/bbd27fad2db53c486d765ce383446b14a4de4b1f))
* **git:** ignore all .local.json files in .claude ([5dfdbd9](https://github.com/dkarter/dotfiles/commit/5dfdbd9df78c04d9aeb452605f3962cc7a8748dd))
* **mise:** remove ethersync ([b72ed7f](https://github.com/dkarter/dotfiles/commit/b72ed7ff4654f6c6f0e7e28f8f706dfcceb724dc))
* **nvim:** correct mapping conflict for treesitter text-objects ([401608b](https://github.com/dkarter/dotfiles/commit/401608beb5464cb65a87013643cc67ba9129cb41))
* **nvim:** correctly setup LSPs with after + fix ts_ls ([1048615](https://github.com/dkarter/dotfiles/commit/10486155c7a14d8a9af63dd04f9157baa0930967))
* **nvim:** enable float for diagnostics ([478d6bf](https://github.com/dkarter/dotfiles/commit/478d6bf76a9f79debd5633a74d99911829dfa03e))
* **nvim:** enable hidden files by default on dashboard mappings ([74b11c8](https://github.com/dkarter/dotfiles/commit/74b11c81b440079dfb399c1e343076db2aa54ce4))
* **nvim:** make file finder always show hidden files ([26ceea7](https://github.com/dkarter/dotfiles/commit/26ceea7886b6368e36eb56ee1680f6d6487714fa))
* **nvim:** map json api content type to json in kulala ([291e231](https://github.com/dkarter/dotfiles/commit/291e23154a41378b7b74f8603b85357bbf830e80))
* **nvim:** neogen stopped working ([24562d5](https://github.com/dkarter/dotfiles/commit/24562d5e34ff449ca1399f72ac66a746ec7980bb))
* **nvim:** prevent deno lsp from loading incorrectly ([132e6dc](https://github.com/dkarter/dotfiles/commit/132e6dc7db2d789925624e361ff2bfdebeb4db9c))
* **nvim:** remove ethersync ([7693e4d](https://github.com/dkarter/dotfiles/commit/7693e4db4d81d79ba7c92488d247a4a51c9d4e2f))
* **nvim:** replace cmp for dadbod with blink ([5338f2e](https://github.com/dkarter/dotfiles/commit/5338f2e2511bada6397a10f6892ed9631cdbbd26))
* **tmux:** correct typo in tmux-fork-repo script ([0dcc0a9](https://github.com/dkarter/dotfiles/commit/0dcc0a9e206783a70500709bdeedc482c47f8916))
* **zsh,mise,gh:** add github token from gh to env vars ([7988be0](https://github.com/dkarter/dotfiles/commit/7988be0967a46750f2e63524f76abdfd160c1f67))

## [25.1.0](https://github.com/dkarter/dotfiles/compare/v25.0.0...v25.1.0) (2025-08-24)


### Features

* **nvim:** enable exit save confirmation on modified buffers ([b41cd5c](https://github.com/dkarter/dotfiles/commit/b41cd5c5f1a199b9d449050f95e663c49f2298f0))
* **zsh:** add mise registry search alias (mrs) ([75f1a5e](https://github.com/dkarter/dotfiles/commit/75f1a5e1d359c305f39a60c2148c5acbc78a961a))


### Bug Fixes

* **mise:** disable asdf backend, remove pnpm as default ([e1e2812](https://github.com/dkarter/dotfiles/commit/e1e281290ef09a555e0a90f285d7372872db2b6d))

## [25.0.0](https://github.com/dkarter/dotfiles/compare/v24.7.0...v25.0.0) (2025-08-23)


### ⚠ BREAKING CHANGES

* **nvim:** use Elixir from Mason, instead of elixir-tools.nvim
* **nvim:** switch to blink.cmp + fix for ElixirLS
* **nvim:** upgrade to mason v2 + simplify lsp setup
* **nvim:** allow seamless navigation in visual mode

### Features

* add sound effects ([9ac403d](https://github.com/dkarter/dotfiles/commit/9ac403d2ad812d10ceb3ff6a43d72ff9cea31da8))
* **claude:** add dotfiles reviewer subagent ([eb2603b](https://github.com/dkarter/dotfiles/commit/eb2603b0297d0d63cb47f12b5845b7b7e38d6d60))
* **lefthook,mise:** add secret leak detection pre-commit hook ([1f1cf55](https://github.com/dkarter/dotfiles/commit/1f1cf55e55aa394d9ee508d27382cfdfe0b7e703))
* **lefthook:** add pre-commit format check ([9e6d447](https://github.com/dkarter/dotfiles/commit/9e6d44780d662a816e6f8ffbd8931b87ea22037c))
* **linear:** add linear cli ([a2a9ae5](https://github.com/dkarter/dotfiles/commit/a2a9ae516a0f98ec51578372479fc2df09658802))
* **mise,comp:** add argocd cli ([41f68b2](https://github.com/dkarter/dotfiles/commit/41f68b2fe571212b99d174eeac481af97fdce0bb))
* **mise,task:** add gitleaks globally + comps ([ff5a199](https://github.com/dkarter/dotfiles/commit/ff5a199b3e1bb29636eb2b19312a332f89d7f6d2))
* **mise:** add bun globally ([efd642c](https://github.com/dkarter/dotfiles/commit/efd642ca5fb87df482a059c4d0fd02c9f29dba69))
* **mise:** add ethersync ([374a634](https://github.com/dkarter/dotfiles/commit/374a63447807985f0fbc885ecea25abe9b6d1e5b))
* **mise:** add pnpm globally ([598b6d8](https://github.com/dkarter/dotfiles/commit/598b6d8d8ee5c7ca7c6f92915c971d30f94543cb))
* **nvim:** add ethersync plugin ([568ea3e](https://github.com/dkarter/dotfiles/commit/568ea3eff91f708f15e3cd5af18b6d9ec5cbe17c))
* **nvim:** add neovim plugin projections ([a963ba4](https://github.com/dkarter/dotfiles/commit/a963ba4fe97b90138920d3ed11e3f8e76e3a291c))
* **nvim:** add opencode context plugin ([a66e51f](https://github.com/dkarter/dotfiles/commit/a66e51f572081bbf1d9531306e1a8587439b0b28))
* **nvim:** add vim-switch for on/off ([31d3f81](https://github.com/dkarter/dotfiles/commit/31d3f81f6fb438a048004b138eb7d0901a10a5d1))
* **nvim:** include source in diagnostic popovers ([6b52b82](https://github.com/dkarter/dotfiles/commit/6b52b8267633f76f7bc8f1d6941bc717c0bfd69c))
* **nvim:** support inlay hints for lua + add mapping ([499fcf0](https://github.com/dkarter/dotfiles/commit/499fcf01dde716c16ca754a5232284ad15404652))
* **opencode:** add config ([f43c4c7](https://github.com/dkarter/dotfiles/commit/f43c4c7caefbe050e8a0157979922d65fface995))
* **opencode:** add gpt-oss ([9bdc55d](https://github.com/dkarter/dotfiles/commit/9bdc55d49b1bbdb4d6e9cb8e202b93290dcd5ba5))
* **opencode:** add session_completed notif sound ([739ecc4](https://github.com/dkarter/dotfiles/commit/739ecc4ebd39adabb24700f2e202c6f8523fc591))
* **task:** add historical check for leaks ([600d344](https://github.com/dkarter/dotfiles/commit/600d344a584654510fcbcc9cee86c66832450e8b))
* **zed:** add basic config ([bd079d3](https://github.com/dkarter/dotfiles/commit/bd079d31db69235121667aba4aa6e044a7a999d8))
* **zsh:** add aliases for ai tooling ([e95f92c](https://github.com/dkarter/dotfiles/commit/e95f92cb368ec81185ec7fc23d546d545d51ca17))
* **zsh:** add aliases for mise ([8942579](https://github.com/dkarter/dotfiles/commit/89425798958af954dd8142ef954f659ae47d575b))
* **zsh:** add completions for usage-cli ([5e2c17e](https://github.com/dkarter/dotfiles/commit/5e2c17e1bb838a4bc3e2ee5379a7de6a3944dc74))
* **zsh:** add figlet preview script: figprev ([b11c3ee](https://github.com/dkarter/dotfiles/commit/b11c3ee658b3763473047d33a2a1972c158d6120))


### Bug Fixes

* **dprint:** disable trailing commas ([ecb7d00](https://github.com/dkarter/dotfiles/commit/ecb7d001b6d02f654cb882d3a2272acdfeefa9d3))
* **dprint:** prevent formatting for claude cache files ([f76f486](https://github.com/dkarter/dotfiles/commit/f76f4869601b7ece65f162be05235915ec41ef1f))
* **git:** allow committing claude settings ([90f4c3e](https://github.com/dkarter/dotfiles/commit/90f4c3ebc4adc41601f17bab97375ec82a51cf78))
* **git:** don't store ethersync files in git ([f419263](https://github.com/dkarter/dotfiles/commit/f419263522e6017eb00dffdbcf7c21cd2c107399))
* **git:** ignore local configs for claude ([8de8e5c](https://github.com/dkarter/dotfiles/commit/8de8e5cefb0f9c3a58125dbc1c461dd45c0ecf91))
* **git:** incorrect file name ([6159c71](https://github.com/dkarter/dotfiles/commit/6159c7104bda47fe2f388691f10b0a9882b5de7b))
* **git:** remove claude ignores ([6c01058](https://github.com/dkarter/dotfiles/commit/6c0105877bb8eb6c57c0820fdf00486de7c3e723))
* **lefthook:** use better command for gitleaks ([4fad28c](https://github.com/dkarter/dotfiles/commit/4fad28c34e6bdae16cc350efbabe68414a3e4b25))
* **mise:** install taplo from ubi ([d2dab9e](https://github.com/dkarter/dotfiles/commit/d2dab9e0eb2bbc756484031f6bff3ca8d3f5768b))
* **nvim:** add tab/shift-tab for cycling completions with blink ([06ebfe1](https://github.com/dkarter/dotfiles/commit/06ebfe1c58c759e693477871579fb08959f768b7))
* **nvim:** address some lua diagnostic warnings ([8bdb068](https://github.com/dkarter/dotfiles/commit/8bdb06806c2570703222a814c25bcdb25ab1da8d))
* **nvim:** allow seamless navigation in visual mode ([df83898](https://github.com/dkarter/dotfiles/commit/df83898d4ddf881d1b0e2d5bcabe193c7e54b288))
* **nvim:** attempt to disable folds in diffview ([c5b2b15](https://github.com/dkarter/dotfiles/commit/c5b2b15b63717a96a7881226cbf7f1493cd47d4a))
* **nvim:** conventional commit picker was adding prefix twice ([d15d996](https://github.com/dkarter/dotfiles/commit/d15d996a253d16d1c5fd472456b2fbdaa1c729f3))
* **nvim:** elixir lsp incorrect require path ([7136d07](https://github.com/dkarter/dotfiles/commit/7136d073cfd88fd7c924247a6409abb278d5375b))
* **nvim:** improve behavior for blink ([0aa81e4](https://github.com/dkarter/dotfiles/commit/0aa81e43ed5f2b20e6ade7c31598922040f090a5))
* **nvim:** improve dprint with prettier fallback config ([ce69711](https://github.com/dkarter/dotfiles/commit/ce6971180de5dbce05aa1266308bf3575201dbb9))
* **nvim:** load claudecode on VeryLazy ([c509443](https://github.com/dkarter/dotfiles/commit/c5094435d16a2a2aaeac8dd024bdbdef28393e1f))
* **nvim:** pin plugins to avoid breaking changes ([1bfb4d1](https://github.com/dkarter/dotfiles/commit/1bfb4d1286e362781cd910518279a1e38b87acb1))
* **nvim:** remove commit pinning for gx ([add5a03](https://github.com/dkarter/dotfiles/commit/add5a0380a6e5dfb386f20403c8e8ce2aa0cf331))
* **nvim:** remove outdated settings that broke lazy loading ([4e65f37](https://github.com/dkarter/dotfiles/commit/4e65f37a753f9560e57b495bfd1c7a6d1419af27)), closes [#222](https://github.com/dkarter/dotfiles/issues/222)
* **nvim:** set capabilities correctly with LspAttach event ([46cdb24](https://github.com/dkarter/dotfiles/commit/46cdb2410dfa064336740dee9c8ce66d40b622dc))
* **nvim:** use a more sensible tmp dir ([a3a293c](https://github.com/dkarter/dotfiles/commit/a3a293c28ddbd761527addfaf5a590d34857f952))
* **opencode:** remove gpt-oss, add permissions, rename to jsonc ([22dfdfc](https://github.com/dkarter/dotfiles/commit/22dfdfc11ec3cbcfa8f2a3fcc98020474f9f7698))
* **starship:** disable bun integration ([892023e](https://github.com/dkarter/dotfiles/commit/892023e82795bafcc1f9dfddabd1b527b705f50d))
* **task:** use mise exec for lefthook install ([d5b4e69](https://github.com/dkarter/dotfiles/commit/d5b4e695a6bb7af847d854a6fd5c7dd957c47c52))
* **tmux:** disable unnecessary terminal setting ([9eb539d](https://github.com/dkarter/dotfiles/commit/9eb539dd0738bcbf6995b2231cdd349e2088f8c1))
* **tmux:** enable extended-keys ([3b05082](https://github.com/dkarter/dotfiles/commit/3b0508236d80be5788df3c91b1102c13b16f8e20))
* **tmux:** enforce extended-keys off ([f68c9cf](https://github.com/dkarter/dotfiles/commit/f68c9cf7904d5429486dfdc79a651b0ebdc85863))
* **tmux:** remove extended-keys setting ([8948838](https://github.com/dkarter/dotfiles/commit/8948838cf363f0b2701637b1bf30dd1fa7522224))
* **typos:** allow ignore comments in lua ([932bbad](https://github.com/dkarter/dotfiles/commit/932bbad0f6c1fc095496178c3c50ea6dfd3d56c3))
* **uv:** tell uv not to use its own python ([4efb829](https://github.com/dkarter/dotfiles/commit/4efb829c1d5c4e9506ee67250450aac63b1a7a31))
* **zsh:** add bun global install path to PATH env ([538e895](https://github.com/dkarter/dotfiles/commit/538e895dc48b7125f54664d8f723013a25dd9f93))
* **zsh:** elixir editors need to be opened in another window ([9f10951](https://github.com/dkarter/dotfiles/commit/9f10951e524f60e82e673ea8b8442a96a479716b))
* **zsh:** unalias zi for zinit to use zi for zoxide ([6e1f9de](https://github.com/dkarter/dotfiles/commit/6e1f9debcac1278e136bfc042002224640e88ac8))
* **zsh:** use s alias for session, instead of t, t = task ([0b88bf0](https://github.com/dkarter/dotfiles/commit/0b88bf0f95011daf9f4dc2fbd3094a573987d912))


### Code Refactoring

* **nvim:** switch to blink.cmp + fix for ElixirLS ([45b32a7](https://github.com/dkarter/dotfiles/commit/45b32a7577000cef30036517453e34285d21c2cb))
* **nvim:** upgrade to mason v2 + simplify lsp setup ([7843566](https://github.com/dkarter/dotfiles/commit/78435664b8cf8a9766c4fe9703c1ecf47f136476))
* **nvim:** use Elixir from Mason, instead of elixir-tools.nvim ([4a1021e](https://github.com/dkarter/dotfiles/commit/4a1021e8e5bb4f88d8c146e2ddba9112c832fbc0))

## [24.7.0](https://github.com/dkarter/dotfiles/compare/v24.6.0...v24.7.0) (2025-07-02)


### Features

* **nvim:** add &lt;esc&gt;<esc> tmap to enter normal mode ([7559ca5](https://github.com/dkarter/dotfiles/commit/7559ca5b020bca6bb00719ae5ad1be9452376712))
* **nvim:** add claude code integration ([d2592c4](https://github.com/dkarter/dotfiles/commit/d2592c4364c50e7d6ece16e97bf8277209dfa47d))
* **nvim:** add dprint to mason ([9c7fdb3](https://github.com/dkarter/dotfiles/commit/9c7fdb3bdcb0c72aaa9e837a628b31cfe4ee47ad))
* **nvim:** add support for dprint formatter ([04a3055](https://github.com/dkarter/dotfiles/commit/04a3055189553f140b4fda874bce4a7fee68dffa))
* **nvim:** add whichkey category name for AI mappings ([3d0d16f](https://github.com/dkarter/dotfiles/commit/3d0d16f8793838066dba87e2447c7b1fd6c161cf))
* **nvim:** seamless pane resize for all buffer kinds ([cbbdbc0](https://github.com/dkarter/dotfiles/commit/cbbdbc0fb99f66103d006ae2737340f6b293d84b))
* **nvim:** support toml formatting with dprint ([0ca5526](https://github.com/dkarter/dotfiles/commit/0ca5526f81a932c071ab7903501e62eab0b30893))
* **task:** add nvim:format ([375a76d](https://github.com/dkarter/dotfiles/commit/375a76d74048e52bc8fab637353cab41389d359f))


### Bug Fixes

* fix tpm binary path ([#354](https://github.com/dkarter/dotfiles/issues/354)) ([1b25fbc](https://github.com/dkarter/dotfiles/commit/1b25fbcd67d7e09d4a29fbc2e7add918da06e76e))
* **git:** remove git-lfs config ([#352](https://github.com/dkarter/dotfiles/issues/352)) ([c780861](https://github.com/dkarter/dotfiles/commit/c780861d90d1df48354542e294575403f55d4216))
* **neovim:** correct mappings for seamless nav in term bufs ([a51a743](https://github.com/dkarter/dotfiles/commit/a51a74313e21caa5ac6637b7531abd795067abcd))
* **nvim:** formatters ([bb802e1](https://github.com/dkarter/dotfiles/commit/bb802e1f23e0d7298e0023b2be8b7630d0a00b23))
* **nvim:** increase default timeout for formatters ([c24d9b1](https://github.com/dkarter/dotfiles/commit/c24d9b1c1cb1a47145b8279ca30ec4e64afb0a01))
* **nvim:** retrail config was incorrect ([0b3cdab](https://github.com/dkarter/dotfiles/commit/0b3cdab754477f2c206d3a2104ec912aac966653))
* **task:** stylua was not checking formatting ([505b601](https://github.com/dkarter/dotfiles/commit/505b6019035a407a2396ba00c9a409bfbef18aa3))

## [24.6.0](https://github.com/dkarter/dotfiles/compare/v24.5.0...v24.6.0) (2025-06-26)


### Features

* **leader-key:** update shortcuts and icons ([b8e5a41](https://github.com/dkarter/dotfiles/commit/b8e5a4111d8b798454edf7c13ea7664e64b91848))
* **zsh:** add completions for graphite cli ([508187a](https://github.com/dkarter/dotfiles/commit/508187aa439b57e4f6d2e880b51edd023f97cd25))


### Bug Fixes

* **brew:** update package names ([5d35380](https://github.com/dkarter/dotfiles/commit/5d3538070d3f08202fa555680c6fc937f1acf781))
* **lefthook:** update file syntax ([aa28cd5](https://github.com/dkarter/dotfiles/commit/aa28cd5bd2188aa5cec367ed078ac166baeeb09d))
* **wezterm:** update config for better linux/win support ([e17ec25](https://github.com/dkarter/dotfiles/commit/e17ec25ea740adf0091bd3caf3943d34e786f128))

## [24.5.0](https://github.com/dkarter/dotfiles/compare/v24.4.0...v24.5.0) (2025-06-18)


### Features

* **mise:** add marp for generating presentations ([8c8bd3d](https://github.com/dkarter/dotfiles/commit/8c8bd3d4a8fd736fc09d145b1892d62d039ef132))
* **zsh:** add completions for lefthook ([0e36c5f](https://github.com/dkarter/dotfiles/commit/0e36c5fe8cbe7acf890a3804da211938e6e2a489))


### Bug Fixes

* **mise:** move lefthook install step to task ([4a88d26](https://github.com/dkarter/dotfiles/commit/4a88d26ad0c8fd57427de8d2416f3296fb013bd8))


### Performance Improvements

* **task:** run ci tasks in parallel ([bb25477](https://github.com/dkarter/dotfiles/commit/bb25477062e6e84ce6773d75961d1672a05dcbef))

## [24.4.0](https://github.com/dkarter/dotfiles/compare/v24.3.0...v24.4.0) (2025-06-14)


### Features

* **mise:** add tidewave mcp proxy ([c5b0096](https://github.com/dkarter/dotfiles/commit/c5b0096dd55e46bf1ff6c7b5c131d58e2a2b3430))
* **nvim:** add CSV View plugin ([a5e2412](https://github.com/dkarter/dotfiles/commit/a5e24127f6896fa08533e6ff524934e8d1006805))
* **nvim:** add plugin spec for mcphub ([b648838](https://github.com/dkarter/dotfiles/commit/b64883818c82bf8245c0fee6a3265f6198cb9523))
* **nvim:** add support for biome-based formatters ([c73c31e](https://github.com/dkarter/dotfiles/commit/c73c31e59fd852cba2f1207bda8dc1eda3f31bf7))
* **nvim:** add syntax highlighting to LIQUID sigils in Elixir ([b1d71c4](https://github.com/dkarter/dotfiles/commit/b1d71c4921ea1b54bd1f296284163aa231776e91))
* **nvim:** automatically install biome ([ecc5d2e](https://github.com/dkarter/dotfiles/commit/ecc5d2ec6507d68cc6017e2241d96654407db639))
* **zsh:** add more docker aliases ([916f34b](https://github.com/dkarter/dotfiles/commit/916f34b2514af43adc8c8dfc6da3105a2cdd5245))


### Bug Fixes

* **nvim:** force copilot model to claude-sonnet-4 ([a298139](https://github.com/dkarter/dotfiles/commit/a29813935c0a45080f83a500e521d0a2b9bba6d0))
* **nvim:** switch mcphub build step to npm from pnpm ([380c7bc](https://github.com/dkarter/dotfiles/commit/380c7bc6e8143ad99ae255ef4133bfdebd627065))

## [24.3.0](https://github.com/dkarter/dotfiles/compare/v24.2.0...v24.3.0) (2025-05-22)


### Features

* **ghostty:** add quick terminal keybind ([67937c1](https://github.com/dkarter/dotfiles/commit/67937c1c01eedbaf7723f41cb636dd5367bd6667))
* **ghostty:** add tmux tab navigation with super+[NUMBER] ([4bb9892](https://github.com/dkarter/dotfiles/commit/4bb9892f4cafa878415d62725bdd95dfe2292017))
* **nvim:** add `codecompanion.nvim` ([480fafc](https://github.com/dkarter/dotfiles/commit/480fafc15e9de13e170fba956ce5ee570701f0eb))
* **nvim:** add copilot.lua ([f60a15e](https://github.com/dkarter/dotfiles/commit/f60a15e25a089f26b18ad50f1acef5420a885ec8))
* **task:** add completion for pgroll ([f080d3c](https://github.com/dkarter/dotfiles/commit/f080d3c68a06bdb97aa5000e006539dc94a11759))
* **wezterm:** emit notif on config reload, same color titlebar ([de94024](https://github.com/dkarter/dotfiles/commit/de940244b0ca480681ddd5bf05b50adedd04e8a6))
* **zsh:** don't save commands starting with space in history ([c932f06](https://github.com/dkarter/dotfiles/commit/c932f06829a379d4c8fdefd1f94a1006d16bd899))


### Bug Fixes

* **ghostty:** decrease background opacity ([25f1c41](https://github.com/dkarter/dotfiles/commit/25f1c411d788536515f931630514e7dc50b5c64e))
* **ghostty:** macos titlebar consistent color ([3bfb192](https://github.com/dkarter/dotfiles/commit/3bfb1925eb5d9b4ac8e3dde6ef316094b340f3d6))
* **nvim:** enable nvim-surround on empty buffers ([2e1419c](https://github.com/dkarter/dotfiles/commit/2e1419c0849331baaa546f9cd1653634faddb1a5))
* **nvim:** remove cmp handlers for copilot ([d5408dd](https://github.com/dkarter/dotfiles/commit/d5408ddad6d2145006a4d1cebef901f9c6b2e958))
* **nvim:** rename powershell sigil to PS ([acf6c18](https://github.com/dkarter/dotfiles/commit/acf6c18c65d35d5ddd78d90b7b1b1c580bacf4be))
* **nvim:** seamless navigation fix for Snacks explorer ([bc5945d](https://github.com/dkarter/dotfiles/commit/bc5945d2e77ea31943c2e90dbb7bc581432591c0))
* **task,wezterm:** use a different font ([cf2d4e2](https://github.com/dkarter/dotfiles/commit/cf2d4e27c8815c0b02c2f9979684f1e03788a2bd))
* **task:** comp:generate should not fail when executable not found ([3df5bef](https://github.com/dkarter/dotfiles/commit/3df5bef64dfad97a9c0425cb9e8cacf3ce2294a9))
* **wezterm:** switch font to jetbrains ([1b09ed4](https://github.com/dkarter/dotfiles/commit/1b09ed4b9e9f61ae4ff6bf364f5d940a2a4c3d75))

## [24.2.0](https://github.com/dkarter/dotfiles/compare/v24.1.0...v24.2.0) (2025-04-20)


### Features

* **ghostty:** add basic ghostty config ([b50b16b](https://github.com/dkarter/dotfiles/commit/b50b16b6a99838e0bbf2f7d417b14e832c278f0c))
* **nvim:** highlight powershell sigils in Elixir ([2380e78](https://github.com/dkarter/dotfiles/commit/2380e788ec6d85fa84beb1173e6dd34b96d694f7))

## [24.1.0](https://github.com/dkarter/dotfiles/compare/v24.0.0...v24.1.0) (2025-04-12)


### Features

* **leader-key:** add more bindings ([d72a933](https://github.com/dkarter/dotfiles/commit/d72a9336ad5f28c81d57c88430eb7448c8c6c14f))
* **leader-key:** add TIL shortcut ([692031c](https://github.com/dkarter/dotfiles/commit/692031c9cd3f1c4e16aaade1941f16104bfe01b7))
* **nvim:** add improved picker mappings ([b56beb7](https://github.com/dkarter/dotfiles/commit/b56beb7d637bb7d49ac50bd1c278be57c2a6a8b1))
* **nvim:** add picker for PR changed files ([e8993f3](https://github.com/dkarter/dotfiles/commit/e8993f3308d39e77da3c25044d454c01962180d1))


### Bug Fixes

* **nvim:** dynamically get the base branch name for PR Files ([825ffad](https://github.com/dkarter/dotfiles/commit/825ffad02fea194d10deb03746a473e8889a4ce3))
* **nvim:** include committed files in PR file picker ([b544bc1](https://github.com/dkarter/dotfiles/commit/b544bc19d03b06b0d137cf84a3ff4e8db1a2a6c3))
* **nvim:** only show snippets when non trigger chars are used ([db67aeb](https://github.com/dkarter/dotfiles/commit/db67aebc0afbe89d5de1716aa654bce16d79797e))
* **nvim:** temporarily revert back to cmp ([29751de](https://github.com/dkarter/dotfiles/commit/29751de7c929412878bfdd85ba4ff0891418741e))
* **nvim:** use treesitter for lsp completions highlighting ([ac4a8b3](https://github.com/dkarter/dotfiles/commit/ac4a8b3252df34ec4e0c4168a47281e1d2e4b60a))
* **zsh:** improve completions ([b920a84](https://github.com/dkarter/dotfiles/commit/b920a84a50257353f342806ee8f17c907e17d723))


### Reverts

* "refactor(tmux,nvim): switch style to boxes" ([eb6d592](https://github.com/dkarter/dotfiles/commit/eb6d592eff857b002e9136a50465501d9bd5a514))

## [24.0.0](https://github.com/dkarter/dotfiles/compare/v23.2.1...v24.0.0) (2025-03-30)


### ⚠ BREAKING CHANGES

* **nvim:** use virtual_lines for diagnostics

### Features

* **nvim:** use virtual_lines for diagnostics ([0775dd2](https://github.com/dkarter/dotfiles/commit/0775dd212246bf2e1627a2ae9cc7d928fb198c48))


### Bug Fixes

* **nvim:** restore treesitter folding functionality ([1b43a44](https://github.com/dkarter/dotfiles/commit/1b43a444ee57cd0009f16798b7be24ff5b675488))

## [23.2.1](https://github.com/dkarter/dotfiles/compare/v23.2.0...v23.2.1) (2025-03-30)


### Bug Fixes

* **nvim:** remove buggy autocmd in treesitter config ([33cbae7](https://github.com/dkarter/dotfiles/commit/33cbae765cdfc3a9ceaa0ca92eeda2135001e105))
* **nvim:** remove DAP sign_define - deprecated ([cf55a7e](https://github.com/dkarter/dotfiles/commit/cf55a7ed6d90ee6ce2a3311692ae2f234e521a13))
* **nvim:** sign-define deprecation in nvim 0.11 ([46ec49b](https://github.com/dkarter/dotfiles/commit/46ec49bc013046c1a353a9c032e33175fd78ca52))

## [23.2.0](https://github.com/dkarter/dotfiles/compare/v23.1.0...v23.2.0) (2025-03-30)


### Features

* **leader-key:** add more mappings ([a6655a3](https://github.com/dkarter/dotfiles/commit/a6655a36cc4bee1df955ec8c431be6ec33b780ed))
* **leader-key:** introduce leader key config ([3fe5817](https://github.com/dkarter/dotfiles/commit/3fe5817ec76fe3ff9db5f6404c578679f81c2217))


### Bug Fixes

* **brew:** dreprecations ([a5151b8](https://github.com/dkarter/dotfiles/commit/a5151b83821a75c3ede87eba0ed44407d838b9e6))

## [23.1.0](https://github.com/dkarter/dotfiles/compare/v23.0.0...v23.1.0) (2025-03-23)


### Features

* **task:** add ci check tasks ([9726370](https://github.com/dkarter/dotfiles/commit/9726370ce5b3bedb0b7d2872931ab9a4314897ca))

## [23.0.0](https://github.com/dkarter/dotfiles/compare/v22.1.0...v23.0.0) (2025-03-23)


### ⚠ BREAKING CHANGES

* replace unimpaired-nvim with mini-bracketed

### Features

* enable snacks input ([5a18247](https://github.com/dkarter/dotfiles/commit/5a182478c31043cb70a38b35d50681e0cef9edcd))
* **git:** add git better branch script ([b7c129b](https://github.com/dkarter/dotfiles/commit/b7c129bc6b06b8db694f6e0a94fe132251548db5))
* **mise:** add slsa-verifier ([9c0ee09](https://github.com/dkarter/dotfiles/commit/9c0ee096a402d6bc6be46618534890ca6b9c4945))
* **nvim:** add shellcheck to mason ensure_installed ([acbd938](https://github.com/dkarter/dotfiles/commit/acbd93880140af4e9e4c29b5769effaf02081df5))
* **zsh:** add docker compose aliases ([fde8edb](https://github.com/dkarter/dotfiles/commit/fde8edbd75d14d44b32528b83967931ac08f8da7))
* **zsh:** add git stash -all alias ([94f70fd](https://github.com/dkarter/dotfiles/commit/94f70fdde5568059cc160e4d4cd71657727ba831))


### Bug Fixes

* **git:** force delta pager even for small diffs ([1d0ab99](https://github.com/dkarter/dotfiles/commit/1d0ab99f1c068c80e97c594c96ab02a6de8575d3))
* **git:** ignore .task folder ([2e72915](https://github.com/dkarter/dotfiles/commit/2e72915db737175f3e8c0d38b4b652cc649bc9b8))
* **mise,zsh:** fix load order of zsh scripts to be after mise ([efb7908](https://github.com/dkarter/dotfiles/commit/efb790805142402eded389b9f6a8240cf3b60688))
* **nvim:** add &lt;c-x&gt; mapping to picker ([d1e63e0](https://github.com/dkarter/dotfiles/commit/d1e63e02312b34536227d3c27efd4d51f4d8b31a))
* **task:** don't run tmux tasks when not inside of tmux ([12e7816](https://github.com/dkarter/dotfiles/commit/12e78164b949b134cde07f53a7faf176cff024df))
* **zsh:** freethousand lsof syntax ([cfb9830](https://github.com/dkarter/dotfiles/commit/cfb983039e368f99dd6404707d632a162f54de3f))


### Performance Improvements

* **task:** improve speed of sync task ([1453a69](https://github.com/dkarter/dotfiles/commit/1453a690e2457bd5f45d58b97434ec18505d7b7f))


### Code Refactoring

* replace unimpaired-nvim with mini-bracketed ([f8b277a](https://github.com/dkarter/dotfiles/commit/f8b277ad45e5c77a427911d9ac1269fd60c7292f))

## [22.1.0](https://github.com/dkarter/dotfiles/compare/v22.0.0...v22.1.0) (2025-03-03)


### Features

* **mise:** add back direnv ([53d60de](https://github.com/dkarter/dotfiles/commit/53d60de6a285e3abff8acff8570c260c67302d87))
* **mise:** add dive (explore docker layers) ([5c6affd](https://github.com/dkarter/dotfiles/commit/5c6affd9fec2c4b17279ec2348f173a45ebdc795))
* **zsh:** add alias for ll sorted by date asc (llc) ([36f0ff9](https://github.com/dkarter/dotfiles/commit/36f0ff9cebf89be2374b7e1d15eaeb2becf5bd01))
* **zsh:** add alias tfd for terraform destroy ([13b78ff](https://github.com/dkarter/dotfiles/commit/13b78ffd6e56ae62e502a1c4ee817370d6abac35))
* **zsh:** add back direnv ([db87909](https://github.com/dkarter/dotfiles/commit/db87909069c4f2df92768a3a4902d18cb1b87a8f))
* **zsh:** add tfa alias for terraform apply ([f001a35](https://github.com/dkarter/dotfiles/commit/f001a35cfc3dab742af093d3240974ddc40f2433))


### Bug Fixes

* condition for `task` installation ([#320](https://github.com/dkarter/dotfiles/issues/320)) ([6662f18](https://github.com/dkarter/dotfiles/commit/6662f18fd003e8bb55076222806b5ea5937bc4d1))
* **git:** improve gitconfig ([f5a919b](https://github.com/dkarter/dotfiles/commit/f5a919b62d01a93ed3bacf261800143dbdfd3ccf))
* **scripts:** ensure MasonUpdateAll completes ([#321](https://github.com/dkarter/dotfiles/issues/321)) ([bd46165](https://github.com/dkarter/dotfiles/commit/bd4616539b17140b5c8882e1e74bf9eb93c7965b))

## [22.0.0](https://github.com/dkarter/dotfiles/compare/v21.2.0...v22.0.0) (2025-02-16)


### ⚠ BREAKING CHANGES

* **nvim:** more sensible mappings for git blame and lazygit logs

### Features

* **mise:** add glow markdown CLI renderer ([3a636c0](https://github.com/dkarter/dotfiles/commit/3a636c06d5ac3ae6de473b0bf7326129fc89d9e8))
* **nvim:** add &lt;leader&gt;fo (find oldfiles) -> jump 2 recent files ([e4f933b](https://github.com/dkarter/dotfiles/commit/e4f933bde732bb5ea2795a6b8397c828e89e9eb2))
* **nvim:** add &lt;leader&gt;hl for blame line ([bbd5f70](https://github.com/dkarter/dotfiles/commit/bbd5f70b9e311bf4d0fa2fd6d3aa78a48997636d))
* **nvim:** add buffer keymaps which-key mapping ([290c191](https://github.com/dkarter/dotfiles/commit/290c1912ce02c9b0a2be05ea25947ab0101cd413))
* **nvim:** add find and replace plugin (grug-far) ([535fa87](https://github.com/dkarter/dotfiles/commit/535fa87ad7135e2245b1837247d05793998a8e66))
* **nvim:** add groups to which key ([0163956](https://github.com/dkarter/dotfiles/commit/0163956e8f63af6383717ae71444a5c3e4bb27eb))
* **nvim:** more useful gf mapping ([8dc6d4d](https://github.com/dkarter/dotfiles/commit/8dc6d4dffd732f51a383badda383f41526721d39))
* **zsh:** add terraform alias ([78dd945](https://github.com/dkarter/dotfiles/commit/78dd945f7b9395776481b73c0a1c6ea8dd33ca4d))


### Bug Fixes

* **ci:** revert lua-language-server to v2 ([93202d7](https://github.com/dkarter/dotfiles/commit/93202d7fc188fe52b03019c55d391dda7e4cb1a2))
* **codespell:** ignore CHANGELOG.md ([30ed153](https://github.com/dkarter/dotfiles/commit/30ed1530164ed619c0444559d923a8e676b5a6f7))
* **git:** remove unused ignore refs ([4c8d796](https://github.com/dkarter/dotfiles/commit/4c8d79631f65d4479d9e2c7b07298049217c61a9))
* **nvim:** better &lt;leader&gt;/ -> for fuzzy line jumping ([2c16d44](https://github.com/dkarter/dotfiles/commit/2c16d4449eb8d92286b30f76bc51cf6ee96cbbc8))
* **nvim:** explicitly set Snacks picker to enabled ([3b0f3ec](https://github.com/dkarter/dotfiles/commit/3b0f3ec4ff8b70bd9b31a906f7878f9182bcb81a))
* **nvim:** more sensible mappings for git blame and lazygit logs ([8401ba4](https://github.com/dkarter/dotfiles/commit/8401ba4c049fa84c3bfdeb8de35952e88cbf3582))
* **nvim:** neogen mapping desc ([9474725](https://github.com/dkarter/dotfiles/commit/947472593585085ce599c7191b2b07608dc1229a))
* **nvim:** only lint commitlint when a config is available ([a37ada6](https://github.com/dkarter/dotfiles/commit/a37ada6d78c3c14f9379c76461d65e1caa2cef0c))
* **nvim:** re-enable and fix bullets.vim for compatibility w/ picker ([496ea32](https://github.com/dkarter/dotfiles/commit/496ea32a8279e6e45012295d1b17cf23d626f4b8))
* **nvim:** re-enable bullets-vim and lazy load on VeryLazy ([ce5f602](https://github.com/dkarter/dotfiles/commit/ce5f60280919780605f661a1f78fd639d3446464))
* **nvim:** remove &lt;leader&gt;f/ -> not useful ([64cbe0c](https://github.com/dkarter/dotfiles/commit/64cbe0c50836d44662c07cb7c711f8c97f4528ae))
* **nvim:** remove rubocop ([42dfa24](https://github.com/dkarter/dotfiles/commit/42dfa2437785eb0d2c21c552f0c9f9ae81d0b939))
* **nvim:** strip lines from git_copy_file_url ([3c90dca](https://github.com/dkarter/dotfiles/commit/3c90dca9f03b9e47fef14bed7dff7cd306b73355))
* **nvim:** toggle git blame buffer with &lt;leader&gt;gb ([6769750](https://github.com/dkarter/dotfiles/commit/6769750bd0d7574878823237d9bfefb1454371c2))
* **nvim:** update trouble todo mappings ([dfb4441](https://github.com/dkarter/dotfiles/commit/dfb4441b2d6a8b7f8fde4d0f10cd887c97b6fbac))
* **nvim:** use correct repo for vimux ([e9ae1b1](https://github.com/dkarter/dotfiles/commit/e9ae1b1f0df2d82c73a4dbf14c1614985bc914ad))
* **task:** add new lint task and rename existing checks ([8043979](https://github.com/dkarter/dotfiles/commit/8043979b710521f1405a8174cc93dca120daa032))
* **task:** Create .fonts dir before install ([#313](https://github.com/dkarter/dotfiles/issues/313)) ([214e3b1](https://github.com/dkarter/dotfiles/commit/214e3b1f2411554012c4aa11a4c798ba8c062efc))
* **zsh:** disable ton as $EDITOR ([c06c661](https://github.com/dkarter/dotfiles/commit/c06c661443472bcf32921d1464495051f66df8fd))
* **zsh:** set EDITOR to nvim always ([6ab62e0](https://github.com/dkarter/dotfiles/commit/6ab62e01ee80feae51d7bd3428812af2e96f9df2))

## [21.2.0](https://github.com/dkarter/dotfiles/compare/v21.1.0...v21.2.0) (2025-02-06)


### Features

* **nvim:** add &lt;leader&gt;ll [L]aunch [L]ua ([b339f5f](https://github.com/dkarter/dotfiles/commit/b339f5f1546687dc35346a753f57640d63ff782c))
* **nvim:** add `q` mapping to exit fugitive blame ([2401bae](https://github.com/dkarter/dotfiles/commit/2401bae707bade9d5dd39676baac47d7fb48419a))
* **nvim:** add additional git related mappings ([edcb1c6](https://github.com/dkarter/dotfiles/commit/edcb1c68f2c1fbd64e52d46ae1b93c7ed9572a7c))
* **nvim:** add language specific pickers ([e775017](https://github.com/dkarter/dotfiles/commit/e7750177d356409aa544202b47a46f1e65b2e034))
* **pg_format:** add formatter config ([55f07ba](https://github.com/dkarter/dotfiles/commit/55f07ba13c6af58e0f3c90442de3e628bcfe6100))


### Bug Fixes

* **nvim:** add ignoreDir setting for lua_ls ([3a8df63](https://github.com/dkarter/dotfiles/commit/3a8df639098b9f70ab9048bc38444ff653d13036))
* **nvim:** enable grep_word mapping in visual mode ([2850226](https://github.com/dkarter/dotfiles/commit/285022635d3473f7d626193b6dba3fbcc7e3a8e0))
* **nvim:** make dadbod work ([1e902be](https://github.com/dkarter/dotfiles/commit/1e902be46fdd4e3a453bbffaf0fab3427458eceb))
* **nvim:** remove telescope references ([b3b2ef5](https://github.com/dkarter/dotfiles/commit/b3b2ef53541736b59d004699e3e82c7f4aaa4599))
* **tmux:** improve sesh (use --hide-duplicates, vertical preview) ([aa27c12](https://github.com/dkarter/dotfiles/commit/aa27c1235db352cf7119a6a5234e15f930c04b40))


### Performance Improvements

* **nvim:** move dadbod cmp setup to `config` ([fcb5d30](https://github.com/dkarter/dotfiles/commit/fcb5d30e236a1e99684521c9804653cf5a4a431e))

## [21.1.0](https://github.com/dkarter/dotfiles/compare/v21.0.0...v21.1.0) (2025-02-02)


### Features

* **nvim:** add mapping for notification history (leader nh) ([7e9680b](https://github.com/dkarter/dotfiles/commit/7e9680bcc3a81cd5f49f6c5bf067ebeaad1bc4c1))
* **nvim:** automatically load snacks.nvim types ([7754f19](https://github.com/dkarter/dotfiles/commit/7754f1945e1ab8b263801b31c2c2220d12a5c219))


### Bug Fixes

* **nvim:** fix mapping conflict for &lt;leader&gt;sl ([11e3362](https://github.com/dkarter/dotfiles/commit/11e336281b94115faabbbe995a92264452f200f6))
* **nvim:** improve conventional_commits_picker (insert at EOL) ([837d159](https://github.com/dkarter/dotfiles/commit/837d159a73c83868745f0289a55a66c4672e56b6))
* **nvim:** remove remnants of NvimTree config ([62afa1f](https://github.com/dkarter/dotfiles/commit/62afa1fbacfe77ae6d44b675f0a7c9e81fa71142))

## [21.0.0](https://github.com/dkarter/dotfiles/compare/v20.1.0...v21.0.0) (2025-02-02)


### ⚠ BREAKING CHANGES

* **nvim:** change <leader>fu to Find Undo
* **nvim:** use more easily discoverable mappings for swap
* **nvim:** update gitsigns mappings

### Features

* **mise,task:** add talosctl ([7d77ac2](https://github.com/dkarter/dotfiles/commit/7d77ac2197324cbe8bb2e1832e0dfe2e27024ed6))
* **mise:** add `choose` - awk/cut alternative ([804f667](https://github.com/dkarter/dotfiles/commit/804f667a32c2839efa9f04f953a6cee5f5fafa19))
* **mise:** add diffnav ([1e666d8](https://github.com/dkarter/dotfiles/commit/1e666d80ec31251db21b557fc9736bef85f6549e))
* **mise:** add gping tool ([2585609](https://github.com/dkarter/dotfiles/commit/2585609fbf0d9737e210f50d00ac5aaa72761f69))
* **mise:** add terraform globally ([42308f0](https://github.com/dkarter/dotfiles/commit/42308f05c6d3ef884c723cd018d21a412c11a648))
* **mise:** add wireman (GRPC client) ([6359fbc](https://github.com/dkarter/dotfiles/commit/6359fbcec5b599d2cdb590f85b806673a0f96366))
* **nvim:** add new picker mappings ([edb27cb](https://github.com/dkarter/dotfiles/commit/edb27cb31dc474ca32fe6d8f6484bc4d4faa4df1))
* **python:** add Posting (a Postman-like TUI) ([8c7a19d](https://github.com/dkarter/dotfiles/commit/8c7a19d63338cda57350404b1256717124be19b4))
* **task,mise:** add mise:tools:outdated task ([8fdb600](https://github.com/dkarter/dotfiles/commit/8fdb600e07cd56189b2e90a44eb21164c70ddccf))
* **task:** add doggo (modern dig alternative) ([1a8f86e](https://github.com/dkarter/dotfiles/commit/1a8f86e3953ad930a2a4557a59ad2e96b34a4d3f))
* **task:** add kdash (kubernetes dashboard) ([9da84a1](https://github.com/dkarter/dotfiles/commit/9da84a18c49dd428d90c1182c7a0e5fd91fe0d97))
* **zsh:** add gdn git diffnav alias ([1a7af58](https://github.com/dkarter/dotfiles/commit/1a7af583968c65b0302ea9e8e97a4bcb61352d7e))


### Bug Fixes

* **mise:** add missing kubens ([254c365](https://github.com/dkarter/dotfiles/commit/254c365466c13e2125497abe34bc0e7c071a78d5))
* **mise:** relax erlang version to major ([f30ae7a](https://github.com/dkarter/dotfiles/commit/f30ae7a7590636a33761e248a07c1c72ef125ad4))
* **mise:** remove pnpm from mise ([350fb05](https://github.com/dkarter/dotfiles/commit/350fb05c7ec5b63fedd142d368651cacb28f4589))
* **nvim:** enable c-a readline for Snacks picker ([f0d7983](https://github.com/dkarter/dotfiles/commit/f0d7983e16892b39ef87942e5c8fc2cb00497bc6))
* **nvim:** update gitsigns mappings ([cfcd6b6](https://github.com/dkarter/dotfiles/commit/cfcd6b69c9f4af5a7b1caf0931fe8cc9d2f22434))
* **task:** dynamically determine wxgtk package ([db6a545](https://github.com/dkarter/dotfiles/commit/db6a545a54105c17277f85bc07d4ae544a335d49))
* **zsh,tmux:** improve t command (icons, popup) ([c7f4358](https://github.com/dkarter/dotfiles/commit/c7f43584dc1da0458eba9b5e33a1dc25a41c3db0))
* **zsh:** only source carapace when available ([5a9f1ab](https://github.com/dkarter/dotfiles/commit/5a9f1ab68f43ec9efebaef1eef5a4241e806a28e))


### Code Refactoring

* **nvim:** change &lt;leader&gt;fu to Find Undo ([48d6e1d](https://github.com/dkarter/dotfiles/commit/48d6e1dab0ec4397eca3692c1362c5bf17b46eb3))
* **nvim:** use more easily discoverable mappings for swap ([6d6e7a8](https://github.com/dkarter/dotfiles/commit/6d6e7a8ffcac329858751268d926d7cf96a0d269))

## [20.1.0](https://github.com/dkarter/dotfiles/compare/v20.0.0...v20.1.0) (2025-01-05)


### Features

* **mise:** add postinstall for node to enable corepack and pnpm ([966d0d2](https://github.com/dkarter/dotfiles/commit/966d0d20d61532e8ee7109acb5215c4df537ca92))
* **task,debian:** add nala for package management ([df6e877](https://github.com/dkarter/dotfiles/commit/df6e877a9fc4caae934efc62e007a029b8e407f7))


### Bug Fixes

* **shellcheck:** add missing shebang ([b6db505](https://github.com/dkarter/dotfiles/commit/b6db5052154bfaa0ab1847e375369fc8857e15b0))
* **task,debian:** remove redundant readline package ([b1e44a0](https://github.com/dkarter/dotfiles/commit/b1e44a0d2911e714aa76c1259d33deec9a516839))
* **task,debian:** remove version from libclang-dev ([259cafc](https://github.com/dkarter/dotfiles/commit/259cafc0de2018c760ea45b49ccd29fd9675d2d0))
* **task:** add carapace install on debian via apt ([cbefe34](https://github.com/dkarter/dotfiles/commit/cbefe34460df13b62f1b9692576264bd352ecdd5))
* **task:** add missing install TPM task ([2862787](https://github.com/dkarter/dotfiles/commit/2862787e2c806a7d9c2721a33c5d1378bd258199))
* **task:** disable font install in windows (temporarily) ([f2a4fc1](https://github.com/dkarter/dotfiles/commit/f2a4fc19ae7affb3df4a9d8ea8b3b55073fdac04))
* **task:** don't install tpm if already installed ([4ea4227](https://github.com/dkarter/dotfiles/commit/4ea4227e2ab150bb8633d6f168be19b1ce763e37))
* **task:** missed reshim task asdf -&gt; mise ([733ade0](https://github.com/dkarter/dotfiles/commit/733ade0bf4541f9915bdaaf375c7accd7eca5bd3))

## [20.0.0](https://github.com/dkarter/dotfiles/compare/v19.2.0...v20.0.0) (2025-01-01)


### ⚠ BREAKING CHANGES

* **asdf,mise:** use mise instead of asdf ([#293](https://github.com/dkarter/dotfiles/issues/293))
* **zsh:** alias h to bathelp

> [!WARNING]
> Be sure to delete `~/.tool_versions` and `~/.asdf` then run `task install` in
> a fresh terminal

### Features

* **gh-dash:** add separate work config ([e7ed793](https://github.com/dkarter/dotfiles/commit/e7ed79341d73aa0b26a08846fc59c72255f4644f))
* **nvim:** enable Snacks scope feature ([35dd959](https://github.com/dkarter/dotfiles/commit/35dd959b6664469b84a1b3c77ac95dde609ccff4))
* **nvim:** notify LSP on file rename from nvim-tree ([12a169d](https://github.com/dkarter/dotfiles/commit/12a169d6de391af552922521bf2a1d8a39301456))
* **smug:** add json schema ([51d0ac6](https://github.com/dkarter/dotfiles/commit/51d0ac6c14284da30938a43872c198feccbabd56))
* **zsh:** alias h to bathelp ([28be2e2](https://github.com/dkarter/dotfiles/commit/28be2e2c4df41d4355fcbc01ef23606dae9c43b9))


### Bug Fixes

* **task:** asdf update deprecation + add update tools to sync ([6cae338](https://github.com/dkarter/dotfiles/commit/6cae338f69e0b0324da445240ca9a9177306d2c2))
* **task:** platforms + task didn't work ([54e573e](https://github.com/dkarter/dotfiles/commit/54e573ed3831d8c5b08e21ab40a4a5037424eb46))
* **wezterm:** keybinds based on OS ([ae215fe](https://github.com/dkarter/dotfiles/commit/ae215fe3de10b840379009529ca2100537300873))


### Code Refactoring

* **asdf,mise:** use mise instead of asdf ([#293](https://github.com/dkarter/dotfiles/issues/293)) ([70bf93e](https://github.com/dkarter/dotfiles/commit/70bf93eea8cf4c1f4d21297bb3ed6218dc608517))

## [19.2.0](https://github.com/dkarter/dotfiles/compare/v19.1.0...v19.2.0) (2024-12-13)


### Features

* **nvim:** add scratch buffer from Snacks ([aa97bfc](https://github.com/dkarter/dotfiles/commit/aa97bfc4c9be32fedba743e23b14dd0cb1a5aa71))


### Bug Fixes

* **installer:** add missing dependencies for debian for ruby ([f1afc51](https://github.com/dkarter/dotfiles/commit/f1afc51e42d03f906163ef0b4fb7583eacb1e08d))
* **task:** add missing utils for linux ([bd3d3e8](https://github.com/dkarter/dotfiles/commit/bd3d3e8dd4c4e6ae126a34704a8842a0bd6337e6))
* **task:** asdf tool install wasn't working ([cb9fcaa](https://github.com/dkarter/dotfiles/commit/cb9fcaa69383cf3249a3daef37a3bac31ffa6ae1))
* **task:** default shell setup was too env specific ([37e205f](https://github.com/dkarter/dotfiles/commit/37e205f2dbacec6d1031268f70fc09a31df6c4ad))
* **task:** remove infinite loop from installer ([787a83c](https://github.com/dkarter/dotfiles/commit/787a83c5d62837651f49d2f9a18324dd4630a156))
* **task:** shell install status check ([9f0ebb0](https://github.com/dkarter/dotfiles/commit/9f0ebb0d05242cdcd1e0169c16403f4d0c8a4e5e))

## [19.1.0](https://github.com/dkarter/dotfiles/compare/v19.0.0...v19.1.0) (2024-12-08)


### Features

* **nvim:** add bash syntax injection to taskfile status, deps ([a511257](https://github.com/dkarter/dotfiles/commit/a511257243aba4f49384642f087837034681a600))
* **task:** add sync:fast, and make the regular sync synchronous ([9b8762e](https://github.com/dkarter/dotfiles/commit/9b8762e50d75502df4ddd566159418212c156a92))


### Bug Fixes

* **debian:** add missing deps for jless ([7047059](https://github.com/dkarter/dotfiles/commit/7047059968b23faf6e7283ceb74a605019590f9e))
* **nvim:** disable treesitter for large files ([df668d6](https://github.com/dkarter/dotfiles/commit/df668d6e24659a2c27b4427fae915bfa811b3ca8))
* **zsh:** egrep deprecation ([d0f0eeb](https://github.com/dkarter/dotfiles/commit/d0f0eeb67f6aad951d6d111c3a895291f772b261))

## [19.0.0](https://github.com/dkarter/dotfiles/compare/v18.12.0...v19.0.0) (2024-12-06)


### ⚠ BREAKING CHANGES

* **nvim:** improve treesitter textobj mappings

### Features

* **nvim:** add better lua debugging utils via Snacks ([a31255d](https://github.com/dkarter/dotfiles/commit/a31255dcd559098987b28e38122adee77693ba33))
* **nvim:** disable flash backdrop and enable fFtT;, ([d1b56a5](https://github.com/dkarter/dotfiles/commit/d1b56a59e8cb3a4424b4159f6ade3dbd7ed1977a))
* **task:** add alias for dot:sync ([5a4b1d0](https://github.com/dkarter/dotfiles/commit/5a4b1d012cd93425d43660391b457f518211d367))


### Bug Fixes

* **smug:** remove houston docker-compose tabs ([6088c26](https://github.com/dkarter/dotfiles/commit/6088c26def4834519958f5a936414bf2b5491bc1))
* **task:** add task to install asdf ([0049058](https://github.com/dkarter/dotfiles/commit/0049058a4803dbb4ebd57d08500a0156fffeaa21))
* **task:** correct path for shell tasks ([c7e45ab](https://github.com/dkarter/dotfiles/commit/c7e45abf10272e58dccb5c7b6a363f731b544c1b))
* **task:** improve installer ([703b121](https://github.com/dkarter/dotfiles/commit/703b121bd66bccdfab7d53a72776cb275758fa8e))
* **task:** install asdf when already installed ([d6e8647](https://github.com/dkarter/dotfiles/commit/d6e86470d2d843f747a5e1295ba6ade3f10e21ba))
* **task:** install zinit plugins on dot install ([d7ea0c8](https://github.com/dkarter/dotfiles/commit/d7ea0c8c08d791ec63409e9ef6db789c45b90781))


### Code Refactoring

* **nvim:** improve treesitter textobj mappings ([8806d0a](https://github.com/dkarter/dotfiles/commit/8806d0a28aa544d6ea9b796bea74202b5597e886))

## [18.12.0](https://github.com/dkarter/dotfiles/compare/v18.11.0...v18.12.0) (2024-11-28)


### Features

* **nvim:** add nushell lsp support ([bf01896](https://github.com/dkarter/dotfiles/commit/bf018969a05a91e79f25562cdc1c9f592e0749b7))
* **zsh,cli:** add dust (du alternative) ([9ef8ecc](https://github.com/dkarter/dotfiles/commit/9ef8eccf18eb6e6e0da4a3199e83ce7af464c20e))
* **zsh:** add colors for common tools ([bbe480a](https://github.com/dkarter/dotfiles/commit/bbe480a390855bcff7900d8edb90c40cce2e1f74))
* **zsh:** add gan alias for git add -N ([514d8f7](https://github.com/dkarter/dotfiles/commit/514d8f76ddf133e2a8c26ddc7518327154fec4f8))


### Bug Fixes

* **zsh,carapace:** add overlay for git checkout and reset ([2cdf00e](https://github.com/dkarter/dotfiles/commit/2cdf00ee6e6cbe83aa56921eca51ae3935ffd82a))

## [18.11.0](https://github.com/dkarter/dotfiles/compare/v18.10.0...v18.11.0) (2024-11-23)


### Features

* **nvim:** add mapping for twilight ([4c02363](https://github.com/dkarter/dotfiles/commit/4c023639425024f1e86ebc7c33d3e4e505f04b28))
* **nvim:** add vimux mappings ([93c2f9f](https://github.com/dkarter/dotfiles/commit/93c2f9fdefaa4f22a52579544f78ac719f9a20b4))


### Performance Improvements

* **task:** run sync deps in parallel ([66828e2](https://github.com/dkarter/dotfiles/commit/66828e294e91ad747e6c40b595eedd6f426e5fb4))

## [18.10.0](https://github.com/dkarter/dotfiles/compare/v18.9.0...v18.10.0) (2024-11-18)


### Features

* **brew:** add carapace ([88b05d8](https://github.com/dkarter/dotfiles/commit/88b05d85e9f22082f268435da0dab81f415f0726))
* **installer:** add completions for pipx ([b74425a](https://github.com/dkarter/dotfiles/commit/b74425a5d23a46da2331a6890822bf6371235f38))
* **installer:** add zellij config ([aa0d2cf](https://github.com/dkarter/dotfiles/commit/aa0d2cf7e7319a5875f58420ed528e4f5349205f))
* **lazygit:** add config ([45a3a13](https://github.com/dkarter/dotfiles/commit/45a3a1300f36dedf145f964b28acb90726457192))
* **nvim:** add dadbod.nvim ([de0bdf8](https://github.com/dkarter/dotfiles/commit/de0bdf8c2d66ec5ee46b3e50b5ff31377ab2dcf2))
* **task:** add default task ([ee3333c](https://github.com/dkarter/dotfiles/commit/ee3333c4ff7a706d66814ccac4c82baf613c31a8))
* **task:** add zinit plugin update task ([96c641d](https://github.com/dkarter/dotfiles/commit/96c641d1e46f517e8f4fd345907b5bbbd6f18032))


### Bug Fixes

* **lazygit:** improve config + add custom command ([dea5c0b](https://github.com/dkarter/dotfiles/commit/dea5c0ba5bf7d3bae3fa7bf22ab285b311401a6f))
* **nvim:** gitsigns hunk nav deprecation ([1533bb0](https://github.com/dkarter/dotfiles/commit/1533bb008b7dec86c7cd578ae8ab92f200f9a5ab))
* **nvim:** snacks breaking changes + remove terminal ([a69e034](https://github.com/dkarter/dotfiles/commit/a69e0344db001004f520c5a60de096fcc7f36832))
* **task:** improve dotfiles install task ([ecdef8a](https://github.com/dkarter/dotfiles/commit/ecdef8afa9c80b302ca0a39cd054a8719b7a6328))
* **task:** relative dirs for internal includes ([133e4b5](https://github.com/dkarter/dotfiles/commit/133e4b598807e78fc8e01336415ac145cd5a6a9d))
* **zsh:** change lg alias to lazygit ([53a0b41](https://github.com/dkarter/dotfiles/commit/53a0b41d163cc1e9e70beda81e691e720a3c45de))
* **zsh:** path conflicts btw Brew and ASDF ([40f8f0b](https://github.com/dkarter/dotfiles/commit/40f8f0b7ecbdfd1c2244988c3058017dd9149501))

## [18.9.0](https://github.com/dkarter/dotfiles/compare/v18.8.1...v18.9.0) (2024-10-31)


### Features

* **nvim:** add `am` and `im` text objects for `inner module` `a module` ([ddd9031](https://github.com/dkarter/dotfiles/commit/ddd9031c2e2222dfe5356d9c51f052fba3a1bc82))


### Bug Fixes

* **bat:** rebuild cache on dotfiles sync ([88dc54c](https://github.com/dkarter/dotfiles/commit/88dc54c9df6ab8d17504d7ff56b7c18fd897492e))
* **nvim:** move create alternate file prompt to popup ([0aed16e](https://github.com/dkarter/dotfiles/commit/0aed16e1468cbf0cc65017a1377dc3f7ad443320))
* **nvim:** search hidden files in live grep ([c8be7dd](https://github.com/dkarter/dotfiles/commit/c8be7dd8b07be84ecd50c6de2ae7a7778ccb496f))

## [18.8.1](https://github.com/dkarter/dotfiles/compare/v18.8.0...v18.8.1) (2024-10-28)


### Bug Fixes

* **task:** use correct author for renovate ([8bc2b9d](https://github.com/dkarter/dotfiles/commit/8bc2b9dee197d54d9c3b1ca65ab3965aadf7703a))

## [18.8.0](https://github.com/dkarter/dotfiles/compare/v18.7.0...v18.8.0) (2024-10-27)


### Features

* **brew:** add graphviz ([775f931](https://github.com/dkarter/dotfiles/commit/775f9319c2e24ee11702b9328ed856ab5c2ebfdb))
* **nvim:** add deno support ([1a1c2c6](https://github.com/dkarter/dotfiles/commit/1a1c2c69c97530785c3a45cfdcd9414f72eed56a))
* **nvim:** add fold markers ([ab0934b](https://github.com/dkarter/dotfiles/commit/ab0934bdb5c5602e1b22589e7b45e036e82add0f))
* **nvim:** add JSON sigil ([736f7f5](https://github.com/dkarter/dotfiles/commit/736f7f5583e41aaeb6b6931e04778494685d922e))
* **nvim:** add stay-centered plugin ([be199f0](https://github.com/dkarter/dotfiles/commit/be199f0a70214167731a8a3c46121179dab3f9b0))
* **nvim:** improve oil.nvim config ([84e22dd](https://github.com/dkarter/dotfiles/commit/84e22ddc1060d8ee2e5dfb96bbe788393707551b))
* **sesh,smug:** add border_bound ([5fefc3d](https://github.com/dkarter/dotfiles/commit/5fefc3defc8a14ebc8885d2a76abfc1d5b2dfc9a))
* **task:** add tmux tasks to dotfile sync ([cb8af61](https://github.com/dkarter/dotfiles/commit/cb8af61935b5a4e3777dcb7bb52ff42e5fad5ce4))
* **tmux:** add regex for files without a dir ([39138bb](https://github.com/dkarter/dotfiles/commit/39138bbeb3ad618805f6db2c6483400740052108))


### Bug Fixes

* **nvim:** disable codespell on oil buffers ([2c19d82](https://github.com/dkarter/dotfiles/commit/2c19d82c4c9324125e8acb58be83dfdbb8390839))
* **nvim:** improve oil mappings ([ebc0428](https://github.com/dkarter/dotfiles/commit/ebc0428645c7a4f098230eaf4c798f1fc983eef5))
* **oil:** improve oil.nvim config ([47bdd50](https://github.com/dkarter/dotfiles/commit/47bdd50980e6147098f5370203fdb4bc4b7d177b))
* **zsh:** set homebrew path as first ([4f616b9](https://github.com/dkarter/dotfiles/commit/4f616b93b99e03f33189d810441de1a7340d2034))

## [18.7.0](https://github.com/dkarter/dotfiles/compare/v18.6.0...v18.7.0) (2024-10-07)


### Features

* **brew:** add tmux-fingers ([63cb97e](https://github.com/dkarter/dotfiles/commit/63cb97eac23ff5a9deecd9cda84c6c2e7a3a1190))
* **tmux:** add tmux-open-nvim and tmux-fingers ([2212890](https://github.com/dkarter/dotfiles/commit/2212890ac4f805815837ff1733a06fdbce185b76))


### Bug Fixes

* **tmux:** file + line + col regex ([edc88a8](https://github.com/dkarter/dotfiles/commit/edc88a8dc2433b864773d7e19cfe8860bc78de1d))
* **tmux:** set default shell to zsh ([f72f767](https://github.com/dkarter/dotfiles/commit/f72f76783a2d696b96764f6cbcd60cb6b91fc51f))
* **tmux:** ton prioritize window ([eb25d8a](https://github.com/dkarter/dotfiles/commit/eb25d8a90703d524c71dbe09b861e78710999e09))

## [18.6.0](https://github.com/dkarter/dotfiles/compare/v18.5.0...v18.6.0) (2024-10-06)


### Features

* **task:** add gh:automerge:renovate ([ce90808](https://github.com/dkarter/dotfiles/commit/ce9080854f9300c934350611b72f31dc967bd5f0))
* **task:** add gh:release task ([0e21a5d](https://github.com/dkarter/dotfiles/commit/0e21a5daa8155495fdc1621750d58a1f2ceb09fe))


### Bug Fixes

* **task:** gh:release change search state to open ([35592d0](https://github.com/dkarter/dotfiles/commit/35592d0cdff8070e13e301f60669d16281f61468))

## [18.5.0](https://github.com/dkarter/dotfiles/compare/v18.4.0...v18.5.0) (2024-10-06)


### Features

* **brew,zsh:** add homebrew support for linux ([7d1b6ce](https://github.com/dkarter/dotfiles/commit/7d1b6cefcee00b198551e6bb4ad6b1e57ac4d619))
* **installer:** add sd ([c6e149b](https://github.com/dkarter/dotfiles/commit/c6e149b675a0dab561d4781b287912654d087d2d))
* **nvim:** add grapple and portal ([8ceb159](https://github.com/dkarter/dotfiles/commit/8ceb15909816961547275cff6358483bd190d6b1))
* **nvim:** add promql treesitter ([40bc911](https://github.com/dkarter/dotfiles/commit/40bc91188976971c6ebc8303c27577bbcdcc9f8c))
* **nvim:** add yaml injections for GH Actions + Prom AlertManger ([feba012](https://github.com/dkarter/dotfiles/commit/feba01293f16b4bb588e173488c788a02a22a383))
* **zsh:** add chkint to check internet connection ([b7b7749](https://github.com/dkarter/dotfiles/commit/b7b7749fc449490d1f6325caf71242a7470d5eb3))


### Bug Fixes

* **nvim:** attempt to fix vscode-js-debug ([183d026](https://github.com/dkarter/dotfiles/commit/183d02680fb4651328292e83937a4055094cfd3f))
* **nvim:** improve Taskfile injections ([ae11b38](https://github.com/dkarter/dotfiles/commit/ae11b38a89c1296276e82121454aff0e14e74313))
* **zsh:** add sleep to pingf to slow it down a bit ([e0a7cb2](https://github.com/dkarter/dotfiles/commit/e0a7cb2e98985ee7cfbada9cb9282362664b5716))

## [18.4.0](https://github.com/dkarter/dotfiles/compare/v18.3.0...v18.4.0) (2024-09-26)


### Features

* **zsh,fzf:** add history search preview ([9fd0c5e](https://github.com/dkarter/dotfiles/commit/9fd0c5ecede8a9e93b7ff6f3b48504369ac2af62))


### Bug Fixes

* **installer:** use --locked for rust packages ([7dd4059](https://github.com/dkarter/dotfiles/commit/7dd40590d08a9909da9224a56c9e1f34d2134e62))
* **task:** only run sync:brew on darwin ([d85120c](https://github.com/dkarter/dotfiles/commit/d85120c4f4bfaa686c9903e77ea77a7263c7cbcb))
* **zsh,fzf:** enable zsh fzf integration in insert mode ([e5e13b1](https://github.com/dkarter/dotfiles/commit/e5e13b1bb16dba273cda29b4eb82029c59bf77d6))

## [18.3.0](https://github.com/dkarter/dotfiles/compare/v18.2.0...v18.3.0) (2024-09-17)


### Features

* **nvim:** auto install powershell language server ([76a76ea](https://github.com/dkarter/dotfiles/commit/76a76ea8de085ad49c4ff29c7f660ca9cfc44ead))
* **tmux,wezterm,sesh:** add &lt;prefix&gt;L / <super>L toggle last session ([6df0418](https://github.com/dkarter/dotfiles/commit/6df0418c04219551f916f11a7354f49b5677f64a))


### Bug Fixes

* **conform:** attempt to fix format commands disappearing ([6b77704](https://github.com/dkarter/dotfiles/commit/6b777042b598750eb3677de5f97fd54dbaaa5e33))

## [18.2.0](https://github.com/dkarter/dotfiles/compare/v18.1.2...v18.2.0) (2024-09-12)


### Features

* **nvim:** add delete all comments in buffer mapping ([7b5c463](https://github.com/dkarter/dotfiles/commit/7b5c4638f9768acc124906b0beb11e878610d6e9))


### Bug Fixes

* **nvim:** improve comment.nvim loading ([ff009ed](https://github.com/dkarter/dotfiles/commit/ff009ed2fe97958a151b25e68a19a7309775e6d6))

## [18.1.2](https://github.com/dkarter/dotfiles/compare/v18.1.1...v18.1.2) (2024-09-05)


### Bug Fixes

* **nvim:** checkout vscode-js-debug after install ([a19258a](https://github.com/dkarter/dotfiles/commit/a19258af53e6e851155b50935ef6edc49651e079))
* **starship:** remove requirement for KUBECONFIG for context prompt ([a3ff747](https://github.com/dkarter/dotfiles/commit/a3ff7473b90f8e4dc3859a7e1f3b5d8b4190a127))

## [18.1.1](https://github.com/dkarter/dotfiles/compare/v18.1.0...v18.1.1) (2024-09-02)


### Bug Fixes

* **nvim:** disable markdown nested checkboxes ([e966685](https://github.com/dkarter/dotfiles/commit/e966685cdfc952a4e593c4f6ad21b43c50b05a3c))

## [18.1.0](https://github.com/dkarter/dotfiles/compare/v18.0.0...v18.1.0) (2024-08-30)


### Features

* **brew:** add smug ([20075c7](https://github.com/dkarter/dotfiles/commit/20075c77f7ff8bc54bc08ba5a6bb38710eb09365))
* **smug:** add smug sesh integration ([8418c98](https://github.com/dkarter/dotfiles/commit/8418c980089cac90fe50d8575496fbb330394583))
* **task:** add tasks for tmux plugin management ([4216d48](https://github.com/dkarter/dotfiles/commit/4216d4816166a9aaeb09769c29dce2a47aafab95))
* **task:** reload tmux ([d75e5de](https://github.com/dkarter/dotfiles/commit/d75e5de1791c4efd4c721a715d4c6b113d4543d4))


### Bug Fixes

* **task:** use correct order of steps for sync task ([c57be41](https://github.com/dkarter/dotfiles/commit/c57be416db6b9bcc7a03f3fa9560fa5bf36bdcc6))
* **tmux,sesh,smug:** remove duplicates due to smug ([b3d4c71](https://github.com/dkarter/dotfiles/commit/b3d4c71a7aabc84c122700671c5591803d2df25e))
* **tmux:** correct tmux config path name in notif ([c4fa0ba](https://github.com/dkarter/dotfiles/commit/c4fa0ba638f73d411dd82a26a910d60eb35cf756))
* **zsh:** fix the t alias ([2ac007a](https://github.com/dkarter/dotfiles/commit/2ac007a55838c3afe9461736bde6403df781401d))


### Performance Improvements

* **nvim:** lazy load autotag on insertenter ([6a0a3fb](https://github.com/dkarter/dotfiles/commit/6a0a3fb7d3f27df3afa3350cbb01c5845aa15c78))

## [18.0.0](https://github.com/dkarter/dotfiles/compare/v17.1.0...v18.0.0) (2024-08-26)


### ⚠ BREAKING CHANGES

* **nvim:** change parameter (arg) text object to ia / aa

### Features

* **nvim:** add goip for ordering/sorting inside a paragraph ([6fddb73](https://github.com/dkarter/dotfiles/commit/6fddb735c94f6e2eacc77ef2a91fad7118594dcf))
* **nvim:** add nextls config (disabled) ([b972b05](https://github.com/dkarter/dotfiles/commit/b972b05f7de468290df2185159edb9019184add7))
* **zsh:** add treep and gtreep for paginated tree view with color ([506f8bf](https://github.com/dkarter/dotfiles/commit/506f8bfca92482ba22f5faa7d8169f7fea1be6a2))


### Bug Fixes

* **nvim:** hide "No information available" notifs from LSPs ([f279248](https://github.com/dkarter/dotfiles/commit/f27924870a00d3293000f3a24f36a1315f174898))
* **nvim:** temporarily remove erlang-ls from mason ([dfc16de](https://github.com/dkarter/dotfiles/commit/dfc16de5cc8b921abc8e6d6cebdd7c036f020b0e))
* **yamllint:** improve config for empty brackets/braces ([84bef98](https://github.com/dkarter/dotfiles/commit/84bef98d3766f8873f17180cb588ff368bf00380))


### Code Refactoring

* **nvim:** change parameter (arg) text object to ia / aa ([7e92333](https://github.com/dkarter/dotfiles/commit/7e923336c8e9f8d3eaa27915d8805391aca5c80c))

## [17.1.0](https://github.com/dkarter/dotfiles/compare/v17.0.0...v17.1.0) (2024-08-17)


### Features

* **git:** add git clear alias for git clean -id ([5741245](https://github.com/dkarter/dotfiles/commit/5741245c0d5dbc6f5c6be100c5c120ebc6939b84))
* include sync brew in dotfiles sync ([0901eb1](https://github.com/dkarter/dotfiles/commit/0901eb1764f0bb0c00a13fd85d3d2a6b5641294c))
* **installer:** add hyperfine ([b2e658b](https://github.com/dkarter/dotfiles/commit/b2e658b15fd5c7bdb3863613e3a95f06624ee279))
* **nvim:** add git_config treesitter parser ([57bd153](https://github.com/dkarter/dotfiles/commit/57bd153f44d05538d4afc5f98b1a71bcaff77c10))
* **nvim:** add terraform formatting ([d52adc3](https://github.com/dkarter/dotfiles/commit/d52adc39cbbfc7894e381d723a0e242c01ab7c99))
* **nvim:** add terraform syntax support ([31c0bb5](https://github.com/dkarter/dotfiles/commit/31c0bb54b88e354d72395893b9686399d785069e))
* **zsh:** add alias for resetting Elixir test db ([ed920f1](https://github.com/dkarter/dotfiles/commit/ed920f1762c1072830fecbd3718baef37230aca6))
* **zsh:** add bathelp ([e1d17eb](https://github.com/dkarter/dotfiles/commit/e1d17eb67eeaed480f9d6508c5c4953ed3af4c79))


### Bug Fixes

* **installer:** disable parallelism on asdf plugin add ([d84307d](https://github.com/dkarter/dotfiles/commit/d84307dee0cb812212192b2e77b66612020c07e1))
* **nvim:** disable indentscope animation ([7f7bb7c](https://github.com/dkarter/dotfiles/commit/7f7bb7c7caa166335cf8b51870a2dd22bf2db6b9))
* **nvim:** ignore certain files in fuzzy finding tools ([c0d27ce](https://github.com/dkarter/dotfiles/commit/c0d27ce0fd921700e0e540071f4ef56bc8548f6e)), closes [#48](https://github.com/dkarter/dotfiles/issues/48)
* **nvim:** use correct root when formatting Elixir ([428123d](https://github.com/dkarter/dotfiles/commit/428123dec6f874602ef3907424ffb73c63b8504f))

## [17.0.0](https://github.com/dkarter/dotfiles/compare/v16.4.0...v17.0.0) (2024-08-04)


### ⚠ BREAKING CHANGES

* **nvim:** remove `gs` mapping for sorting (use `go` instead)
* **nvim:** improve DAP mappings

### Features

* **installer:** add ast-grep ([83cf058](https://github.com/dkarter/dotfiles/commit/83cf058783a796d0595eac3535d93902c6215ce8))
* **installer:** add generate completions step ([561ce88](https://github.com/dkarter/dotfiles/commit/561ce882ba880cfc7af6a9efed5b3c0d54f1ad52))
* **installer:** add rnr cargo ([d22a44e](https://github.com/dkarter/dotfiles/commit/d22a44e835ed2d4b65079d12845712f2b93efaa8))
* **nvim:** add bash debugger ([361ab0f](https://github.com/dkarter/dotfiles/commit/361ab0f3e3921d18a97c5fc3e1469dd6140e3d7b))
* **nvim:** add editorconfig treesitter parser ([0740f13](https://github.com/dkarter/dotfiles/commit/0740f13573716131cc1c8ae4b862f1c87998457d))
* **nvim:** add mason link to homepage ([e17ec14](https://github.com/dkarter/dotfiles/commit/e17ec14b0955d3d4c84f2d0d3da6f31dc63aacf6))
* **nvim:** add sort.nvim ([f479785](https://github.com/dkarter/dotfiles/commit/f47978581edf88b107012b410a44b48a15e6d67f))
* **nvim:** add telescope frecency ([339bc59](https://github.com/dkarter/dotfiles/commit/339bc594584ee39f84c63f0b127a9757698392c9))
* **nvim:** add working js/ts debugger ([632ba0c](https://github.com/dkarter/dotfiles/commit/632ba0c889da77346c9ec31205681f3934dfa4e9))
* **nvim:** enable vim-matchup treesitter integration ([abce252](https://github.com/dkarter/dotfiles/commit/abce252f1afaa37a107657c2cd6a0f8009e88a04))
* **starship:** update config ([e7ce243](https://github.com/dkarter/dotfiles/commit/e7ce24315e4ac6a7c455fc389ce1afcd98cb8711))


### Bug Fixes

* **installer:** compinit didn't work ([54b1070](https://github.com/dkarter/dotfiles/commit/54b1070a51d60a193f01105cbbfe983c96d58565))
* **nvim:** automatically insert comment leader for all languages ([636e694](https://github.com/dkarter/dotfiles/commit/636e694b9c1b5876460c616e8483bf006b7d9eb8))
* **nvim:** disable autoindent on treesitter langs ([93bdf47](https://github.com/dkarter/dotfiles/commit/93bdf4713000bea6e4e54576d290fdbfd4bc541b))
* **nvim:** disable treesitter folding for some fts ([22a9341](https://github.com/dkarter/dotfiles/commit/22a93418b874c3e5183df83083b1073c6b8acfe1))
* **nvim:** force stable version of coerce ([d134b9d](https://github.com/dkarter/dotfiles/commit/d134b9de991404044e0167e5e5cd6824f153d458))
* **nvim:** improve DAP mappings ([a16492f](https://github.com/dkarter/dotfiles/commit/a16492fbe422a197c0c08a57c5bc637f09a3cda9))
* **nvim:** lazy load cmp when entering cmdline ([a5c6ac8](https://github.com/dkarter/dotfiles/commit/a5c6ac862ab3205b6c3d24bbe9526e955a03482e))
* **nvim:** only disable folds within a specific buffer ([21d70b6](https://github.com/dkarter/dotfiles/commit/21d70b6bbc5391f87c33e99ab839eddfafd11774))
* **nvim:** remove conform formatexpr ([252bea5](https://github.com/dkarter/dotfiles/commit/252bea5177da59467fec1be25b28e85f4aac5c78))
* **nvim:** update config for mason-nvim-dap ([fa88712](https://github.com/dkarter/dotfiles/commit/fa88712fbb8a36c4a9006a32d2c3f20790fa752a))
* **starship:** disable lua plugin ([441019f](https://github.com/dkarter/dotfiles/commit/441019f230babea45b4b7b0971cc6f9a55a378b4))
* temporarily use my treesitter fork ([2441804](https://github.com/dkarter/dotfiles/commit/244180444186f438f2a66d4a5bfc6242f410f33b))
* **zinit:** switch to my fork of kube-aliases ([860f06b](https://github.com/dkarter/dotfiles/commit/860f06b06b1f920ebf2801bd92901463c7ef0817))


### Performance Improvements

* **nvim:** improve Elixir lazy loading ([10996a5](https://github.com/dkarter/dotfiles/commit/10996a55cf7ee306f6b3de4dc48655eb3bca9a2e))
* **nvim:** improve lazy loading ([6671f01](https://github.com/dkarter/dotfiles/commit/6671f01a805e7246e4feaec25075be83da44efdd))
* **nvim:** improve lazy loading of treesitter plugins ([297c5d5](https://github.com/dkarter/dotfiles/commit/297c5d57f731dbfc235e77486347cdffec4971ed))


### Miscellaneous Chores

* **nvim:** remove `gs` mapping for sorting (use `go` instead) ([ff2d7e5](https://github.com/dkarter/dotfiles/commit/ff2d7e524bf3ae2c8a91f8f4b63d0c6ebead64bd))

## [16.4.0](https://github.com/dkarter/dotfiles/compare/v16.3.0...v16.4.0) (2024-07-26)


### Features

* **nvim:** add nvim-dap for step debugging ([bffe799](https://github.com/dkarter/dotfiles/commit/bffe799b2de956d77648406ddc665d8900f5c6b5))
* **nvim:** improve auto-complete for lua files using lazydev.nvim ([f471a87](https://github.com/dkarter/dotfiles/commit/f471a879b26f80673a03c6fb69cd0b8f6743dd3d))


### Bug Fixes

* **nvim:** automatically load types on LazyKeys ([457bdc8](https://github.com/dkarter/dotfiles/commit/457bdc8e1ac13e2a32043c71eed8639f49f963ad))

## [16.3.0](https://github.com/dkarter/dotfiles/compare/v16.2.0...v16.3.0) (2024-07-26)


### Features

* **installer:** run asdf install as part of sync ([11ea2aa](https://github.com/dkarter/dotfiles/commit/11ea2aa6d5f30c750ec6384fa5882f50b912f832))


### Bug Fixes

* **installer:** improve asdf commands so they can be run as part of sync ([7335ebd](https://github.com/dkarter/dotfiles/commit/7335ebd6bda8560cf4fbf370530b0d4a747946fb))
* **installer:** install nodejs lts version ([aaa3405](https://github.com/dkarter/dotfiles/commit/aaa34052b4b6bd5b52365eb157c94d659abe39cf))
* **installer:** remove --locked from cargo install ([f850376](https://github.com/dkarter/dotfiles/commit/f8503762a46f4b7576c5f7a2e0d5c410274da6a6))
* **installer:** remove OpenPGP key import for ASDF node ([9ac8464](https://github.com/dkarter/dotfiles/commit/9ac84648d2eac7c649ca14d63c2759cf2fdfe819))
* **task:** sync dotfiles now syncs asdf and installs pnpm ([52d6aea](https://github.com/dkarter/dotfiles/commit/52d6aea08e15b6c8e3c041f0569329b58962379b))


### Performance Improvements

* **installer:** run asdf reshim in parallel ([43a76cd](https://github.com/dkarter/dotfiles/commit/43a76cdfb97557461370e57ec3c18d3820ca31ff))

## [16.2.0](https://github.com/dkarter/dotfiles/compare/v16.1.0...v16.2.0) (2024-07-25)


### Features

* **installer:** add cargo install-update and cargo show subcommands ([b67bfed](https://github.com/dkarter/dotfiles/commit/b67bfed41909c8416786bf1d9df322fab1daf130))
* **installer:** sync task now installs + updates external packages ([7c49c09](https://github.com/dkarter/dotfiles/commit/7c49c09f41c54d12320b29db07299df1d5bc6389))


### Bug Fixes

* **nvim:** disable bullets-vim outline levels ([6dd0577](https://github.com/dkarter/dotfiles/commit/6dd0577eb106d91f7b87aee15939cb18807ee4d5))
* **nvim:** increase timeout for mix format ([39b1cf8](https://github.com/dkarter/dotfiles/commit/39b1cf8a3aa691788376af0e5f2d84b5f4ef62a1))


### Performance Improvements

* **installer:** only update cargo crates if outdated ([0284de0](https://github.com/dkarter/dotfiles/commit/0284de0e6e878837bbd98ac6a704c77058bff0ad))

## [16.1.0](https://github.com/dkarter/dotfiles/compare/v16.0.0...v16.1.0) (2024-07-22)


### Features

* **installer:** install go-task on debian ([fc5f3b9](https://github.com/dkarter/dotfiles/commit/fc5f3b9ad193050146928b17f1da0804b32d78cf))

## [16.0.0](https://github.com/dkarter/dotfiles/compare/v15.1.0...v16.0.0) (2024-07-22)


### ⚠ BREAKING CHANGES

* **nvim:** move plugins to individual files
* **nvim:** remove FzfRg + fzf plugin
* **alacritty:** delete config

### Features

* **nvim:** add gitsigns code actions ([4cdf5cf](https://github.com/dkarter/dotfiles/commit/4cdf5cfa3d04400a46a554523439f2254e00bd15))
* **nvim:** add markdown.nvim ([305c4f7](https://github.com/dkarter/dotfiles/commit/305c4f76a817e83a958efcab59be928c0fac5513))


### Bug Fixes

* **gitignore:** ignore .ruby-lsp folder ([b5b1e29](https://github.com/dkarter/dotfiles/commit/b5b1e2968fd08d3ba3bd50df82762bce4733b802))
* **installer:** always update cargo packages ([6c3c016](https://github.com/dkarter/dotfiles/commit/6c3c016f617805e278f5e8db30764644e4b10d36))
* **installer:** automatically upgrade gh extensions ([6111d0e](https://github.com/dkarter/dotfiles/commit/6111d0eaa191d35f08577c8a1e140c5bedc9edbc))
* **installer:** install cargos locked ([c7ee177](https://github.com/dkarter/dotfiles/commit/c7ee17748b35776a359a23732af0c7c3162b9d9e))
* **nvim:** format files via LSP if supported ([281c8b6](https://github.com/dkarter/dotfiles/commit/281c8b6d82ea8923867f33b327cfd79f51cbf727))


### Miscellaneous Chores

* **alacritty:** delete config ([ef13119](https://github.com/dkarter/dotfiles/commit/ef13119764385d62084ef76294023f1fdf141af0))
* **nvim:** remove FzfRg + fzf plugin ([98ddf32](https://github.com/dkarter/dotfiles/commit/98ddf32479d4b1c3ba0b1dea0f5a4773e294ca00))


### Code Refactoring

* **nvim:** move plugins to individual files ([df581e2](https://github.com/dkarter/dotfiles/commit/df581e23e0b76bba4a4bb3cdfafc82b04cbd1ba4))

## [15.1.0](https://github.com/dkarter/dotfiles/compare/v15.0.0...v15.1.0) (2024-07-14)


### Features

* **installer:** automate CAPSLOCK -&gt; Escape remapping on macOS ([1f5f79c](https://github.com/dkarter/dotfiles/commit/1f5f79c713aa1a2978f2b5b982fc5d4434915cbd))
* **nvim:** add plist filetype support ([d644e8b](https://github.com/dkarter/dotfiles/commit/d644e8b5ab3f43b9c19d4b344fa5572cd5e95b12))
* **task:** add task for committing Brewfile.lock.json ([48a8536](https://github.com/dkarter/dotfiles/commit/48a8536ac493ed8814ca4bf91a9c38ad10da5c84))

## [15.0.0](https://github.com/dkarter/dotfiles/compare/v14.2.0...v15.0.0) (2024-07-13)


### ⚠ BREAKING CHANGES

* **nvim:** change trouble symbol sidebar mappings

### Features

* **brew:** add figlet and lolcat ([c3d0338](https://github.com/dkarter/dotfiles/commit/c3d033824d6354d4e01b82f6f75ac2332e25d314))
* **nvim:** add projections to support PDQ codebase ([096d852](https://github.com/dkarter/dotfiles/commit/096d852411021e37a3e3134f44643228284b1957))


### Bug Fixes

* **nvim:** support which-key v3 ([ac6d4ce](https://github.com/dkarter/dotfiles/commit/ac6d4ce864d557cee4bb4dd54c4c8d8321c0fe7e))
* **task:** rename `install:asdf` -&gt; `sync:asdf` ([27c06b7](https://github.com/dkarter/dotfiles/commit/27c06b7a1b5ff7f309e6727a89c79cd730b225f9))


### Code Refactoring

* **nvim:** change trouble symbol sidebar mappings ([c77c601](https://github.com/dkarter/dotfiles/commit/c77c6014958a77d8569dbb2f846b827d2250d2c9))

## [14.2.0](https://github.com/dkarter/dotfiles/compare/v14.1.0...v14.2.0) (2024-07-10)


### Features

* **gh:** add github dash config ([d29de1c](https://github.com/dkarter/dotfiles/commit/d29de1c7a25b45aa0524233e80cb6a45cd4f81dc))


### Bug Fixes

* **nvim:** remove lush ([3699a89](https://github.com/dkarter/dotfiles/commit/3699a8955ea3ab899e90fe835cc1b43226bd3e13))

## [14.1.0](https://github.com/dkarter/dotfiles/compare/v14.0.0...v14.1.0) (2024-07-07)


### Features

* **gitui:** add gitui ([c5d80d0](https://github.com/dkarter/dotfiles/commit/c5d80d04df5d570fd8f1041f5c29932388fcf010))
* **nvim:** add MasonUpdateAll command ([83b55c9](https://github.com/dkarter/dotfiles/commit/83b55c9edd0a854a9178920f975fcead418e0d7b))
* **nvim:** disable indent-blankline for zenmode ([a9def15](https://github.com/dkarter/dotfiles/commit/a9def1591062bfd0141fca0f2a08346c0a027aa3))
* **nvim:** highlight taskfile commands as bash ([e6581be](https://github.com/dkarter/dotfiles/commit/e6581be2d8282d410343dc1ea9fa828c17a180e1))
* **task:** add sync:brew ([45045a9](https://github.com/dkarter/dotfiles/commit/45045a9a17784f3b37cdbd070b433919c24d2b11))
* **task:** add task to sync neovim ([45e5dec](https://github.com/dkarter/dotfiles/commit/45e5dec72b24fdeab9047444d5e477f6592dd004))
* **task:** automatically commit brew lock file on change ([4c2f7f4](https://github.com/dkarter/dotfiles/commit/4c2f7f4d453639eb70d946c321187661f3b5e3f1))
* **task:** task for committing nvim plugin updates ([e5ea0c8](https://github.com/dkarter/dotfiles/commit/e5ea0c8bdd65d95ed5c818fab279643c9c1512fb))


### Bug Fixes

* **nvim:** correctly set color scheme ([84e3c4a](https://github.com/dkarter/dotfiles/commit/84e3c4a1cff0d426a291f83529e7ed3cf05831c6))
* **nvim:** disable formatting with lua_ls ([22ded3a](https://github.com/dkarter/dotfiles/commit/22ded3a695c74ef31d2761d583e217a3cf4c52e9))
* **nvim:** disable relativenumber ([bdc0d7e](https://github.com/dkarter/dotfiles/commit/bdc0d7e78935a29b40bf0688de1d2f0cbb6a442d))
* **nvim:** disable relativenumber for zenmode too ([a403437](https://github.com/dkarter/dotfiles/commit/a40343778473992e4ec7276a600c57a97bcd4212))
* **nvim:** lualine theme was broken on direct file open ([646c085](https://github.com/dkarter/dotfiles/commit/646c085080305c5709f2f8b2e131da4c23f762c6))
* **zsh,pnpm:** add pnpm global support ([1a5c85f](https://github.com/dkarter/dotfiles/commit/1a5c85f47f1ee9d05f4a0f78654addba90cf4407))
* **zsh:** enable fzf shell integration ([2a2b975](https://github.com/dkarter/dotfiles/commit/2a2b975f34e3d1b5a7b1b52808fe9044b03e57aa))

## [14.0.0](https://github.com/dkarter/dotfiles/compare/v13.14.0...v14.0.0) (2024-07-01)


### ⚠ BREAKING CHANGES

* **nvim:** change neogen mapping to <leader>ng

### Features

* add HammerSpoon ([9d75ce6](https://github.com/dkarter/dotfiles/commit/9d75ce6efae3d2118551f1b9883bd81dc3ed018b))
* **hammerspoon:** add WindowLayoutMode custom spoon ([f0b78b6](https://github.com/dkarter/dotfiles/commit/f0b78b6be50089a84a6a5823603ac83d3197d7ee))
* **nvim:** add mapping for NvimTreeFindFileToggle ([67f41f8](https://github.com/dkarter/dotfiles/commit/67f41f852e9c0cf99b71f895283f8f7322bf1ef9))
* **nvim:** format Ruby using rubyfmt and rubocop ([c991ca3](https://github.com/dkarter/dotfiles/commit/c991ca313a6119974b88f164cb94367799505b3f))
* **nvim:** improve Cfd and Cfd! ([8e0a1b7](https://github.com/dkarter/dotfiles/commit/8e0a1b7fd49fb8e9079a16730b5680af621741de))
* **taskfile:** add install_sudo_touch_id task ([fba4fb3](https://github.com/dkarter/dotfiles/commit/fba4fb3706056607e7f96bbf619f0c0f19791a7d))


### Bug Fixes

* **brew:** remove deprecated sudo-touchid package ([3bc9f9f](https://github.com/dkarter/dotfiles/commit/3bc9f9feafb5da4cb64a003af01f859fb443bf87))
* **nvim:** add missing arg to nvim_set_option_value ([0bf15dc](https://github.com/dkarter/dotfiles/commit/0bf15dca8b59c3a97a1d778e242bfcce32062ae8))
* **nvim:** allow NvimTree to lazy load on NvimTreeFindFileToggle ([91bd163](https://github.com/dkarter/dotfiles/commit/91bd16366d5b2877dfc95c7a8dc8a2f3ed6dcd8b))
* **nvim:** temporarily ignore tmux treesitter ([c1ac175](https://github.com/dkarter/dotfiles/commit/c1ac175e8686b290abd4759f8bc49976392ff1ba))
* **stylua:** exclude spoons ([64d05b6](https://github.com/dkarter/dotfiles/commit/64d05b6cf98eb2692d6240a4776edee03becdf5a))


### Code Refactoring

* **nvim:** change neogen mapping to &lt;leader&gt;ng ([218ed5b](https://github.com/dkarter/dotfiles/commit/218ed5b3bf9c803df25ae92c73499b879c50c121))

## [13.14.0](https://github.com/dkarter/dotfiles/compare/v13.13.0...v13.14.0) (2024-06-21)


### Features

* **nvim:** add Rust projections ([8626c71](https://github.com/dkarter/dotfiles/commit/8626c71c8863bdc5dd8880d710363700361d149b))


### Bug Fixes

* **nvim:** add formatting for all supported LSPs ([f035f28](https://github.com/dkarter/dotfiles/commit/f035f2868bcbc6f9e09bf12f8408ec22102d114e))
* **nvim:** remove g map from home screen ([2fad939](https://github.com/dkarter/dotfiles/commit/2fad9390767b139bb51ed318a984fd1071ee3552))

## [13.13.0](https://github.com/dkarter/dotfiles/compare/v13.12.1...v13.13.0) (2024-06-15)


### Features

* **task:** add task for installing ollama ([add20e0](https://github.com/dkarter/dotfiles/commit/add20e0a076ff3b18db9cebedc102ac323fa1474))

## [13.12.1](https://github.com/dkarter/dotfiles/compare/v13.12.0...v13.12.1) (2024-06-15)


### Bug Fixes

* **nvim:** disable colorcolumn correctly in ZenMode ([50d25d2](https://github.com/dkarter/dotfiles/commit/50d25d24e496ada5b6a9be1835c6101be863783f))

## [13.12.0](https://github.com/dkarter/dotfiles/compare/v13.11.1...v13.12.0) (2024-06-15)


### Features

* **nvim:** set search engine for gx.nvim to Kagi ([3930d46](https://github.com/dkarter/dotfiles/commit/3930d46389e7d8f3170c556b2efa1fcf28ae669c))


### Bug Fixes

* **zsh:** export SSH_FINGERPRINT if key exists ([5655f67](https://github.com/dkarter/dotfiles/commit/5655f67fa357abad137a313212a15428097580c8))

## [13.11.1](https://github.com/dkarter/dotfiles/compare/v13.11.0...v13.11.1) (2024-06-13)


### Bug Fixes

* **codespell:** exclude additional files ([051a34f](https://github.com/dkarter/dotfiles/commit/051a34f432132e828f29d0d9a7c76b095a0409a8))
* ignore pnpm-lock.yaml in yamllint ([4752845](https://github.com/dkarter/dotfiles/commit/47528458e9892dab6283986d996067d1943aa8e8))
* **nvim:** add Mason cmd to lazy load triggers ([63690db](https://github.com/dkarter/dotfiles/commit/63690dbc1d79868282ebae4cc85ae2faae044ebb))
* **zsh:** put brew path at the end ([d9e594f](https://github.com/dkarter/dotfiles/commit/d9e594f242aab19849a581bae7d4814ff95acd55))

## [13.11.0](https://github.com/dkarter/dotfiles/compare/v13.10.0...v13.11.0) (2024-06-13)


### Features

* **brew:** add cleanshot cask ([68b5c81](https://github.com/dkarter/dotfiles/commit/68b5c81df79ed633de04ee9aaf94283222feddd4))
* **brew:** add hyperkey and obsidian ([2e3dff1](https://github.com/dkarter/dotfiles/commit/2e3dff1579168bc69915c3e92b4c87bc31c97597))
* **brew:** add iterm2 ([19c6ce0](https://github.com/dkarter/dotfiles/commit/19c6ce0386913e6043abaff73edee9563a19e6ab))
* **brew:** add raycast ([a86aa6d](https://github.com/dkarter/dotfiles/commit/a86aa6d312fed863eb52204975366cfc7f880439))
* **installer:** show battery percentage in menu bar ([44e2796](https://github.com/dkarter/dotfiles/commit/44e2796aaec8278d21bb3048b9361b8c75edc881))


### Bug Fixes

* **brew:** remove unused Alfred dependencies ([df6f235](https://github.com/dkarter/dotfiles/commit/df6f2358018b2d0035ab526d5e52adf6f83c9922))
* **installer:** add missing lua-language-server plugin ([cb73b0f](https://github.com/dkarter/dotfiles/commit/cb73b0f798fd58022bf1023d6254c4320542714c))
* **installer:** install xcode before unicornleap ([d85a956](https://github.com/dkarter/dotfiles/commit/d85a956b4b56ab59f2409481dc83d56fa6fc2336))
* **installer:** only install xcode if unicorn not installed ([ba9394b](https://github.com/dkarter/dotfiles/commit/ba9394bcf33230fce6b260b11003ce4a541e7b66))
* **installer:** remove unused ruby gems ([8d24bd1](https://github.com/dkarter/dotfiles/commit/8d24bd17524f02ae63b0ba3a661f934d4565c1cb))
* **nvim:** add commitlint to Mason ensure_installed ([b74c2b3](https://github.com/dkarter/dotfiles/commit/b74c2b37e7198dff742fab16afde29271457e0f2))


### Reverts

* "refactor(installer): use macos-trash instead of trash-cli" ([3b79004](https://github.com/dkarter/dotfiles/commit/3b7900453cedb8ca38e6e4bf7b1a29b0f95d9550))

## [13.10.0](https://github.com/dkarter/dotfiles/compare/v13.9.0...v13.10.0) (2024-06-10)


### Features

* **brew:** add sesh tmux session manager ([4ade0dc](https://github.com/dkarter/dotfiles/commit/4ade0dcb5cf58daf361e0a6cae9d9165cef0a46a))
* **nvim:** automatically switch dark/light mode ([5323862](https://github.com/dkarter/dotfiles/commit/5323862777e031f8c8d8db78afb5fdd2e0b40f76))
* **nvim:** display package update count on home screen ([26e2985](https://github.com/dkarter/dotfiles/commit/26e298517e423473438a98163f5eedf45825643c))


### Bug Fixes

* **debian,git:** add support for git singleKey ([33d8f08](https://github.com/dkarter/dotfiles/commit/33d8f08db1880dbc56e36b9f7aa644fae8b8701b))
* **installer:** ruby syntax was incorrect ([c12d881](https://github.com/dkarter/dotfiles/commit/c12d8814e5e968976b3ebd00477f05fb228b3f4b))
* **nvim:** remove autotag nvim setup from treesitter ([e7e97ea](https://github.com/dkarter/dotfiles/commit/e7e97ea94ff65f26eaf845f3931110c62afce9b1))
* **nvim:** trouble.nvim mappings for trouble v3 ([fa35c0c](https://github.com/dkarter/dotfiles/commit/fa35c0c130b90f48a5cd8ecf6e84a88a729b7021))

## [13.9.0](https://github.com/dkarter/dotfiles/compare/v13.8.0...v13.9.0) (2024-05-15)


### Features

* **nvim:** add a better git blame ([5a0f16a](https://github.com/dkarter/dotfiles/commit/5a0f16aa1e2c3f2ae9f7f0751673dea61dc51a1f))
* **nvim:** add experimental local LLM integration ([4366be4](https://github.com/dkarter/dotfiles/commit/4366be43dd9e3fa74bddb67088b7482022f3a0b2))
* **nvim:** enable rainbow flash.nvim markers ([a586f8a](https://github.com/dkarter/dotfiles/commit/a586f8a468a1989636302c5800fe5ee7d3a0cbac))


### Bug Fixes

* **nvim:** improve winbar ([5e521b8](https://github.com/dkarter/dotfiles/commit/5e521b8aba35a7711a312ab1fa4b0fbf3aabf489))

## [13.8.0](https://github.com/dkarter/dotfiles/compare/v13.7.1...v13.8.0) (2024-05-02)


### Features

* **nvim:** add zen mode ([d3e6e6c](https://github.com/dkarter/dotfiles/commit/d3e6e6c73e0c12aa41de7761d003284ecd3fc2c1))


### Bug Fixes

* **iterm:** update font to CaskaydiaCove ([9dbab84](https://github.com/dkarter/dotfiles/commit/9dbab84f66d070d6bc5e8111e94e534077e54d4e))

## [13.7.1](https://github.com/dkarter/dotfiles/compare/v13.7.0...v13.7.1) (2024-04-17)


### Bug Fixes

* **nvim:** disable tmux&lt;-&gt;nvim copy sync ([7b1c0a8](https://github.com/dkarter/dotfiles/commit/7b1c0a8c10ed41f4ad32944a5a700c3a404e6100))

## [13.7.0](https://github.com/dkarter/dotfiles/compare/v13.6.0...v13.7.0) (2024-04-10)


### Features

* **brew,zsh:** add Postgres client ([097e139](https://github.com/dkarter/dotfiles/commit/097e139ceda462cda2a7b4d9126f7cdd1bc05f2a))
* **nvim:** add tooling for python ([a2453ef](https://github.com/dkarter/dotfiles/commit/a2453efcefc5657fa5a8667bd5f3a13b26416686))
* **zsh:** add pgtmp alias ([36c4f86](https://github.com/dkarter/dotfiles/commit/36c4f86d39293e9718d5ee410ad471a106c4a0db))


### Bug Fixes

* **zsh:** add ARM support for $BREW_PREFIX ([1cfaa49](https://github.com/dkarter/dotfiles/commit/1cfaa49b890e0d4f53435cfc0a9b291956904753))

## [13.6.0](https://github.com/dkarter/dotfiles/compare/v13.5.2...v13.6.0) (2024-03-25)


### Features

* **nvim:** add neogen for generating annotations ([deeee68](https://github.com/dkarter/dotfiles/commit/deeee6848d51272db636b079e3cf1e36ef4ae3f2))
* **zsh:** add rmorig alias ([f158fcd](https://github.com/dkarter/dotfiles/commit/f158fcd745d9e5e245445c7eb085f531090a88b0))

## [13.5.2](https://github.com/dkarter/dotfiles/compare/v13.5.1...v13.5.2) (2024-03-21)


### Bug Fixes

* **nvim:** disable codespell on NvimTree buffer ([c769a00](https://github.com/dkarter/dotfiles/commit/c769a0057bd22bca15b1c10c611dea887842f3ad)), closes [#156](https://github.com/dkarter/dotfiles/issues/156)

## [13.5.1](https://github.com/dkarter/dotfiles/compare/v13.5.0...v13.5.1) (2024-03-19)


### Bug Fixes

* **nvim:** add filetype mapping for helmfile ([f5ec408](https://github.com/dkarter/dotfiles/commit/f5ec408929b93e8276a46c912676e4bd852ad9a6))
* **nvim:** replace prettierd with prettier ([5938c51](https://github.com/dkarter/dotfiles/commit/5938c51e1c4722b8ba3151d5e2468304bb3e8128))

## [13.5.0](https://github.com/dkarter/dotfiles/compare/v13.4.0...v13.5.0) (2024-03-05)


### Features

* **nvim:** add additional filetype mappings ([4a17b74](https://github.com/dkarter/dotfiles/commit/4a17b746b0349844383f7c1d9fa617ec37e0f889))


### Bug Fixes

* **nvim:** add improved helm file detection ([30c1e6b](https://github.com/dkarter/dotfiles/commit/30c1e6bca10782b7c7c9d6b84c567e3b0685631d))
* remove helm file detection ([998876b](https://github.com/dkarter/dotfiles/commit/998876bf8255b023b74e11c6c31b3b5af8c34601))

## [13.4.0](https://github.com/dkarter/dotfiles/compare/v13.3.1...v13.4.0) (2024-03-03)


### Features

* **installer:** add jless ([f4fce1b](https://github.com/dkarter/dotfiles/commit/f4fce1b9dcdf106a51090085e1075532ce181f9d))
* **nvim:** add Helm file support ([40aec36](https://github.com/dkarter/dotfiles/commit/40aec36b641685452baf9ddda19773ef189399a8))


### Bug Fixes

* disable prettier for ruby ([d26225b](https://github.com/dkarter/dotfiles/commit/d26225bc975f5563c3acfb1e28903d499b3b4498))
* **nvim:** replace deprecated none-ls built-ins with native LSPs ([ef02255](https://github.com/dkarter/dotfiles/commit/ef02255bd4afe697446fdafe0980ae75a157f59e))

## [13.3.1](https://github.com/dkarter/dotfiles/compare/v13.3.0...v13.3.1) (2024-02-02)


### Bug Fixes

* **installer:** rubocop lint ([fe683e1](https://github.com/dkarter/dotfiles/commit/fe683e1b4714dd93bcf6b6e62075e4c261c3a064))

## [13.3.0](https://github.com/dkarter/dotfiles/compare/v13.2.0...v13.3.0) (2024-02-01)


### Features

* **nvim:** add support for bash runnable scratch buffers ([9b59729](https://github.com/dkarter/dotfiles/commit/9b597291e2a69ebb6dbfc5bc8ea8f5ba676dbafe))
* **nvim:** change notifications to compact theme ([65689bb](https://github.com/dkarter/dotfiles/commit/65689bb05d82ddf0d2d8474f6456bf81f5fd75f7))
* **nvim:** re-add Flash, but without annoying features ([793cee0](https://github.com/dkarter/dotfiles/commit/793cee0ba0eb400001ce400a57739fecf11b33eb))
* **nvim:** support syntax injections for Elixir custom sigils ([7408e99](https://github.com/dkarter/dotfiles/commit/7408e99759921f49bbd12c7fa715423d2b5fdace))


### Bug Fixes

* **nvim:** disable incorrect diagnostic ([ea03eb3](https://github.com/dkarter/dotfiles/commit/ea03eb36dcb6b04dd8b21fa3accbfd74d66d313a))
* **wezterm:** don't adjust window size when changing font size ([dec63cf](https://github.com/dkarter/dotfiles/commit/dec63cfdde20c56cc7f99c80fef74a99ee1d3741))

## [13.2.0](https://github.com/dkarter/dotfiles/compare/v13.1.0...v13.2.0) (2024-01-29)


### Features

* **brew:** add go-task (aka Taskfile) ([62a46ec](https://github.com/dkarter/dotfiles/commit/62a46ec486d79e45911ae78b208eaae26d0226f1))
* **task:** add sync task ([fb96be2](https://github.com/dkarter/dotfiles/commit/fb96be2c8537062614ce4a0c9d122a36733cb78f))


### Bug Fixes

* **installer:** allow setup.sh to pass args to installer.rb ([2c5d89c](https://github.com/dkarter/dotfiles/commit/2c5d89c270018d26411be54b4d75e3f79281d8dd))
* **nvim:** gx.nvim mapping change for new version ([dc379d8](https://github.com/dkarter/dotfiles/commit/dc379d8a3862dbca88fd8b4b239aef9941e4a4ef))

## [13.1.0](https://github.com/dkarter/dotfiles/compare/v13.0.0...v13.1.0) (2024-01-10)


### Features

* **nvim:** automatically install TreeSitter parsers ([436aa8e](https://github.com/dkarter/dotfiles/commit/436aa8e0ad0c5bbd4f387cf1b05058e99925464b))
* **nvim:** lint ansible files ([71b075f](https://github.com/dkarter/dotfiles/commit/71b075fbce3fea72154d8e0906d050f77b1e30be))
* **nvim:** use relativenumber ([74a21d3](https://github.com/dkarter/dotfiles/commit/74a21d322bee301f333c814c4ce33f13aeeac200))
* **wezterm:** add mappings for move tab left / right ([9822080](https://github.com/dkarter/dotfiles/commit/9822080133f51ee2f8443055c4d217e057679f24))
* **zsh:** add nvims (NvimSwitcher utility) ([afc67b2](https://github.com/dkarter/dotfiles/commit/afc67b2312aef888d35d14d21b0cac156bf2813e))
* **zsh:** add pingf command ([53d7436](https://github.com/dkarter/dotfiles/commit/53d743660dde96b8ad8d16ed9d313a38cea78681))
* **zsh:** add prettyping (pping) ([0b847d1](https://github.com/dkarter/dotfiles/commit/0b847d1090480d8643e9a3fb559a4313146d5804))


### Bug Fixes

* **nvim:** jsonls: -32601: Unhandled method textDocument/diagnostic ([4c6bcce](https://github.com/dkarter/dotfiles/commit/4c6bcce0d120dbc1ba9cb2f76dad25c5213c0459))
* **nvim:** remove flash.nvim ([e85b622](https://github.com/dkarter/dotfiles/commit/e85b6228994acf54a593043074fbd220246e6c95))
* **nvim:** remove unnecessary code ([e086c65](https://github.com/dkarter/dotfiles/commit/e086c659caf276183d4117c99ec4d20b9688c6f0))
* **nvim:** type annotations ([9532bb0](https://github.com/dkarter/dotfiles/commit/9532bb0826d221e00e05d96e6270204ed23dc4b1))
* **tmux:** don't detach tmux when exiting session ([a6e5fbc](https://github.com/dkarter/dotfiles/commit/a6e5fbc8d2a774db04004f6ec562a7007f82f11c))
* **zsh:** humanize file sizes for erd ([f2bce37](https://github.com/dkarter/dotfiles/commit/f2bce372cdead1c9b0968e9af6126d85a6a9cc43))
* **zsh:** localip function was not working ([1ed625f](https://github.com/dkarter/dotfiles/commit/1ed625fa6d6076e22bf01dabd79ce7b7fa2eab2c))
* **zsh:** remove covid stuff ([cd85de2](https://github.com/dkarter/dotfiles/commit/cd85de2c9766b6c4482c70481fdd8a6cbfabd4eb))
* **zsh:** remove old alias to oh-my-zsh ([fcc1072](https://github.com/dkarter/dotfiles/commit/fcc1072f537c93aefabaa4d3f5d289054a2f4f21))
* **zsh:** remove unused aliases ([f217ddc](https://github.com/dkarter/dotfiles/commit/f217ddce3bcca9f00ddf4f70a8df21a1a39e2e1c))
* **zsh:** support killing pingf with SIGINT ([51c6c5b](https://github.com/dkarter/dotfiles/commit/51c6c5bba31977596d5dc742641cd27a1db47fb3))
* **zsh:** use erd for tree commands ([653d847](https://github.com/dkarter/dotfiles/commit/653d84779cf23b50d507ed636a5c5ce30b6e0de8))

## [13.0.0](https://github.com/dkarter/dotfiles/compare/v12.7.0...v13.0.0) (2023-12-18)


### ⚠ BREAKING CHANGES

* **tmux:** move tmux config to ~/.config/tmux

### Features

* **installer:** add gh-dash ([cd38432](https://github.com/dkarter/dotfiles/commit/cd38432233461c8627c2b4a8449acd232796c74d))
* **installer:** automate auto-hide dock on macOS ([289417c](https://github.com/dkarter/dotfiles/commit/289417ceead13a28c358f542a4643b54ba4188e5))
* **mac:** set additional defaults/disable annoyances ([6b6cf8f](https://github.com/dkarter/dotfiles/commit/6b6cf8fb2fc152856dbcf119e3b702f7721ba3cf))
* **tmux:** add CMD+u to open fzf url popup ([9a14d4b](https://github.com/dkarter/dotfiles/commit/9a14d4be90446d7dac383ee4969c4d891336a59b))
* **tmux:** add tmux session manager ([69e20e6](https://github.com/dkarter/dotfiles/commit/69e20e629ff79b77d39f3656d74777aa76e1276d))
* **tmux:** add tmux-fzf-url for opening urls using fzf ([98f9308](https://github.com/dkarter/dotfiles/commit/98f9308734310fbb4c67b0897b83106fcca938f1))
* **tmux:** open tmux-fzf-url in a tmux popup ([b5658bb](https://github.com/dkarter/dotfiles/commit/b5658bb6f08e44661c4699de8ab306b8a8c655cd))
* **wezterm:** add command palette keybinding + font size ([0fbc4f9](https://github.com/dkarter/dotfiles/commit/0fbc4f9a3a96de49e8e4ba6aa7ed36d5c8641b71))
* **wezterm:** add mapping to toggle opacity+blur ([cd0c644](https://github.com/dkarter/dotfiles/commit/cd0c644f29d28e506e8944410cffbb62c23181b4))
* **zsh:** add some tmux aliases ([81bdc93](https://github.com/dkarter/dotfiles/commit/81bdc93cbacb34557423a75567530fc8b7f1dd90))
* **zsh:** add vi mode with zvm ([704d018](https://github.com/dkarter/dotfiles/commit/704d01877224db34bda490f762286e1b97d66e3f))


### Bug Fixes

* remove accidentally committed tmux-nerd-font-window-name ([de0eed9](https://github.com/dkarter/dotfiles/commit/de0eed945a521030e068e3612cab43313fc6a800))
* **tmux:** remove tmux-thumbs (unused) ([deb2941](https://github.com/dkarter/dotfiles/commit/deb294174d8f4eaf51850b3c367ebeab1cb4f78c))
* **wezterm:** allow CMD+SHIFT+[/] to cycle tmux tabs ([e8e20ac](https://github.com/dkarter/dotfiles/commit/e8e20ac57e333cabad619add5842758cdcf68b65))
* **wezterm:** allow setting CMD+SHIFT+[\] ([660db2e](https://github.com/dkarter/dotfiles/commit/660db2eaeff82b3744e1b815a2887383080de658))
* **wezterm:** disable native tab bar (in favor of tmux) ([3e484be](https://github.com/dkarter/dotfiles/commit/3e484be3d370e890727bed3d932a058b7a1b336a))
* **wezterm:** disable window close confirmation ([1f80a0a](https://github.com/dkarter/dotfiles/commit/1f80a0a67f6f7e7b36ca668d4620e0b2b4ff1b82))


### Code Refactoring

* **tmux:** move tmux config to ~/.config/tmux ([dfb6c1f](https://github.com/dkarter/dotfiles/commit/dfb6c1f67fee70904d32b6ff2cc3a3f08ba50b4d))

## [12.7.0](https://github.com/dkarter/dotfiles/compare/v12.6.1...v12.7.0) (2023-12-10)


### Features

* **wezterm:** add wezterm config ([26d1a98](https://github.com/dkarter/dotfiles/commit/26d1a98ad6c9f78a6fb2cf06f7f1bf64c1f8016b))
* **wezterm:** use CaskaydiaCove patched fonts in wezterm ([39b14bc](https://github.com/dkarter/dotfiles/commit/39b14bcafcc3c488e01b0996ff024f2fb1a54358))


### Bug Fixes

* **psql:** improve config for pspg ([86937d2](https://github.com/dkarter/dotfiles/commit/86937d277f08deaca882eb1c307152c7764cb8ea))

## [12.6.1](https://github.com/dkarter/dotfiles/compare/v12.6.0...v12.6.1) (2023-11-27)


### Bug Fixes

* **nvim:** remove lazy loading for treesitter ([5c41011](https://github.com/dkarter/dotfiles/commit/5c4101129c0e02a54d8caa3835aa62b5d3edbbc3))

## [12.6.0](https://github.com/dkarter/dotfiles/compare/v12.5.0...v12.6.0) (2023-11-20)


### Features

* **nvim:** add peek definition to treesitter text objects ([6f2c860](https://github.com/dkarter/dotfiles/commit/6f2c860e40c3abcfb69a7f530c24bd5137c5d19f))
* **nvim:** add treesitter scope textobjects ([5b683d6](https://github.com/dkarter/dotfiles/commit/5b683d6a9af2ee39c0aec8df75276da144be7f87))


### Bug Fixes

* **nvim:** fix deprecated config for context-commentstring ([f2791ed](https://github.com/dkarter/dotfiles/commit/f2791ed2ec03427da521643b32a89a3dbf40eace))

## [12.5.0](https://github.com/dkarter/dotfiles/compare/v12.4.2...v12.5.0) (2023-10-27)


### Features

* **installer:** add codespell ([a7dd2d4](https://github.com/dkarter/dotfiles/commit/a7dd2d427525ae038d382baa9ca4903581994f13))
* **installer:** add Taskfile ([31af44b](https://github.com/dkarter/dotfiles/commit/31af44b270aa2965fd3885b9da737cb19269275a))

## [12.4.2](https://github.com/dkarter/dotfiles/compare/v12.4.1...v12.4.2) (2023-10-27)


### Bug Fixes

* **nvim:** disable SHAred DAta writing to fix annoying notifs ([e02a4d6](https://github.com/dkarter/dotfiles/commit/e02a4d680e31e21ae398cb635c6a7a16368daaf5))
* **nvim:** helm file support ([f5bee17](https://github.com/dkarter/dotfiles/commit/f5bee17d30ab3bbd962c42271124ae93fbf67e56))

## [12.4.1](https://github.com/dkarter/dotfiles/compare/v12.4.0...v12.4.1) (2023-10-16)


### Bug Fixes

* remove SHADA config ([39dde29](https://github.com/dkarter/dotfiles/commit/39dde298800227d5a09158dcc97e481ba171b53e))

## [12.4.0](https://github.com/dkarter/dotfiles/compare/v12.3.3...v12.4.0) (2023-10-02)


### Features

* add LSP rename mapping ([7b7a0e8](https://github.com/dkarter/dotfiles/commit/7b7a0e872b05154c582b8c9e7843d9bdb5466d50))
* **git:** enable diff3 conflict style ([00a31fc](https://github.com/dkarter/dotfiles/commit/00a31fc3dc46bb50009f1c768fd5e224d7f1035b))
* **installer:** add additional duti mappings ([88980ea](https://github.com/dkarter/dotfiles/commit/88980ea9611e8e6734ef7f4b30dcbb79715a1e28))
* **nvim:** add CSV syntax highlighting ([69df162](https://github.com/dkarter/dotfiles/commit/69df16233ce4dccf055d270cd27321ee79322a9e))
* **nvim:** add xml formatting via xq ([dca0c29](https://github.com/dkarter/dotfiles/commit/dca0c29482774aa422a7795a2c8d154385953ad0))
* **nvim:** add xml synxtax highlighting via TreeSitter ([86e0a9b](https://github.com/dkarter/dotfiles/commit/86e0a9b7580aaa712a5c25b68f26198e0e126b87))


### Bug Fixes

* **nvim:** migrate indent-blankline config to v3 ([8fa98e6](https://github.com/dkarter/dotfiles/commit/8fa98e65b62e26c40f9f3125333ed5e125dcd5fd))
* **nvim:** remove deprecated setting for indent-blankline ([9063f38](https://github.com/dkarter/dotfiles/commit/9063f38d398644587d666ac8ab2f30b702de1de9))
* remove personal info from gitconfig ([cc8fdba](https://github.com/dkarter/dotfiles/commit/cc8fdba6340d40f53a121b244352ac41710c7a80))
* **zsh,nvr:** don't use NVIM_LISTEN_ADDRESS ([7bf5598](https://github.com/dkarter/dotfiles/commit/7bf5598b34eca29496d58e199aa065c36d1ad96a))
* **zsh,nvr:** improve behavior for ECTO_EDITOR ([7a18d1a](https://github.com/dkarter/dotfiles/commit/7a18d1a922d51231df7a2cac063eed4c8ef5fd49))

## [12.3.3](https://github.com/dkarter/dotfiles/compare/v12.3.2...v12.3.3) (2023-09-15)


### Bug Fixes

* **nvim:** annoying indentation for comments in Elixir ([546eeb0](https://github.com/dkarter/dotfiles/commit/546eeb09e67221685db4889c226199c33e35bcb8))

## [12.3.2](https://github.com/dkarter/dotfiles/compare/v12.3.1...v12.3.2) (2023-09-15)


### Bug Fixes

* **asdf:** add Golang env var for ASDF ([a40d79f](https://github.com/dkarter/dotfiles/commit/a40d79f24f5263f6ce2362b225042138c0ff03f8))
* **zsh:** enable interactive comments ([b2a234f](https://github.com/dkarter/dotfiles/commit/b2a234fda4f6b9d33a4cb30b83d49c75275e2992))

## [12.3.1](https://github.com/dkarter/dotfiles/compare/v12.3.0...v12.3.1) (2023-09-07)


### Bug Fixes

* **zsh:** add yarn bin folder to PATH on linux ([966b191](https://github.com/dkarter/dotfiles/commit/966b191e6507b52c0eebfeb4ff5d4896f976a44b))

## [12.3.0](https://github.com/dkarter/dotfiles/compare/v12.2.0...v12.3.0) (2023-08-31)


### Features

* **installer:** add reshim asdf tools task ([0b7ca10](https://github.com/dkarter/dotfiles/commit/0b7ca106c2451e858dedd11fd397e4131998b2e0))
* **nvim:** add mappings for Diffview ([fc70e62](https://github.com/dkarter/dotfiles/commit/fc70e62b1b821a34a215cf76b1ab923b0fc6042f))

## [12.2.0](https://github.com/dkarter/dotfiles/compare/v12.1.0...v12.2.0) (2023-08-14)


### Features

* **brew:** add mas - Mac App Store CLI ([238b61f](https://github.com/dkarter/dotfiles/commit/238b61fdf5f107f4e492d4999c614e78375919ac))
* **installer:** add unicornleap installer ([1dbcb00](https://github.com/dkarter/dotfiles/commit/1dbcb007db3d961b2a09ce7bd79b341b7d836e56))
* **installer:** set up tmux term info ([ca5da3f](https://github.com/dkarter/dotfiles/commit/ca5da3f16d8d2d766e75ad63098d3188b4544b97))


### Bug Fixes

* **fzf:** search hidden files ([e8dfdcf](https://github.com/dkarter/dotfiles/commit/e8dfdcfc057f2b4db6dce08a777e76a545d330c6))
* **installer:** only install desktop apps when not already installed ([1d13825](https://github.com/dkarter/dotfiles/commit/1d13825a4a627d6471ebecbc0beeb3bea9c07b79))
* **installer:** use manual install for sudo-touchid ([52be976](https://github.com/dkarter/dotfiles/commit/52be976582a5b2f7db503fa74ed1d8a610a8f5fc))

## [12.1.0](https://github.com/dkarter/dotfiles/compare/v12.0.0...v12.1.0) (2023-08-04)


### Features

* **brew:** add missing formulas ([d6edd5e](https://github.com/dkarter/dotfiles/commit/d6edd5e4d9c13d86926c8ae15b114c24e1ceb764))


### Bug Fixes

* **installer:** use tap to install sudo-touchid + start service ([452bc06](https://github.com/dkarter/dotfiles/commit/452bc06748c9f0d7bb174ea06f90b7384f7f7641))
* **nvim:** auto load treesitter when loading telescope ([019f767](https://github.com/dkarter/dotfiles/commit/019f7674829b43cef103e5b0681b4e43b041f52e))
* **nvim:** disable next-ls ([bc46c52](https://github.com/dkarter/dotfiles/commit/bc46c528266f7b528bf14ce65c3c181f9b6b52ae))
* **nvim:** exclude quickfix buffers from indentline/indentscope ([13b3eac](https://github.com/dkarter/dotfiles/commit/13b3eace4b086731186150f8a0beb94973e27df1))
* **nvim:** include global on_attach for elixir ls ([df44905](https://github.com/dkarter/dotfiles/commit/df449055a72f6e7bcf4cb441b8a828df721f8c3f))
* **nvim:** make test mappings silent ([e49a319](https://github.com/dkarter/dotfiles/commit/e49a319979c49445b66239cebb52b059a0996a78))

## [12.0.0](https://github.com/dkarter/dotfiles/compare/v11.0.0...v12.0.0) (2023-07-30)


### ⚠ BREAKING CHANGES

* **nvim:** change flash mappings

### Features

* **nvim:** add telescope git status mappings ([ac7ee85](https://github.com/dkarter/dotfiles/commit/ac7ee852fc1418038f0e02b08acee2f9e8264d96))
* **nvim:** enable cursorline (again) ([3558cbf](https://github.com/dkarter/dotfiles/commit/3558cbff5d14b060b2b3d10bdfb7b15da653a408))


### Bug Fixes

* **nvim:** lint warning for lua types ([ed5825a](https://github.com/dkarter/dotfiles/commit/ed5825a6132e9569f60104c68c0d797f45cce894))
* **nvim:** remove debug notifs ([4e2c8e0](https://github.com/dkarter/dotfiles/commit/4e2c8e035aac2f6d7e1f74ae0dc5b26b212ea7db))


### Performance Improvements

* **nvim:** improve startup time ([e0b9fe2](https://github.com/dkarter/dotfiles/commit/e0b9fe2edf536c492d55bc551534fa5a68d2aa18))
* **nvim:** lazy load telescope on demand ([7936d6c](https://github.com/dkarter/dotfiles/commit/7936d6cf60fcb816d1ba98b1cfa45a81e7924066))


### Code Refactoring

* **nvim:** change flash mappings ([82421de](https://github.com/dkarter/dotfiles/commit/82421def3109b7c1ce64cabe9a13e2fb989e55aa))

## [11.0.0](https://github.com/dkarter/dotfiles/compare/v10.5.1...v11.0.0) (2023-07-25)


### ⚠ BREAKING CHANGES

* **nvim:** restructure Rg mappings

### Features

* **nvim:** add [q ]q for jumping between Trouble listings ([e22d171](https://github.com/dkarter/dotfiles/commit/e22d17189a7b9da7879a09d8be88f506de17f464))
* **nvim:** add git status files dashboard command ([5b958ab](https://github.com/dkarter/dotfiles/commit/5b958ab17788e8eb0f7f38e35fa49d33a2bc56ee))
* **nvim:** add illuminate to highlight word under cursor ([5f155dc](https://github.com/dkarter/dotfiles/commit/5f155dcd1374331bd40238cade4522c00ace128c))
* **nvim:** add mini.indentscope for highlighting current scope ([2088088](https://github.com/dkarter/dotfiles/commit/208808880a2246a70dc2eaea2d9d5da4c48528da))
* **nvim:** add todo comment mappings ([303bd11](https://github.com/dkarter/dotfiles/commit/303bd115613e8678e54561f260debebb457cfed9))
* **nvim:** change dashboard menu items ([034ab97](https://github.com/dkarter/dotfiles/commit/034ab97c6cfd018f09081c7f66d994ba164e25d6))


### Bug Fixes

* **nvim:** need to properly set up lazy loading for :GBrowse ([e3338bc](https://github.com/dkarter/dotfiles/commit/e3338bcddc0185287457187d6b19ca476cc97837))
* **nvim:** remove output-panel plugin ([ddad16f](https://github.com/dkarter/dotfiles/commit/ddad16f21d290bc3acb377ae39cfb3ebb3efbf27))
* **nvim:** remove unused plugins ([c02444e](https://github.com/dkarter/dotfiles/commit/c02444ed996568bab407b8dc0613d711398a8c9d))
* **zsh:** prevent conflict between teleport and 1password cli ([a6211f2](https://github.com/dkarter/dotfiles/commit/a6211f28396eb7ca1daba12e1435264489f9cb55))


### Performance Improvements

* **nvim:** improve plugin loading config ([e336149](https://github.com/dkarter/dotfiles/commit/e3361491e0949da18a03295822d0bf23d3837a17))


### Code Refactoring

* **nvim:** restructure Rg mappings ([b9d08aa](https://github.com/dkarter/dotfiles/commit/b9d08aa030638479cad57403024087372c361540))

## [10.5.1](https://github.com/dkarter/dotfiles/compare/v10.5.0...v10.5.1) (2023-07-11)


### Bug Fixes

* **nvim:** silence null-ls code_action notifs ([fd6532a](https://github.com/dkarter/dotfiles/commit/fd6532ab820aeb85dffbfa31426554ccd9439cd4))

## [10.5.0](https://github.com/dkarter/dotfiles/compare/v10.4.0...v10.5.0) (2023-07-11)


### Features

* **bat:** add config and set tokyonight_storm as default theme ([b41c0ac](https://github.com/dkarter/dotfiles/commit/b41c0acc1026bcbc879c27f8645bdb8e6ac7c2a1))
* **nvim:** add clang-format to format C files ([a4890b8](https://github.com/dkarter/dotfiles/commit/a4890b8f43ccb9ff05ff0e9d8797089644757161))
* **zsh:** add `v` script for opening a file in neovim ([2cb9716](https://github.com/dkarter/dotfiles/commit/2cb97165d5e09b608ba6f66b792e46d6103d325b))
* **zsh:** add bic (brew install cask) ([999004f](https://github.com/dkarter/dotfiles/commit/999004fc4d9c9ba00037d4e962b4d19cb442a4ef))
* **zsh:** add bip (brew install package) ([543422e](https://github.com/dkarter/dotfiles/commit/543422e26f68e7918ab19546ddd85e8d27ac44cd))
* **zsh:** add fdr and cdf commands ([7e9e83d](https://github.com/dkarter/dotfiles/commit/7e9e83ddd2fd336f5b958e04659310624c8ae028))
* **zsh:** add fman to search man pages ([ad2bfc0](https://github.com/dkarter/dotfiles/commit/ad2bfc00d4b9d42927fd3e9fbc840d3a92683b6b))
* **zsh:** move FZF config to dedicated file + set colorscheme ([ac2c5c9](https://github.com/dkarter/dotfiles/commit/ac2c5c9ee994448512604fa1da5ed1872bf4ebfc))
* **zsh:** skip fuzzy finder for v when there's only 1 match ([7f26a65](https://github.com/dkarter/dotfiles/commit/7f26a65028236a6fb82eec289428d201b1418311))


### Bug Fixes

* **nvim:** incorrect config key for lspsaga ([3ce26af](https://github.com/dkarter/dotfiles/commit/3ce26affac236ad108d9927c3e01209f6a6f6c92))
* **nvim:** use correct icons for line and column ([a1a34f4](https://github.com/dkarter/dotfiles/commit/a1a34f429e163c4977f3ff2f4b311dc4216638a9))

## [10.4.0](https://github.com/dkarter/dotfiles/compare/v10.3.3...v10.4.0) (2023-06-30)


### Features

* **nvim:** add a simple start page ([9840679](https://github.com/dkarter/dotfiles/commit/98406799a6caf478c8e4bbf65ae7e35f74633acb))
* **nvim:** add back FzfRg ([10a03e0](https://github.com/dkarter/dotfiles/commit/10a03e092a0086233c43838f48acf43e78d171b7))
* **nvim:** add footer to start screen ([d1dc8a8](https://github.com/dkarter/dotfiles/commit/d1dc8a80a76815b792ce5c902a62353555d9fd51))
* **nvim:** add plugin updates available indicator ([0251c91](https://github.com/dkarter/dotfiles/commit/0251c91627964bc243cf9fc0af124c49cbbeb591))
* **nvim:** add sql scratch buffers to attempt.nvim ([42f72ff](https://github.com/dkarter/dotfiles/commit/42f72ff576f295d0d1d2979a6d6438a233711421))
* **nvim:** add unicode symbol search ([7832127](https://github.com/dkarter/dotfiles/commit/78321274ecc97e4b09c67f0345736e81f49d8b08))
* **nvim:** file browser telescope mapping open current dir ([df1f050](https://github.com/dkarter/dotfiles/commit/df1f0501130e719f401b4a44481ccef8e67a6229))


### Bug Fixes

* **iterm:** use Caskaydia Cove font instead of Menlo ([83783a2](https://github.com/dkarter/dotfiles/commit/83783a216bfee7531f364965f06183ac2ddee0ab))
* **nvim:** add UndotreeToggle cmd as lazy load trigger ([c0fa6bd](https://github.com/dkarter/dotfiles/commit/c0fa6bdf2efa62e47b89d68b1dfe2892a3ff3bc9))
* **nvim:** escape search term in lua line ([3b380c5](https://github.com/dkarter/dotfiles/commit/3b380c58dba29ae499b76823c39723408a1ce8e0))
* **nvim:** hide light bulb icon from LSPSaga in insert mode ([932a126](https://github.com/dkarter/dotfiles/commit/932a12617dfdb93ecec42c29475b9d87063bb465))
* **nvim:** use prettier for formatting markdown instead of prettierd ([eab9f3b](https://github.com/dkarter/dotfiles/commit/eab9f3b8df58af9b8f9e26facd1886cf5205b730))
* **nvim:** use telescope to select existing attempt scratch files ([56394df](https://github.com/dkarter/dotfiles/commit/56394dff9b7d164051d76a4dbb8868ca6cf0c799))


### Performance Improvements

* **nvim:** improve attempt.nvim lazy loading ([edd2ecb](https://github.com/dkarter/dotfiles/commit/edd2ecb0681a8b9ea5cd34a12c28a8db30b2c5f8))
* **nvim:** improve indent-blankline laziness ([b89beac](https://github.com/dkarter/dotfiles/commit/b89beacf1c4d855185cc324c19d57316bbd8c3a6))
* **nvim:** remove unused rtp plugins ([dc63373](https://github.com/dkarter/dotfiles/commit/dc63373bc93fbd9f3889e1a1123fa34dd954bc17))

## [10.3.3](https://github.com/dkarter/dotfiles/compare/v10.3.2...v10.3.3) (2023-06-26)


### Bug Fixes

* **nvim:** lsp saga was not configured correctly ([ecfdafb](https://github.com/dkarter/dotfiles/commit/ecfdafbfa8c62b6c6aa51351c63c53be439c8adc))

## [10.3.2](https://github.com/dkarter/dotfiles/compare/v10.3.1...v10.3.2) (2023-06-26)


### Bug Fixes

* **tmux:** battery icons compatibility with nerd fonts v3 ([34b6a04](https://github.com/dkarter/dotfiles/commit/34b6a04b92b46695ed809ec6580b8be0a4a3c80f))

## [10.3.1](https://github.com/dkarter/dotfiles/compare/v10.3.0...v10.3.1) (2023-06-25)


### Performance Improvements

* **nvim:** additional startup performance improvements ([95a146e](https://github.com/dkarter/dotfiles/commit/95a146eb87b973943ca9d64db0fb371ea2f2133b))

## [10.3.0](https://github.com/dkarter/dotfiles/compare/v10.2.0...v10.3.0) (2023-06-25)


### Features

* **installer:** add npkill ([ebcea71](https://github.com/dkarter/dotfiles/commit/ebcea7150f34290723d7c9c59e3c9225761fe49d))
* **nvim:** add dismiss notifications mapping ([8bdf89a](https://github.com/dkarter/dotfiles/commit/8bdf89a9ba8069f1589be653b7e41084ed8d8216))
* **nvim:** lazy load additional plugins ([93e8149](https://github.com/dkarter/dotfiles/commit/93e81492c8e10f4ff7fa548e0b3ebbf450d8148f))
* **nvim:** lazy load nvim-tree ([1a5b3b3](https://github.com/dkarter/dotfiles/commit/1a5b3b3c5f5dfe9da4063ff7f0559b9213da7917))
* **nvim:** lazy load Trouble and Hop ([99b6d72](https://github.com/dkarter/dotfiles/commit/99b6d729dfec23b3c980bbb50fa4e546d35b8a48))
* **nvim:** make many plugins VeryLazy ([c2dd791](https://github.com/dkarter/dotfiles/commit/c2dd79104bb7a6e676df2fb9fcde37dbd19cd80e))


### Bug Fixes

* **nvim:** make mason-tool-installer delay 3000 seconds before running ([bfb3777](https://github.com/dkarter/dotfiles/commit/bfb37771f68c703f2404388463a293beadb76ba6))

## [10.2.0](https://github.com/dkarter/dotfiles/compare/v10.1.0...v10.2.0) (2023-06-22)


### Features

* **nvim:** add basic winbar (just filename) ([5397be2](https://github.com/dkarter/dotfiles/commit/5397be2d8dec3e54c99c76eae37125ff76d22fda))
* **nvim:** add filetype icon in winbar ([31c5aa5](https://github.com/dkarter/dotfiles/commit/31c5aa579bcf659d2cc53bfb8d5a803ad03fe45e))
* **nvim:** add output panel plugin to debug LSPs ([6a9ed9b](https://github.com/dkarter/dotfiles/commit/6a9ed9b5f0f808a0e734e76848e9749243030d02))
* **nvim:** display macro recording status in Lualine ([f8ae1e4](https://github.com/dkarter/dotfiles/commit/f8ae1e4853b12b4e342dc18d6b43f6facfbf190d))

## [10.1.0](https://github.com/dkarter/dotfiles/compare/v10.0.0...v10.1.0) (2023-06-21)


### Features

* **nvim:** add noice.nvim ([3c8cfab](https://github.com/dkarter/dotfiles/commit/3c8cfabd8ac9071a8d4202ddd40e45e253059b7d))
* **nvim:** use gx.nvim to open plugins under cursor with gx ([f3e9873](https://github.com/dkarter/dotfiles/commit/f3e9873876488881e6c71520ea8613393125cadf))


### Bug Fixes

* **nvim:** use correct error level code ([be88779](https://github.com/dkarter/dotfiles/commit/be88779abdc33386d70f9bf5191a83835f640527))


### Reverts

* "feat(nvim): add noice.nvim" ([8a14cee](https://github.com/dkarter/dotfiles/commit/8a14cee4a01e248480862f7dcee4e17360dc5b38))
* "revert: "feat(nvim): add noice.nvim"" ([4f222e3](https://github.com/dkarter/dotfiles/commit/4f222e3d66ff6040789f0e4d97f9ba4e5e51d9e1))

## [10.0.0](https://github.com/dkarter/dotfiles/compare/v9.4.0...v10.0.0) (2023-06-19)


### ⚠ BREAKING CHANGES

* **nvim:** remove all vimscript + no more FZF
* **nvim:** reduce reliance on fzf

### Features

* **nvim:** add &lt;leader&gt;fd for finding dotfiles ([139f2f7](https://github.com/dkarter/dotfiles/commit/139f2f7131ff8dab188b334705eb19c37122f960))


### Bug Fixes

* **nvim:** improve Lua completion by prioritizing nvim_lua ([bd4d677](https://github.com/dkarter/dotfiles/commit/bd4d677214ef1889c0cc32625e2ad1755f3d1400))


### Miscellaneous Chores

* **nvim:** reduce reliance on fzf ([10fb767](https://github.com/dkarter/dotfiles/commit/10fb7679f28fdc1623b4fd31cc9ac09cd3517d72))
* **nvim:** remove all vimscript + no more FZF ([27297f0](https://github.com/dkarter/dotfiles/commit/27297f0da2d745649e97409d945c9547dfb0ace0))

## [9.4.0](https://github.com/dkarter/dotfiles/compare/v9.3.0...v9.4.0) (2023-06-18)


### Features

* **alacritty:** add Bold Italic font face ([34d4cbc](https://github.com/dkarter/dotfiles/commit/34d4cbcbee1d844bf276398f2a069260d2d88e91))
* **zsh:** add alias for vim scratch vsc ([ae6458e](https://github.com/dkarter/dotfiles/commit/ae6458eba55ca116fddf6d5daea321606250194c))


### Bug Fixes

* **alacritty:** use bold font instead of medium ([88d77b2](https://github.com/dkarter/dotfiles/commit/88d77b26e474ee2a26d873a5c255f318d0660a1d))
* **nvim:** command line icons were not showing ([35f9f48](https://github.com/dkarter/dotfiles/commit/35f9f48e71854d792468163204b2e128451cfb03))
* **nvim:** improve conventional commit entry modal ([74d43e4](https://github.com/dkarter/dotfiles/commit/74d43e496121c03c489fc72581b90ea32d5f8078))
* **nvim:** only run commitlint linter on repos that have a config file ([55ff6fa](https://github.com/dkarter/dotfiles/commit/55ff6fa4176fb6eaa3dde2586c26bb32dac4447c))

## [9.3.0](https://github.com/dkarter/dotfiles/compare/v9.2.0...v9.3.0) (2023-06-16)


### Features

* **nvim:** add completion of command line history ([f64b4aa](https://github.com/dkarter/dotfiles/commit/f64b4aac299f6d43856af5fd74e73a55890a8221))
* **zsh:** add dotfiles bin folder to path + fzf-prs command ([47c2a80](https://github.com/dkarter/dotfiles/commit/47c2a80922e4827b8ff263715ed87b8500a76e53))


### Bug Fixes

* **nvim:** allow expanding % in cmdline with cmp ([91b1708](https://github.com/dkarter/dotfiles/commit/91b170862cfff0ffec97526e6889496fa8532ed5))
* **nvim:** use projections for elixir from elixir-tools.nvim ([bf0a9a6](https://github.com/dkarter/dotfiles/commit/bf0a9a6b4bb1095fa03480b777b90eff8700240c))

## [9.2.0](https://github.com/dkarter/dotfiles/compare/v9.1.0...v9.2.0) (2023-06-10)


### Features

* **btop:** add btop config ([123fbec](https://github.com/dkarter/dotfiles/commit/123fbec45d2da44d140b3b186d602753431f55c8))
* **installer:** add script to install btop app ([b9b3074](https://github.com/dkarter/dotfiles/commit/b9b3074464dd2a300e2222a640a8cb9ff8cf435e))
* **zsh:** enable 1password ssh agent for all hosts ([d0db66a](https://github.com/dkarter/dotfiles/commit/d0db66aa056ae229d4f8c2a1b3e4b0d79bc2bddf))


### Bug Fixes

* **zsh:** make 1password SSH Agent sock work on both mac and linux ([8ce7019](https://github.com/dkarter/dotfiles/commit/8ce7019027a1ae4275e19ddbb7982dac8a587f44))

## [9.1.0](https://github.com/dkarter/dotfiles/compare/v9.0.0...v9.1.0) (2023-06-10)


### Features

* add btop iterm automator app ([41913dd](https://github.com/dkarter/dotfiles/commit/41913dda475572cdf98683bc088aa22cf6690ff3))

## [9.0.0](https://github.com/dkarter/dotfiles/compare/v8.5.1...v9.0.0) (2023-05-17)


### ⚠ BREAKING CHANGES

* **nvim:** remove unused mappings + add descriptions
* **nvim:** remove unused mappings and add descriptions

### Features

* **nvim:** add fidget.nvim for LSP status ([c3bbccd](https://github.com/dkarter/dotfiles/commit/c3bbccd4e1a28db4147ceb8730771654d8e14860))


### Bug Fixes

* **installer,fonts:** update install path for nerdfonts  (v3.0) ([051a696](https://github.com/dkarter/dotfiles/commit/051a69625e80c454beca0898ed065ba15ea41a16))
* **nvim:** correct LSP icons (to work with nerd fonts v3.0) ([adf71fb](https://github.com/dkarter/dotfiles/commit/adf71fb5c78f377564344db771b2105a972ca4d9))
* **nvim:** elixir ls setup ([740facc](https://github.com/dkarter/dotfiles/commit/740facc4fa4fa1c696ab23a4b77ba5f5b3071619))


### Code Refactoring

* **nvim:** remove unused mappings + add descriptions ([0043997](https://github.com/dkarter/dotfiles/commit/004399756c7954eb827f8e7deb4a1c83d6eec901))
* **nvim:** remove unused mappings and add descriptions ([0b6c284](https://github.com/dkarter/dotfiles/commit/0b6c2841b2ea42f77e234896234aeea27dfcae8c))

## [8.5.1](https://github.com/dkarter/dotfiles/compare/v8.5.0...v8.5.1) (2023-05-04)


### Bug Fixes

* **zsh,brew:** add zsh completions from homebrew ([eafa80a](https://github.com/dkarter/dotfiles/commit/eafa80a136ca131ddf5edafdab33523de79dc1c3))

## [8.5.0](https://github.com/dkarter/dotfiles/compare/v8.4.0...v8.5.0) (2023-04-18)


### Features

* **nvim:** add helm-ls ([564b3f1](https://github.com/dkarter/dotfiles/commit/564b3f1288541651e6d83effaf702ed1664000b2))
* **zsh:** add ghpre command for editing PR body in Neovim ([bc7810a](https://github.com/dkarter/dotfiles/commit/bc7810a500aa48cf25df479853899429c6f0483e))

## [8.4.0](https://github.com/dkarter/dotfiles/compare/v8.3.0...v8.4.0) (2023-04-10)


### Features

* **installer:** automatically set handler for multiple file types ([80ccc7f](https://github.com/dkarter/dotfiles/commit/80ccc7f2f5425b1a03a2280f3ea94634d6d9a09c))

## [8.3.0](https://github.com/dkarter/dotfiles/compare/v8.2.0...v8.3.0) (2023-04-06)


### Features

* **nvim:** add tooling for golang ([0584597](https://github.com/dkarter/dotfiles/commit/05845973455aaac6debc23510fb0d64788f3d0cc))


### Bug Fixes

* **nvim:** disable colorizer in Lazy popup ([884ed48](https://github.com/dkarter/dotfiles/commit/884ed4852e7125db3d34038c8e73379f781da8f6))

## [8.2.0](https://github.com/dkarter/dotfiles/compare/v8.1.0...v8.2.0) (2023-03-28)


### Features

* **nvim:** add additional TreeSitter grammars ([071b561](https://github.com/dkarter/dotfiles/commit/071b5610994e3724feea00f4aa9865b1ae17c2b7))


### Bug Fixes

* **nvim:** force gitignore file to render as gitignore ft ([2ea939c](https://github.com/dkarter/dotfiles/commit/2ea939cac41f3e4a3f1d0c028919b58b23251869))

## [8.1.0](https://github.com/dkarter/dotfiles/compare/v8.0.0...v8.1.0) (2023-03-28)


### Features

* **installer,zsh:** add erdtree for a better tree command ([72b7073](https://github.com/dkarter/dotfiles/commit/72b7073c313131ae62cbd08324849961b722cb36))
* **nvim:** add mapping for 'save as' ([0843abb](https://github.com/dkarter/dotfiles/commit/0843abbe1020a1555992ab0f757a1d8e224c04ae))
* **term,tmux:** add script for setting up terminfo ([e0e0f8e](https://github.com/dkarter/dotfiles/commit/e0e0f8e68a0c4a76637d25b1914803a6ad259078))
* **zsh,brew:** add 1password-cli ([efaabb4](https://github.com/dkarter/dotfiles/commit/efaabb464a8ec242531181e3a14115024b30010c))


### Bug Fixes

* **nvim:** fix behavior of ts_context_commentstring ([2a27e2e](https://github.com/dkarter/dotfiles/commit/2a27e2e523546afab44c22cc9743601ae8aa96cc))
* **nvim:** remove duplicate mapping for &lt;leader&gt;rg ([edffa34](https://github.com/dkarter/dotfiles/commit/edffa34fab587d032443fb75cbb6222ccacb7394))
* **nvim:** use init instead of setup for vim settings ([83fe86c](https://github.com/dkarter/dotfiles/commit/83fe86cf6fa08c14fb5177b5cd4c5084e4ee1483))
* **ruby,prettier:** fix ability to format Ruby with prettier ([6c2d479](https://github.com/dkarter/dotfiles/commit/6c2d479e0ea6b719a6f42465dbf4228d1cfd1159))
* **tmux:** add proper undercurl support to tmux ([4ad44a8](https://github.com/dkarter/dotfiles/commit/4ad44a88831ef30c9f0c8be0312286f204515eb1))

## [8.0.0](https://github.com/dkarter/dotfiles/compare/v7.9.0...v8.0.0) (2023-03-24)


### ⚠ BREAKING CHANGES

* **nvim:** change mappings for vim test
* **nvim:** switch Packer -> Lazy.nvim

### Features

* **installer:** add commitlint and trash-cli npms ([5621842](https://github.com/dkarter/dotfiles/commit/5621842b8a03507fc8e03413a6a65b7dac938774))


### Bug Fixes

* **nvim:** move leader mapping definition to init.lua ([adb5094](https://github.com/dkarter/dotfiles/commit/adb5094964273ab5cd0353e08dc929e71a9e16fe))


### Code Refactoring

* **nvim:** change mappings for vim test ([89e2040](https://github.com/dkarter/dotfiles/commit/89e204031400caa730478519aaff635259237643))
* **nvim:** switch Packer -&gt; Lazy.nvim ([99cef86](https://github.com/dkarter/dotfiles/commit/99cef86183ea78c9a78bf3e2f8e1427f917b259c))

## [7.9.0](https://github.com/dkarter/dotfiles/compare/v7.8.0...v7.9.0) (2023-03-20)


### Features

* **nvim:** add browse.nvim ([2b34b5a](https://github.com/dkarter/dotfiles/commit/2b34b5a181a1b69c9748e5763c9b9f29213a2cc5))
* **nvim:** add nvim-jqx (UI for JQ and YQ) ([1902276](https://github.com/dkarter/dotfiles/commit/19022764c7ac4bd34649eaba0000a510bea8f887))

## [7.8.0](https://github.com/dkarter/dotfiles/compare/v7.7.1...v7.8.0) (2023-03-17)


### Features

* **nvim:** add nvim-treesitter-context ([601702c](https://github.com/dkarter/dotfiles/commit/601702cf4dde161b34d1606f0814b2c44a4795c4))


### Bug Fixes

* allow opening TerminalVim.app without specifying a file ([d7c11ad](https://github.com/dkarter/dotfiles/commit/d7c11ad8ca700b915cfadcdb3ff2bb2683ed3cc5))

## [7.7.1](https://github.com/dkarter/dotfiles/compare/v7.7.0...v7.7.1) (2023-03-08)


### Bug Fixes

* **nvim:** move ElixirLS setup to plugins.lsp and use shared on_attach ([8574e30](https://github.com/dkarter/dotfiles/commit/8574e30581c15790b22381913a843792526176c0))

## [7.7.0](https://github.com/dkarter/dotfiles/compare/v7.6.4...v7.7.0) (2023-03-08)


### Features

* **installer:** add howdoi via pip ([78b4106](https://github.com/dkarter/dotfiles/commit/78b41064168acf587ca87a41a3197d3940d46332))


### Bug Fixes

* **nvim:** replace telescope-ui-select w/ dressing.nvim ([1122d4f](https://github.com/dkarter/dotfiles/commit/1122d4f29001617eaf82ac9943b529d30b86e39a))
* **nvim:** use ElixirLS from elixir.nvim instead of Mason ([3dea902](https://github.com/dkarter/dotfiles/commit/3dea9027c9e566a3aab03021257231525fce05e8))

## [7.6.4](https://github.com/dkarter/dotfiles/compare/v7.6.3...v7.6.4) (2023-02-17)


### Bug Fixes

* **nvim:** use lua_ls instead of the deprecated sumneko_lua ([1c43b98](https://github.com/dkarter/dotfiles/commit/1c43b98d14e764510615db20bba6708547065692))

## [7.6.3](https://github.com/dkarter/dotfiles/compare/v7.6.2...v7.6.3) (2023-02-05)


### Bug Fixes

* **nvim:** disable automatic formatexpr ([2b76deb](https://github.com/dkarter/dotfiles/commit/2b76deb0bc9e35fae85c7916835a13d90aaabe43))
* **nvim:** stop prompting about luassert ([76c66c7](https://github.com/dkarter/dotfiles/commit/76c66c7f7f534bddd53a7a785b59df140f0e55a3))
* **nvim:** use ui.select for code actions (instead of LSPSaga) ([2093cba](https://github.com/dkarter/dotfiles/commit/2093cba468ef3d3b18bbe240df787b2ba73bcc76))

## [7.6.2](https://github.com/dkarter/dotfiles/compare/v7.6.1...v7.6.2) (2023-01-23)


### Bug Fixes

* **nvim:** disable cursorline ([eb4ffe6](https://github.com/dkarter/dotfiles/commit/eb4ffe60d42b701e047ec7fa63dd658dfff35df9))
* **nvim:** make tailwindcss work with Elixir HEEX templates ([5229877](https://github.com/dkarter/dotfiles/commit/5229877aaa7f7ee0bfaa699f9aaed2184de948f8))
* **zsh:** use yarn PATH from ASDF ([389c17e](https://github.com/dkarter/dotfiles/commit/389c17e022bd1a943871ccb368c1e643498cc67a))

## [7.6.1](https://github.com/dkarter/dotfiles/compare/v7.6.0...v7.6.1) (2023-01-17)


### Bug Fixes

* **nvim:** disable LSPSaga winbar ([0468628](https://github.com/dkarter/dotfiles/commit/0468628f5f6693f0fe7f9eab85e2957828b588e0))
* **zsh:** move asdf to own config file ([c5e9c69](https://github.com/dkarter/dotfiles/commit/c5e9c6954a1929f419c425a55ac050014aecd1d9))

## [7.6.0](https://github.com/dkarter/dotfiles/compare/v7.5.0...v7.6.0) (2023-01-15)


### Features

* **nvim:** add (z) aka zoxide - a better cd command ([09cb337](https://github.com/dkarter/dotfiles/commit/09cb337dac0d8c4a376f9a4073d1acd41942224e))
* **nvim:** add block text object for Elixir and Ruby ([388d01f](https://github.com/dkarter/dotfiles/commit/388d01ff6aaf997dcab09339d715e86fd948fd37))
* **nvim:** add Hop plugin for quickly jumping inside view ([4400f03](https://github.com/dkarter/dotfiles/commit/4400f036ed2e4382ec6dd40ce67e1d630fd75a66))
* **nvim:** add projections for Malomo.js ([3685e8b](https://github.com/dkarter/dotfiles/commit/3685e8b4df276d7723305c7233328bd01ce342ae))
* **nvim:** add text object bindings for comments via treesitter ([0c65513](https://github.com/dkarter/dotfiles/commit/0c6551365e85400c6ac2120f5f5d9d83b25713af))


### Bug Fixes

* **erlang:** compile with build docs ([cbcf5f7](https://github.com/dkarter/dotfiles/commit/cbcf5f79feef2f02b88d1ac732b5e4e1c278dd31))
* **nvim:** use the `setup` function to configure LSP Saga ([2e9b28a](https://github.com/dkarter/dotfiles/commit/2e9b28a5cf841de07a1235b5862de8bcabc54356))
* **zsh:** erlang 25.1.x compilation deps ([44a405a](https://github.com/dkarter/dotfiles/commit/44a405ad65f859adebe6fc0b21c801b08a12f2d4))

## [7.5.0](https://github.com/dkarter/dotfiles/compare/v7.4.0...v7.5.0) (2022-11-12)


### Features

* **zsh:** alias rm as trash-cli ([7ad28c1](https://github.com/dkarter/dotfiles/commit/7ad28c19d26772c73c33e78799441c0121e5bff9))


### Bug Fixes

* **nvim:** disable folds on startup ([ed4fe2f](https://github.com/dkarter/dotfiles/commit/ed4fe2fd0b2da6c6491e48c85ad0ca85f23c804f))
* **nvim:** remove fold customization ([79c9712](https://github.com/dkarter/dotfiles/commit/79c9712a3d5d741a0c3d8da97f87912e5a591684))
* **nvr:** make neovim-remote work with neovim 0.8 ([ebf5059](https://github.com/dkarter/dotfiles/commit/ebf505908582b6bc22c5fd7ae662733dff34c80d))

## [7.4.0](https://github.com/dkarter/dotfiles/compare/v7.3.0...v7.4.0) (2022-10-31)


### Features

* **nvim:** add text objects for function parameters ([90863c9](https://github.com/dkarter/dotfiles/commit/90863c9d3466fa45f2a58d345b6c493c812a3891))
* **nvim:** set fold method to treesitter ([5e95cba](https://github.com/dkarter/dotfiles/commit/5e95cbae98377b396daeb7b5b93bb4d940f4063d))


### Bug Fixes

* **alacritty:** remove deprecated use_thin_strokes ([b315cc1](https://github.com/dkarter/dotfiles/commit/b315cc1e6e1f1d10e2c9ff47eca14cecbfb2b38b))
* **nvim:** temporarily disable nvim-navic ([6c6aa1c](https://github.com/dkarter/dotfiles/commit/6c6aa1c42377968005dc4b769ff08f33225d9417))

## [7.3.0](https://github.com/dkarter/dotfiles/compare/v7.2.0...v7.3.0) (2022-10-20)


### Features

* **nvim:** add markdown_inline treesitter parser ([30e35a4](https://github.com/dkarter/dotfiles/commit/30e35a471329847485a84dff23897fc8c47ab9ed))


### Bug Fixes

* **nvim:** disable formatexpr on elixirls to allow `gq` mapping ([22cdfaa](https://github.com/dkarter/dotfiles/commit/22cdfaac36136a8315b3ade8cac7e1c4507c1391))
* **nvim:** force gitconfig filetype to be gitconfig ([5b22d38](https://github.com/dkarter/dotfiles/commit/5b22d386a2791b0deda1ba6f70b1ce018e0dc445))
* **nvim:** format Elixir <= 1.13 ([90f4a17](https://github.com/dkarter/dotfiles/commit/90f4a17235675e924082f6c642029a050972f685))
* **nvim:** remove markdown_fenced_languages opt ([1ea3dcd](https://github.com/dkarter/dotfiles/commit/1ea3dcd95b961eb5a14e3b6edfe3033871d40a2d))
* **nvim:** use mix format with stdin flag (`-`) to avoid reloads ([402a4e9](https://github.com/dkarter/dotfiles/commit/402a4e976762d9055589a55babd5691e711beebd))
* **zsh:** improve gfixup command ([6da5042](https://github.com/dkarter/dotfiles/commit/6da50429758d014471c1dd163b9759864b0abf5f))

## [7.2.0](https://github.com/dkarter/dotfiles/compare/v7.1.0...v7.2.0) (2022-10-18)


### Features

* **nvim:** add vim-sleuth ([a74eb3b](https://github.com/dkarter/dotfiles/commit/a74eb3bf2a4e5cc0189c33fa9e6061ca19ba65b7))


### Bug Fixes

* **nvim:** remove vim-elixir ([4793c44](https://github.com/dkarter/dotfiles/commit/4793c446eb7f7754e2d46b558b3c52136516f0a7))

## [7.1.0](https://github.com/dkarter/dotfiles/compare/v7.0.2...v7.1.0) (2022-10-17)


### Features

* **nvim:** add vmap mappings for hunk operations ([2cd8ba0](https://github.com/dkarter/dotfiles/commit/2cd8ba0f31ad933a208e97d20e91c522006bc21d))
* **zsh:** add a few git utility functions ([bd6c40d](https://github.com/dkarter/dotfiles/commit/bd6c40daa84aea23481d1f428af10b114faf0e96))


### Bug Fixes

* **nvim:** resolve deprecation for cmp (default_capabilities) ([a875ad3](https://github.com/dkarter/dotfiles/commit/a875ad3c96ea2111cc26d38bc6ccf2a45c614d6a))
* **nvim:** update GUI font to CaskaydiaCove ([9687b9f](https://github.com/dkarter/dotfiles/commit/9687b9fb17b71179a466695bdf1875324a23d9fc))
* **zsh:** correct wttr curls and remove hard coded location ([2faaacb](https://github.com/dkarter/dotfiles/commit/2faaacb2ca339a5418cb86e7cf6fa18b08ae81f7))

## [7.0.2](https://github.com/dkarter/dotfiles/compare/v7.0.1...v7.0.2) (2022-10-10)


### Bug Fixes

* **nvim:** fix Git Hydra ([91f43e9](https://github.com/dkarter/dotfiles/commit/91f43e93ba66912a648be56ee107289ceb2b4b42))

## [7.0.1](https://github.com/dkarter/dotfiles/compare/v7.0.0...v7.0.1) (2022-10-10)


### Bug Fixes

* **nvim:** disable retrail (whitespace highlighting) in FZF buffers ([56e061f](https://github.com/dkarter/dotfiles/commit/56e061fed7e7a4e14a6f66ead52ef372948f0938))

## [7.0.0](https://github.com/dkarter/dotfiles/compare/v6.2.1...v7.0.0) (2022-10-10)


### ⚠ BREAKING CHANGES

* **nvim:** improve git hydra mappings

### Features

* **installer:** add yq ([b2257c1](https://github.com/dkarter/dotfiles/commit/b2257c19cd7fe8e18a2997cbfc9da2443709e911))
* **nvim:** add more keys to Git Hydra ([f31b9af](https://github.com/dkarter/dotfiles/commit/f31b9afcd082a9b52a27bf5756f0b9717698a112))
* **nvim:** add Ruby HEREDOC language highlighting ([443ffd1](https://github.com/dkarter/dotfiles/commit/443ffd1af6023353f56d5a08e14e1b38bfd64b9e))
* **nvim:** add sql highlighting via treesitter ([e5966ac](https://github.com/dkarter/dotfiles/commit/e5966ac7de7d0f82d46b725a4a096ce611eb96b2))
* **nvim:** add TreeSitter Playground ([eb45639](https://github.com/dkarter/dotfiles/commit/eb4563939314f3bec2c85fa28ae0fbbc117bb53f))
* **nvim:** add treesitter query highlighting ([7911b32](https://github.com/dkarter/dotfiles/commit/7911b328ac7b46df2a2ac43575b8cbe629f807b4))
* **nvim:** improve git hydra mappings ([1bdd449](https://github.com/dkarter/dotfiles/commit/1bdd4493e5f6da50145b58f77391e536bf875e04))
* **nvim:** set spell globally ([62564e1](https://github.com/dkarter/dotfiles/commit/62564e106433be7d85d0ee93a8a5014d5bd53267))
* **nvim:** unfold all folds when opening a file ([e6306f9](https://github.com/dkarter/dotfiles/commit/e6306f9e40953f75cec0815ce8dd05462b87018f))


### Bug Fixes

* **alacritty:** typo in file name ([d75aa80](https://github.com/dkarter/dotfiles/commit/d75aa80000712cde1900951a30dd72f8f45a9cd5))
* **nvim:** accidentally overwrote gf mapping ([a643c8d](https://github.com/dkarter/dotfiles/commit/a643c8d82e68cec152c71a601ed632e3a9236743))
* **nvim:** swap preview_definition with peek_definition ([f907892](https://github.com/dkarter/dotfiles/commit/f90789284a990dc84589028e048704d93e85c704))

## [6.2.1](https://github.com/dkarter/dotfiles/compare/v6.2.0...v6.2.1) (2022-09-29)


### Bug Fixes

* **nvim:** don't run colorizer on packer buffers ([47664b4](https://github.com/dkarter/dotfiles/commit/47664b4420083e8784056982e9868ed30c1c8f45))

## [6.2.0](https://github.com/dkarter/dotfiles/compare/v6.1.0...v6.2.0) (2022-09-26)


### Features

* **nvim:** create Git Hydra ([b712cb1](https://github.com/dkarter/dotfiles/commit/b712cb195329165612fa84f7e447c76140fe6f32))

## [6.1.0](https://github.com/dkarter/dotfiles/compare/v6.0.0...v6.1.0) (2022-09-26)


### Features

* **nvim:** add Hydra + A Hydra Config for Telescope ([d6ca1a4](https://github.com/dkarter/dotfiles/commit/d6ca1a43dafdae9ceac592c492da2d5b551acf38))


### Bug Fixes

* **installer:** follow redirects when downloading fonts ([0510136](https://github.com/dkarter/dotfiles/commit/05101369c12856b6158be4b947bb3541ebcaf69c))
* **iterm:** don't use thin strokes in popover term ([e4b554e](https://github.com/dkarter/dotfiles/commit/e4b554e0b2be17e024fc38bf3fa505565a00592a))
* **nvim:** rename LSP Saga config file ([aa2b71f](https://github.com/dkarter/dotfiles/commit/aa2b71f164cca0b24c1fc15067293c8367422a8b))
* **nvim:** set filetype to bash for .envrc files ([1276250](https://github.com/dkarter/dotfiles/commit/12762504a9ea721aaeb6b39e9f850ed782145749)), closes [#35](https://github.com/dkarter/dotfiles/issues/35)

## [6.0.0](https://github.com/dkarter/dotfiles/compare/v5.5.0...v6.0.0) (2022-09-21)


### ⚠ BREAKING CHANGES

* **nvim:** change mappings for jumping between hunks

### Features

* **gitconfig:** enable loading local config ([fe0f6d1](https://github.com/dkarter/dotfiles/commit/fe0f6d118ae7b5d6d7d9ef450425b2abb8d5f90c))
* **installer:** script to download and install nerd fonts ([12ea600](https://github.com/dkarter/dotfiles/commit/12ea6005d3243eb67e0e92947e00e96f018733f6))
* **nvim:** add diffview.nvim for better diffs and file history ([a0b8c2d](https://github.com/dkarter/dotfiles/commit/a0b8c2d4292eb0052d3754cd902284e09b61c178))
* **nvim:** add global helpers for Lua ([cc2164b](https://github.com/dkarter/dotfiles/commit/cc2164b6027bc0b32e2bae9ac9053725ffac8d74))
* **nvim:** add MJML template support for sane email templating ([347247e](https://github.com/dkarter/dotfiles/commit/347247edfc74350c3e1b72c72ca4dfc9ba3a75de))
* **nvim:** auto format heex files (requires Elixir >= 1.14) ([c7c2379](https://github.com/dkarter/dotfiles/commit/c7c2379655398feeadbe4a03b316862d21d3558d))
* **zsh:** add hq for jq-like html querying and syntax highlighting ([401e955](https://github.com/dkarter/dotfiles/commit/401e955de4250df1174930927ece97d1456b40a8))


### Bug Fixes

* **alacritty:** correctly map <C-/> on macOS ([cc50afc](https://github.com/dkarter/dotfiles/commit/cc50afce4e8e9477dbd42fa280c7b4a88ddb6f57))
* **alacritty:** map Alt to Meta on macOS ([4ea5f0a](https://github.com/dkarter/dotfiles/commit/4ea5f0ae3e07726c494a0b0478d00ad0fb9147cc))
* **installer:** mute ruby experimental features ([6eee058](https://github.com/dkarter/dotfiles/commit/6eee0581f983e6b2add5bc484af9a1f0c6ac9711))
* **installer:** remove git folder sync (no longer in use) ([1a8c0a0](https://github.com/dkarter/dotfiles/commit/1a8c0a0e8190a9f84cae49e8f48318ba72723e81))
* **nvim:** add null-ls-info to retrail exclusion list ([6ecca94](https://github.com/dkarter/dotfiles/commit/6ecca94fa2f79aa872d31452db3a9075d86a19ed))
* **nvim:** bring back vim-elixir for now ([297426f](https://github.com/dkarter/dotfiles/commit/297426f3ee35b4b88f473b5e26d307dcf1e6c45a))
* **nvim:** don't restore position in event handlers ([4185356](https://github.com/dkarter/dotfiles/commit/41853568b8decbadcf326f3336caae035b7d4704))
* **nvim:** elixir formatting was broken ([91b3018](https://github.com/dkarter/dotfiles/commit/91b301871d1666ff18fdd98856a4bc690a6ae7e6))
* **nvim:** remove FixCursorHold (caused jumplist to not work properly) ([7c2427d](https://github.com/dkarter/dotfiles/commit/7c2427dbbb3cfe513eca22f53100dea65c975d2a))
* **nvim:** resolve new line being stripped from files (maybe) ([6d1e46f](https://github.com/dkarter/dotfiles/commit/6d1e46fbde093ad51c26874187913de2dc36cc74))
* **nvim:** ripgrep plugin should search hidden files ([da055f6](https://github.com/dkarter/dotfiles/commit/da055f6e4cf0cd67f9c2f6dd3d3b7515a42ae014))
* **nvim:** update tokyonight colorscheme setup code ([2b676b9](https://github.com/dkarter/dotfiles/commit/2b676b9f3f61d30ee3145739e44a672dac9f3138))
* **rubocop:** disable trailing new line check ([74d3d48](https://github.com/dkarter/dotfiles/commit/74d3d48621e5e5dabe94910ed6401896056d3cd3))
* trailing blank lines!!! ([bd55352](https://github.com/dkarter/dotfiles/commit/bd55352563903866e0421bc2fa57aa7db291f9ed))


### Code Refactoring

* **nvim:** change mappings for jumping between hunks ([8126ad0](https://github.com/dkarter/dotfiles/commit/8126ad0cb5210f9783bf7c59b7ea12cb0de1ad08))

## [5.5.0](https://github.com/dkarter/dotfiles/compare/v5.4.0...v5.5.0) (2022-09-08)


### Features

* add editorconfig file ([242ab1d](https://github.com/dkarter/dotfiles/commit/242ab1d77ba8f1d5c988ec499f75a3efda06ff11))
* **zsh:** add aliases for stashing/popping changes ([100e87a](https://github.com/dkarter/dotfiles/commit/100e87adaaad9d86681bd8d7e516060de6ae2a5e))


### Bug Fixes

* **lint:** correct lint errors ([d8f0a29](https://github.com/dkarter/dotfiles/commit/d8f0a29e8250d8c8e860bf7b9de451ff723bf665))
* **nvim:** remove unnecessary vim-elixir ([ee8706c](https://github.com/dkarter/dotfiles/commit/ee8706c3ad25521974e84fe119a154cef1898e11))

## [5.4.0](https://github.com/dkarter/dotfiles/compare/v5.3.0...v5.4.0) (2022-09-05)


### Features

* **rubocop:** enable new cops by default ([ebcd966](https://github.com/dkarter/dotfiles/commit/ebcd966eef5cd647fb6b61cf1c3b270ff02b08d3))


### Bug Fixes

* **yamllint:** disable annoying yaml lints ([96ef183](https://github.com/dkarter/dotfiles/commit/96ef183e101beeb6649a7208cdba7f1ab5248343))

## [5.3.0](https://github.com/dkarter/dotfiles/compare/v5.2.0...v5.3.0) (2022-09-05)


### Features

* **nvim:** expose functions for creating autocmds ([5f8a80a](https://github.com/dkarter/dotfiles/commit/5f8a80ad24070cb7348450b8cc88973bcf021983))
* **nvim:** spotlight styled Telescope prompt ([c762e49](https://github.com/dkarter/dotfiles/commit/c762e4916eb1e5e4d966cf41fc4e9f78e19176aa))
* **nvim:** use Telescope for spell suggestions ([7b24518](https://github.com/dkarter/dotfiles/commit/7b245182c287303f97cb602ef84145a5d21fb91e))


### Bug Fixes

* **nvim:** conditionally register credo lsp if installed in project ([f1d8e9c](https://github.com/dkarter/dotfiles/commit/f1d8e9cb2f62c16b7d48440e39712d66e48ac301))
* **nvim:** detach yamlls client from helm files ([dfd9af8](https://github.com/dkarter/dotfiles/commit/dfd9af8f217d7076486837d8687b3d00f002036d))

## [5.2.0](https://github.com/dkarter/dotfiles/compare/v5.1.1...v5.2.0) (2022-08-27)


### Features

* **tmux:** mappings for easily moving windows left and right ([9e94922](https://github.com/dkarter/dotfiles/commit/9e949227ec22ec15905426e82d46d5dd603ae448))


### Bug Fixes

* **nvim:** don't highlight trailing whitespace in some filetypes ([be0cad7](https://github.com/dkarter/dotfiles/commit/be0cad799d8741af8f98629c6c196aaa7dffda86))

## [5.1.1](https://github.com/dkarter/dotfiles/compare/v5.1.0...v5.1.1) (2022-08-26)


### Bug Fixes

* **gitmessage:** update git message template ([d262ff6](https://github.com/dkarter/dotfiles/commit/d262ff6ec6079918452602d6471ebfbed6052775))
* **rubocop:** config rule name was incorrect ([1bbe101](https://github.com/dkarter/dotfiles/commit/1bbe10118a2a0e64944e773dec2d0594ef0abf8f))

## [5.1.0](https://github.com/dkarter/dotfiles/compare/v5.0.0...v5.1.0) (2022-08-26)


### Features

* **nvim,zsh,tmux:** add e command for opening files in other pane ([f73aa3e](https://github.com/dkarter/dotfiles/commit/f73aa3e54d5bcd4979ba5d05c070f0f5727fd66c))
* **nvim:** add zsh checker for null-ls ([2a2a4bb](https://github.com/dkarter/dotfiles/commit/2a2a4bb2fe864085f85b6b68f598eec14b791422))

## [5.0.0](https://github.com/dkarter/dotfiles/compare/v4.1.0...v5.0.0) (2022-08-26)


### ⚠ BREAKING CHANGES

* **nvim:** change mapping for lsp_finder to be more intuitive

### Features

* **installer:** automatically configure certain macOS features ([8b1dbc7](https://github.com/dkarter/dotfiles/commit/8b1dbc7818d02703567840d37b01110b24ff5feb))
* **nvim:** make Elixir tests async by default in Projectionist template ([42f61b3](https://github.com/dkarter/dotfiles/commit/42f61b367f1c35f2620601fd5b6539ae32eff2ac))
* **nvr:** add neovim-remote support (+ elixir editor) ([7035321](https://github.com/dkarter/dotfiles/commit/7035321d7cfe3547395a114aac756ffc404908be))


### Bug Fixes

* **installer:** lint in setup.sh ([45292b7](https://github.com/dkarter/dotfiles/commit/45292b7682d1a606ee3c2e403bb012733a816307))
* **nvim:** address changes in elixir.nvim ([11b6846](https://github.com/dkarter/dotfiles/commit/11b68465cc225481ad4a8fbeb9a980b719810fa9))
* **nvim:** change mapping for lsp_finder to be more intuitive ([9c2c9bf](https://github.com/dkarter/dotfiles/commit/9c2c9bf6b2313d3318d28063aeeb2e89a7d4300f))
* **nvim:** git conflicts command didn't show conflicts in hidden files ([2633db2](https://github.com/dkarter/dotfiles/commit/2633db227030fdc757820d6517085d6664fe2ef8))
* **nvim:** remove blvd test file accommodations in Projectionist ([848f583](https://github.com/dkarter/dotfiles/commit/848f583da357d830c297907c3fdfb594f15acdf3))

## [4.1.0](https://github.com/dkarter/dotfiles/compare/v4.0.0...v4.1.0) (2022-08-21)


### Features

* **nvim:** add CommitLint null-ls diagnostics ([7a704c6](https://github.com/dkarter/dotfiles/commit/7a704c6bbbf2cfb275e701f9ca28149f57bec4bd))


### Bug Fixes

* **nvim:** adjust commit title max length highlight to 72 characters ([2b9c19c](https://github.com/dkarter/dotfiles/commit/2b9c19c38bf1566b62ca81736a52e72ad1e05d9b))
* **nvim:** remove emmet-ls ([b622621](https://github.com/dkarter/dotfiles/commit/b6226214abf4a5d067bbf55a89c5310e173a3ba8))

## [4.0.0](https://github.com/dkarter/dotfiles/compare/v3.2.0...v4.0.0) (2022-08-21)


### ⚠ BREAKING CHANGES

* **nvim:** add LSP Saga

### Features

* **nvim:** add autopairs plugin ([4dd5a3d](https://github.com/dkarter/dotfiles/commit/4dd5a3d5365f1d4fe3fecd23096ef6f195c9bb77))
* **nvim:** add color code highlighting ([e4b461b](https://github.com/dkarter/dotfiles/commit/e4b461b305df59a5469c6d7938f5411ee687f965))
* **nvim:** add html tag auto close ([11f534b](https://github.com/dkarter/dotfiles/commit/11f534b248b2e9d08130cfac15aa21318976ceba))
* **nvim:** add LSP Saga ([72b8889](https://github.com/dkarter/dotfiles/commit/72b8889e200f176cc6b296d7b60b4acf4d32dd72))
* **nvim:** highlight and find TODO comments ([982d285](https://github.com/dkarter/dotfiles/commit/982d2852691b51ef967eb16ccceb3e0a9c89f18d))
* **nvim:** mapping for sourcing lua/vim files ([f8c6005](https://github.com/dkarter/dotfiles/commit/f8c6005fecc67dd5d1e40c05acbd7b34dd78e759))
* **zinit:** add cht.sh + completions and cheat ([b38fca7](https://github.com/dkarter/dotfiles/commit/b38fca756e5049294f9bf34a06c61834940bd7be))
* **zsh:** add pager to cht command ([77da1fd](https://github.com/dkarter/dotfiles/commit/77da1fd0cc98ae37669623573eee1168a8cbedc4))


### Bug Fixes

* **nvim:** elixir formatting settings + comment ([6d2fec0](https://github.com/dkarter/dotfiles/commit/6d2fec0ffe3b995cb1285a28338693f7deb46235))
* **nvim:** elixir ls config ([8e53ff4](https://github.com/dkarter/dotfiles/commit/8e53ff4a4026a32430c0d3f5910336e9a821097d))
* **nvim:** enable dialyzer in elixirls (attempt) ([3c69022](https://github.com/dkarter/dotfiles/commit/3c69022ebb794bbb9fc1dad28e1a6e0baa0643db))
* **nvim:** ignore unused skidded variables (lua) ([dcc490d](https://github.com/dkarter/dotfiles/commit/dcc490da3d059f0c05a683ab7c5e072a99d239a6))
* **nvim:** mapping conflicts ([d83eaba](https://github.com/dkarter/dotfiles/commit/d83eabacd630cb0df0e0edb3d0b13a330155a3db))
* **nvim:** remove refactoring code actions ([9e3d21e](https://github.com/dkarter/dotfiles/commit/9e3d21e17c8b2ca04533f9ce09f6c0ae528c555f))
* **nvim:** remove spelling completion ([748473c](https://github.com/dkarter/dotfiles/commit/748473c09be81d8adfb4f08a107fdee08fd65e79))

## [3.2.0](https://github.com/dkarter/dotfiles/compare/v3.1.0...v3.2.0) (2022-08-17)


### Features

* **nvim:** add yamllint to mason installer ([8206450](https://github.com/dkarter/dotfiles/commit/8206450b04e22c32b5e26ed8d37ab301b5427eba))
* **nvim:** always run Credo in strict mode ([1c8f464](https://github.com/dkarter/dotfiles/commit/1c8f46495fc28dacce1028d9044eecfac3816294))
* **nvim:** enable elixir treesitter ([e10ea65](https://github.com/dkarter/dotfiles/commit/e10ea651e17ff7332647aca14c90c5c990d3b161))
* **zsh:** add cht command for curling cht.sh ([d1a16ae](https://github.com/dkarter/dotfiles/commit/d1a16ae28445d3a68ec82366a660eb1ea953e749))


### Bug Fixes

* **nvim:** add all LSPs to Mason Tool Installer ([58e6a6e](https://github.com/dkarter/dotfiles/commit/58e6a6eab942fa499a117e50b319c812efeb1262))
* **nvim:** add codespell to null-ls ([1a03e18](https://github.com/dkarter/dotfiles/commit/1a03e18fbc81aabad3f15871b71a1b3b0191d975))
* **nvim:** correct elixir-ls name for Mason ([53c6419](https://github.com/dkarter/dotfiles/commit/53c6419c53acbc54ae0fbc4c8b0590687635d115))
* **nvim:** remove null-ls debug flag ([fe36e1f](https://github.com/dkarter/dotfiles/commit/fe36e1f1bf340f35f7c34fb6a0e223078350c7d9))

## [3.1.0](https://github.com/dkarter/dotfiles/compare/v3.0.0...v3.1.0) (2022-08-10)


### Features

* **nvim:** add automatic mason tool installer ([0dcf428](https://github.com/dkarter/dotfiles/commit/0dcf428fbc2e652cd4509f59d8550dc824b44cad))


### Bug Fixes

* **nvim:** add missing argument to function call ([bab784e](https://github.com/dkarter/dotfiles/commit/bab784ed208b5dd3a239d7b4ec74068687154ae1))
* **nvim:** correctly hook LSP on_attach ([16c2603](https://github.com/dkarter/dotfiles/commit/16c26035b1befddc1ed17f00a0dbf26ab70f28cf))

## [3.0.0](https://github.com/dkarter/dotfiles/compare/v2.11.0...v3.0.0) (2022-08-07)


### ⚠ BREAKING CHANGES

* switch lsp config to Mason

### Features

* **nvim:** add 'contains' util function ([243646d](https://github.com/dkarter/dotfiles/commit/243646dce4ff2c9853f80dc9acb3aea9f8b86d97))


### Code Refactoring

* switch lsp config to Mason ([7202090](https://github.com/dkarter/dotfiles/commit/7202090eb084137880a3905aab1555f737e2c631))

## [2.11.0](https://github.com/dkarter/dotfiles/compare/v2.10.0...v2.11.0) (2022-07-13)


### Features

* **installer:** add Nerves debian packages ([2468319](https://github.com/dkarter/dotfiles/commit/24683198dba9509c4d07834465d465eb39e8d695))
* **nvim:** add K8s completion support for yamlls ([dc2f9bd](https://github.com/dkarter/dotfiles/commit/dc2f9bdf9f2b58a76eece1e51b17cb23d6d7147e))

## [2.10.0](https://github.com/dkarter/dotfiles/compare/v2.9.0...v2.10.0) (2022-06-17)


### Features

* add git hunk based mappings ([14fce6e](https://github.com/dkarter/dotfiles/commit/14fce6eaa4ae237cf91d160f8cef1f79a1832780))
* **git:** automatically merge JS lockfiles ([2b0d203](https://github.com/dkarter/dotfiles/commit/2b0d20336b47b4d622d5fb955882791fa15d2fd1))
* **git:** use zebra for moved line colors ([6b0ff53](https://github.com/dkarter/dotfiles/commit/6b0ff531c5477daec7acfada4b324bf83bee2893))


### Bug Fixes

* **installer:** remove eslintrc ([c341406](https://github.com/dkarter/dotfiles/commit/c341406bc54c526156f8472712e32508b303e579))
* **nvim:** accommodate Malomo naming conventions ([d49229e](https://github.com/dkarter/dotfiles/commit/d49229ef91cb2605e52158a4aa9d7be9f6319c19))

## [2.9.0](https://github.com/dkarter/dotfiles/compare/v2.8.1...v2.9.0) (2022-06-07)


### Features

* **nvim:** add generic `map` function ([688641d](https://github.com/dkarter/dotfiles/commit/688641dae373e90a155b38e39b8b422869b52c6e))

## [2.8.1](https://github.com/dkarter/dotfiles/compare/v2.8.0...v2.8.1) (2022-06-03)


### Bug Fixes

* **installer:** incompatible ARM ASDF plugins ([6f6704e](https://github.com/dkarter/dotfiles/commit/6f6704ed6fefe7f838421c0826a70c3449d0ce4f))
* **installer:** mark Neovim ASDF incompat w/ ARM ([6178527](https://github.com/dkarter/dotfiles/commit/6178527efe5b2df1b1d0a70ee0cc545156b0a32b))
* **nvim:** attempt.nvim run commands ([f3986b7](https://github.com/dkarter/dotfiles/commit/f3986b7973f24d05a898201012b68e5e932b3747))

## [2.8.0](https://github.com/dkarter/dotfiles/compare/v2.7.0...v2.8.0) (2022-05-30)


### Features

* **nvim:** add attempt.nvim ([2f187e3](https://github.com/dkarter/dotfiles/commit/2f187e3e7bdfe81d43dd40101f4ab158d6052557))


### Bug Fixes

* **nvim:** remove global eslint ([09d9d64](https://github.com/dkarter/dotfiles/commit/09d9d64a050e7cd2c4d269cc640a8ce9f0435b88))

## [2.7.0](https://github.com/dkarter/dotfiles/compare/v2.6.1...v2.7.0) (2022-05-29)


### Features

* **nvim:** add context aware commenting ([abefabc](https://github.com/dkarter/dotfiles/commit/abefabc7e63c5e727dbe40c30224bc490a1d2c37))
* **nvim:** add TreeSitter powered TextObjects ([8358c22](https://github.com/dkarter/dotfiles/commit/8358c229ca91a08f40a058ec99642cebdcb1bf18))


### Bug Fixes

* **nvim:** add missing file Comment config ([22c2981](https://github.com/dkarter/dotfiles/commit/22c2981fd53ea677ea5e2d2fcb1310eeeab0230f))

### [2.6.1](https://github.com/dkarter/dotfiles/compare/v2.6.0...v2.6.1) (2022-05-28)


### Bug Fixes

* **nvim:** tighten n-mode mappings for ripgrep ([4c4cb58](https://github.com/dkarter/dotfiles/commit/4c4cb587e6f24dfe669c502b609dc44a76533810))

## [2.6.0](https://github.com/dkarter/dotfiles/compare/v2.5.0...v2.6.0) (2022-05-26)


### Features

* **brew:** add llvm ([a0ae818](https://github.com/dkarter/dotfiles/commit/a0ae818ec712c7d57bd56cc210919c7ca4deb3d4))
* **brew:** add wget ([bdab30d](https://github.com/dkarter/dotfiles/commit/bdab30de26b4d5726aea2232649f05be28575588))


### Bug Fixes

* **brew:** remove java ([1d08dff](https://github.com/dkarter/dotfiles/commit/1d08dffa6291033e80918bfaf80903891af4409a))
* **installer:** enable brew after installing it ([f986390](https://github.com/dkarter/dotfiles/commit/f9863908a7bfe2792bd19655d9d637953d977091))

## [2.5.0](https://github.com/dkarter/dotfiles/compare/v2.4.4...v2.5.0) (2022-05-26)


### Features

* **brew:** add docker cask ([4972ff4](https://github.com/dkarter/dotfiles/commit/4972ff427cb2511e16fa940a8be68e3c97995088))

### [2.4.4](https://github.com/dkarter/dotfiles/compare/v2.4.3...v2.4.4) (2022-05-23)


### Bug Fixes

* **nvim:** remove visual multi cursor ([10d4f1e](https://github.com/dkarter/dotfiles/commit/10d4f1e66c55da8ebbc3709b783384e53e9510d7))

### 2.4.3 (2022-05-21)


### Bug Fixes

* **nvim:** snippet load and mappings ([0697f58](https://github.com/dkarter/dotfiles/commit/0697f581ab96b1045b8f05defc04b89d0ff70188))

### 2.4.2 (2022-05-20)


### Bug Fixes

* **psql:** standardize history path ([c10aea0](https://github.com/dkarter/dotfiles/commit/c10aea011fc748bc3461d21de611f8ecfc261ab2))

### 2.4.1 (2022-05-20)

## 2.4.0 (2022-05-20)


### Features

* **nvim:** add firenvim (Neovim in Firefox) ([32bf789](https://github.com/dkarter/dotfiles/commit/32bf7899e12786e3fa8581c18f6b697191e322c2))

## 2.3.0 (2022-05-18)


### Features

* **nvim:** accommodate Malomo conventions ([8111f74](https://github.com/dkarter/dotfiles/commit/8111f742697f00d578bc91fe541072811c0ca525))

## 2.2.0 (2022-05-15)


### Features

* **nvim:** add ReloadModules command ([bd91ea0](https://github.com/dkarter/dotfiles/commit/bd91ea0cdf06e39d6f832e119647b3939f3bdd18))

### 2.1.1 (2022-05-14)

## [2.1.0](https://github.com/dkarter/dotfiles/compare/v2.0.0...v2.1.0) (2022-05-13)


### Features

* **brew:** add default browser package ([f7598d9](https://github.com/dkarter/dotfiles/commit/f7598d90459b1a03fe20c1a0d60ce9747392a9b5))

## [2.0.0](https://github.com/dkarter/dotfiles/compare/v1.1.1...v2.0.0) (2022-05-13)


### ⚠ BREAKING CHANGES

* **nvim:** Removes some old and unused mappings and functions

* **nvim:** remove ToggleWrap and zoom ([598f21e](https://github.com/dkarter/dotfiles/commit/598f21e6fca32c01ff3d9dfc4d7bc787ee01eb68))

### [1.1.1](https://github.com/dkarter/dotfiles/compare/v1.1.0...v1.1.1) (2022-05-13)

## [1.1.0](https://github.com/dkarter/dotfiles/compare/v1.0.0...v1.1.0) (2022-05-13)


### Features

* add automatic versioning and changelog ([e245b24](https://github.com/dkarter/dotfiles/commit/e245b2450c038b31a45ce748ac4aa701f2932af4))
