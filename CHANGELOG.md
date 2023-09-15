# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

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
