# die

A Bash script to easily shut down, log out, or put your system to sleep using command-line arguments.

## Features
- Shutdown, logout, or sleep your system from the command line
- Simple argument-based interface

## Usage
```bash
./die [option]
```

### Options
- `-s`: Puts your system to sleep
- `-l`: Logs you out of your GNOME session
- (no option): Shuts down your system after a 5-second delay

### Examples
```bash
./die -s   # Sleep
./die -l   # Logout
./die      # Shutdown
```

## Tips
- Use `Ctrl+C` to cancel shutdown
- Requires `systemctl`, `gnome-session-quit`, etc.

## License
This script is part of the KubuntuCustoms toolkit.

