# KubuntuCustoms Project Dependencies

This document provides a comprehensive list of dependencies for each script in the KubuntuCustoms project. It serves as a reference to understand what tools and libraries are required for each component.

## System-wide Dependencies

These dependencies are required by multiple scripts across the project:

- **Bash** (`bash`): The shell used by most scripts
- **sudo**: Required for scripts that need elevated privileges
- **Git**: Required for branch management scripts

## Script-specific Dependencies

### 1. clip - Clipboard Utility

**Description**: Copies file contents to the clipboard with line selection capabilities.

**Dependencies**:

- At least one clipboard manager (in order of preference):
  - `clipse` - Custom clipboard manager
  - `pbcopy` - macOS clipboard command
  - `xclip` - X11 clipboard utility
  - `wl-copy` - Wayland clipboard utility
- `cat` - For reading files
- `head` - For reading specific number of lines
- `sed` - For extracting line ranges
- `find` - For searching files
- `grep` - For filtering search results

### 2. lame - LLM Interface

**Description**: Interface for running Llama3 model via Docker.

**Dependencies**:

- `docker` - Container runtime
- Docker daemon - Must be running
- Internet connectivity - For pulling Docker images

### 3. cleanBranches - Git Branch Manager

**Description**: Tool for cleaning up Git branches.

**Dependencies**:

- `git` - Version control system
- `grep` - For filtering branch names
- `sed` - For string manipulation
- `awk` - For text processing

### 4. zoomer - Zoom Meeting Manager

**Description**: Stores and opens Zoom meeting links.

**Dependencies**:

- `zoom` - Zoom client application
- `grep` - For searching meeting links
- `cut` - For text extraction

### 5. scriptRunner - Script Execution Tool

**Description**: Runs scripts based on their file extension.

**Dependencies**:

- `python3` - For Python scripts
- `bash` - For shell scripts
- `node` - For JavaScript files
- `javac` & `java` - For Java files
- `g++` - For C++ files
- `gcc` - For C files
- `npx` & `playwright` - For TypeScript tests

### 6. scriptInstaller (ScriStaller) - Script Installer

**Description**: Installs scripts to the system path.

**Dependencies**:

- `sudo` - For copying to system directories
- `cp` - For copying files
- `chmod` - For setting permissions

### 7. screenKiller - Screen Power Manager

**Description**: Utility to turn off the screen with key-based waking.

**Dependencies**:

- `xset` - X server settings utility (part of X11)
- `read` - For detecting key presses

### 8. killer - Safe Window Killer

**Description**: A safer alternative to xkill.

**Dependencies**:

- `xdotool` - X11 automation utility
- `xprop` - X property display
- `awk` - For text processing

### 9. die - System Power Management

**Description**: Utility for shutdown, sleep, and logout operations.

**Dependencies**:

- `systemctl` - For system control (shutdown, suspend)
- `gnome-session-quit` - For logging out (GNOME desktop environments)

### 10. generic/Add_quotes_json - JSON Key Formatter

**Description**: Adds quotes around JSON keys.

**Dependencies**:

- `sed` - For text processing
- `cat` - For file reading

### 11. generic/One_automation - Git Automation

**Description**: Script to remove file extensions and commit to Git.

**Dependencies**:

- `git` - For version control operations
- `basename` - For file name manipulation
- `dirname` - For directory path extraction
- `sudo` - For file operations with elevated privileges

### 12. assistant - Voice Recognition

**Description**: Python script for audio transcription.

**Dependencies**:

- Python packages (listed in requirements.txt):
  - `whisper` - OpenAI's speech recognition model
  - `numpy` - Numerical processing
  - `sounddevice` - Audio recording
- System audio input device

### 13. unixKit - Script Launcher

**Description**: Central launcher for all scripts in the project.

**Dependencies**:

- `tree` (optional) - For displaying directory structure
- Dependencies of individual scripts it calls

### 14. password-manager - Password Management

**Description**: C++ based password management system.

**Dependencies**:

- `g++` - C++ compiler
- Standard C++ libraries

## Common Library

### error_handling - Error Handling Library

**Description**: Common library for standardized error handling.

**No external dependencies**, but requires:

- `bash` - Shell interpreter
- `echo` - For output display
- `command` - For checking command existence

## Installation Recommendations

To install all system dependencies on common Linux distributions:

### Ubuntu/Debian

```bash
sudo apt update
sudo apt install bash git xclip wl-clipboard python3 nodejs npm default-jdk g++ gcc xdotool x11-utils gnome-session tree docker.io
```

### Arch Linux

```bash
sudo pacman -S bash git xclip wl-clipboard python nodejs npm jdk-openjdk gcc xdotool xorg-xprop gnome-session tree docker
```

### Fedora

```bash
sudo dnf install bash git xclip wl-clipboard python3 nodejs npm java-latest-openjdk gcc xdotool xorg-x11-utils gnome-session-utils tree docker
```

### NixOS

Add to your `configuration.nix`:

```nix
environment.systemPackages = with pkgs; [
  bash
  git
  xclip
  wl-clipboard
  python3
  python3Packages.pip
  nodejs
  nodejs.pkgs.npm
  jdk
  gcc
  xdotool
  xorg.xprop
  gnome.gnome-session
  tree
  jq
  docker
];

# For Docker support
virtualisation.docker.enable = true;
users.users.YOUR_USERNAME.extraGroups = [ "docker" ];
```

Then run:

```bash
sudo nixos-rebuild switch
```

### macOS (using Homebrew)

```bash
brew install bash git tree node python openjdk docker
# Note: pbcopy is built into macOS
```

## Additional Notes

1. For scripts that use Docker, ensure the Docker daemon is running:

   ```bash
   sudo systemctl start docker
   sudo systemctl enable docker
   ```

2. For the assistant script, install Python dependencies:

   ```bash
   pip install -r assistant/requirements.txt
   ```

3. For full functionality across different desktop environments:
   - X11 users need xclip, xdotool, xprop
   - Wayland users need wl-clipboard
   - GNOME users need gnome-session
   - KDE users may need plasma-desktop packages
