Dorian's Dotfiles
===================

![screenshot](./screenshot.png)

Originally based on the ThoughtBot base configuration but HEAVILY customized to my needs and ergonomics.

Feel free to "steal" anything you want, and if you have a question please open an issue.

--------

# Installation

Easy.. 

```sh
git clone git@github.com:dkarter/dotfiles.git
```

Cd into the dotfiles dir: `cd dotfiles`

If on mac install homebrew, and run `brew bundle`

To install dotfiles, latest versions of asdf languages and packages, run:

```sh
ruby setup.rb
```

--------

## FAQ
<details>
<summary>Q: Why are things named without a dot at the beginning?</summary>
A: It makes it easier to include files in this repo if they are not named
exactly how they would be when symlinked over (I symlink the files here to my home
directory).  e.g. if I want to include the global `.gitignore` in this repo it
will override this repo's `.gitignore`.
</details>
