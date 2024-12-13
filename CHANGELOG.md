# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

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
