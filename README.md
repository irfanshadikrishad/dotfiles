#### Installing Configs

Install `stow`

```bash
sudo apt install stow
```

Clone the repo

```bash
https://github.com/irfanshadikrishad/dotfiles.git
```

Go to the dotfiles directory

```bash
cd dotfiles
```

Install the configs

```bash
stow cava
stow nvim
stow zsh
```

#### Adding New Configs

Each config should live in its own folder, named after the application or tool. Inside that folder, recreate the path where the config would normally live.

For example, to manage `~/.config/nvim/init.lua`, structure it like:

```bash
.dotfiles/
└── nvim/
    └── .config/
        └── nvim/
            └── init.lua
```

To manage `~/.gitconfig`, structure it like:

```bash
.dotfiles/
└── git/
    └── .gitconfig
```

Move or copy the config file into the appropriate folder in `.dotfiles`. For example:

```bash
mv ~/.gitconfig ~/.dotfiles/git/.gitconfig
```

Run stow from inside the `.dotfiles` directory:

```bash
stow git
```

This will create a symbolic link like:

```bash
~/.gitconfig -> ~/.dotfiles/git/.gitconfig
```

> [!IMPORTANT]
> If Symlink Is Not Created:
> Sometimes symlinks aren’t created if the target path is misaligned. In that case, force the correct target using:

```bash
stow -v --target=$HOME [package_folder_name]
```

Example structure
| Package | What it Manages | Structure in `.dotfiles` |
| ----------- | ----------------------------------- | ------------------------------------------- |
| `git` | `~/.gitconfig` | `git/.gitconfig` |
| `nvim` | `~/.config/nvim/` | `nvim/.config/nvim/init.lua` |
| `zsh` | `~/.zshrc` | `zsh/.zshrc` |
| `alacritty` | `~/.config/alacritty/alacritty.yml` | `alacritty/.config/alacritty/alacritty.yml` |

#### Unstowing (Removing Symlinks)

To remove symlinks (without deleting files)

```bash
stow -D [package_folder_name]
```

for example

```bash
stow -D nvim
```
