# dotfiles
These dotfiles are used on my (desktop) debian systems aiming towards consistent environments.

# Prerequisites
* Debian 13 - also works with `trixie/sid`
* [Wayland](https://wayland.freedesktop.org/) with [Sway](https://swaywm.org/)

# Install
* Clone repo in root of user directory (e.g. /home/user)
* `chmod +x scripts/setup_environment.sh`
* `./scripts/setup_environment.sh`

## Alternative install
```bash
cd ~
git init
git remote add origin https://github.com/dnnsdev/dotfiles
git pull origin main
```

These dotfiles are always in development and do not always represent the current state that they are in, as they are changed throughout time. In these files I took inspiration from other people too, so all credits to whom helped me out too.

No licence, feel free to take what you like. I'm not responsible for broken systems 👌.

## Post-install
After rebooting, you may need to:
* Log out and log back in for group changes to take effect
* Configure your shell to use the new dotfiles
* Restart any applications that use the new configurations