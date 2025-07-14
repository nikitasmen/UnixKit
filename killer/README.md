# Killer

A safer alternative to xkill for closing application windows in X11 environments.

## Overview

Killer is a utility that provides similar functionality to `xkill`, but with an important safety feature: it prevents accidental killing of desktop environments. This solves a significant issue with the standard `xkill` command, which can terminate desktop sessions if misused, often requiring a system restart to recover.

## Features

- Allows you to select and kill graphical applications by clicking on their windows
- Prevents killing desktop windows, avoiding accidental system disruptions
- Displays information about the window and process being terminated

## Dependencies

- `xdotool` - For window selection and identification
- `xprop` - For retrieving window properties and process information

## Installation

Ensure you have the required dependencies:

```bash
# For Ubuntu/Debian
sudo apt install xdotool x11-utils

# For Arch Linux
sudo pacman -S xdotool xorg-xprop

# For Fedora
sudo dnf install xdotool xorg-x11-utils
```

## Usage

Simply run the command:

```bash
killer
```

Your cursor will change to a crosshair. Click on the window you want to close.

## How It Works

1. The script uses `xdotool` to let you select a window
2. It checks if the selected window is a desktop window
3. If it's a regular application window, it retrieves the process ID using `xprop`
4. The script terminates the process using the standard `kill` command

## Safety Features

- Desktop protection: The script checks if the window name contains "Desktop" and prevents killing these critical system components
- Feedback: Provides clear messages about which process is being terminated or if no window was selected

## Differences from xkill

| Feature | Killer | xkill |
|---------|--------|-------|
| Window selection | Uses xdotool | Direct X11 selection |
| Desktop protection | Yes | No |
| Process termination | Uses process ID | Uses X window ID |
| Safety | Prevents desktop killing | Can kill desktop |

## License

This project is part of the KubuntuCustoms toolkit and is licensed under the same terms.
