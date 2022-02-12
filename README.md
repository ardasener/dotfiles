# dotfiles

Configuration files for various UNIX programs like vim, tmux etc.
Also some shell scripts are included.

I manage these using [chezmoi](https://www.chezmoi.io/).

Here is how I use chezmoi as a reference to **future me**:

- Install fresh and update the local files: 

```bash
sh -c "$(curl -fsLS chezmoi.io/get)" -- init --apply --ssh ardasener
```

> Alternatively the system_setup script in this repo could be used (but it is WIP at the moment)

- I prefer to use `.bin` over the `bin` directory it uses by default so:

```bash
mkdir -p ~/.bin && mv ~/bin/* ~/.bin/ && rm -rf ~/bin
```

- I prefer the avoid using `.bashrc` directly as many programs write stuff there automatically. So source the bash_config there:

```bash
echo "# Source the config" >> ~/.bashrc && echo "source ~/.config/bash_config.sh" >> ~/.bashrc
```

- I make my changes locally and then to update the remote:
> Probably not the best way to do it but habits die hard
```bash
chezmoi re-add
chezmoi cd
# add,commit and push with git
exit
```

- To update local files from the remote:
```bash
chezmoi update
```
