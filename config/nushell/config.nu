# config.nu
#
# Installed by:
# version = "0.101.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

# Starship prompt installation for Nushell
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")


$env.config = {
  # opens neovim when running 'config nu'
  buffer_editor: "nvim"

  # hides the welcome message
  show_banner: false

  # enable vi mode
  edit_mode: 'vi'

  ls: {
      use_ls_colors: true # use the LS_COLORS environment variable to colorize output
      clickable_links: true # enable or disable clickable links. Your terminal has to support links.
  }

  rm: {
      always_trash: true # always act as if -t was given. Can be overridden with -p
  }

  history: {
    max_size: 100_000 # Session has to be reloaded for this to take effect
    sync_on_enter: true # Enable to share history between multiple sessions, else you have to close the session to write history to file
    file_format: "sqlite" # "sqlite" or "plaintext"
    isolation: false # only available with sqlite file_format. true enables history isolation, false disables it. true will allow the history to be isolated to the current session using up/down arrows. false will allow the history to be shared across all sessions.
  }

 # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (line is the default)
  cursor_shape: {
    emacs: line
    vi_insert: blink_line
    vi_normal: blink_block
  }
}

source ($nu.config-path | path dirname | path join "aliases.nu")
