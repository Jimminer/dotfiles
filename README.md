# dotfiles
A collection of my important dotfiles

This repo is intended for personal convenience but feel free to `Ctrl-C Ctrl-V` anything you like 😁


## Contents
- **alacritty**
    - Alacritty terminal config (mostly colors)
- **awesome**
    - AwesomeWM config with a lot of custom things _(see [here](#awesomewm-config) for more info)_
- **mpv**
    - Mpv config with the [uosc](https://github.com/tomasklaen/uosc) theme
- **rofi**
    - Rofi config
- **Thunar**
    - Thunar config with my custom actions and keybinds
- **VSCodium**
    - VSCodium user settings and product.json configs
- **.zshrc**
    - Zsh config with my custom alieases and functions




## AwesomeWM Config
Most of the config is either made by me or kept unchanged from the default awesome config but there are many resources that helped me. From some of them I got ideas and inspiration, from others I found ways to do things I didn't know how to do.

Here are some of the most notable ones:

- [AwesomeWM Documentation](https://awesomewm.org/doc/api/) - The official documentation
- [ArcoLinux](https://www.arcolinux.info/) - Specifically ArcoLinuxB awesome edition
- [awesome-wm-widgets](https://github.com/streetturtle/awesome-wm-widgets) - An amazing library with all sorts of widgets
- [AwesomeWM subreddit](https://www.reddit.com/r/awesomewm/)
- [UnixPorn subreddit](https://www.reddit.com/r/unixporn/)


### Basic Info
My config for awesome is tailored towards my setup and my needs. It will probably not work out of the box for you and you will have to change some things. I will try to explain everything as best as I can but if you have any questions or need any help, hit me up on Discord: **`@mitsos`** or open an issue on this repo.


### Setup
>**OS**: Arch Linux<br>
**CPU**: AMD Ryzen 7 5800X<br>
**GPU**: AMD Radeon RX 5700 XT


### Custom Commands
Some commands I've made to help me make some things easier

| Command      | Arguments        | Description       |
| ------------ | ---------------- | ----------------- |
| `printn`     | _text_           | Uses awesome's `naughty` library to send a notification (used mostly for debugging) |
| `runCommand` | _command_        | Opens a process from the given command and returns it's output |
| `runInTag`   | _program_, _tag_ | Runs a program in the given tag (desktop) |


### Custom Widgets
Bar widgets I've made to display useful info or provide some functionality

| Widget           | Description       |
| ---------------- | ----------------- |
| `battery`        | Battery percentage, charging status and charge/discharge time |
| `cpuInfo`        | CPU usage and temperature |
| `languageChange` | Displays volume level and mute status |
| `memoryInfo`     | RAM usage |
| `nowPlaying`     | Currently playing song |
| `gpuInfo`        | GPU usage and temperature |
| `volume`         | Volume level and mute status _(LMB: toggle mute, MMB: pavucontrol, SCROLL: change volume)_ |


### Dependencies
To use this config without making any changes you will need the following dependencies:

- [awesome](https://github.com/awesomeWM/awesome) - The window manager itself
- [xorg-server](https://wiki.archlinux.org/title/xorg) - Display server
- [picom-jonaburg-fix](https://github.com/Arian8j2/picom-jonaburg-fix) - Compositor


### Optional Dependencies
- [rofi](https://github.com/davatorium/rofi) - Application launcher
- [pavucontrol](https://www.archlinux.org/packages/extra/x86_64/pavucontrol/) - PulseAudio volume control
- [copyq](https://github.com/hluk/CopyQ) - Clipboard manager
- [flameshot](https://github.com/flameshot-org/flameshot) - Screenshot tool
- [nm-applet](https://wiki.archlinux.org/title/NetworkManager#nm-applet) - NetworkManager applet
- [gnome policy kit](https://gitlab.gnome.org/Archive/policykit-gnome) - Policy kit authentication agent