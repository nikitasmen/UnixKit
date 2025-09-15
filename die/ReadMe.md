# die

A Bash script to easily shut down, log out, or put your system to sleep using command-line arguments.

## Features
- Shutdown, logout, or sleep your system from the command line
- Simple argument-based interface
- Optional timer for delayed shutdown

## Usage
```bash
./die [option] [timer_seconds]
```

### Options
- `-s`: Puts your system to sleep
- `-l`: Logs you out of your GNOME session
- `-t [seconds]`: Shuts down your system after a specified delay (default: 15 seconds)
- (no option): Shuts down your system after a 5-second delay

### Examples
```bash
./die -s        # Sleep
./die -l        # Logout
./die -t 30     # Shutdown in 30 seconds
./die -t        # Shutdown in 15 seconds (default)
./die           # Shutdown in 5 seconds
```

## Tips
- Use `Ctrl+C` to cancel shutdown
- Requires `systemctl`, `gnome-session-quit`, etc.

## License
This script is part of the KubuntuCustoms toolkit.

