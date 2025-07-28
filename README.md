# UnitKit

A collection of custom Bash scripts for Linux environment automation and productivity enhancement.

## Overview

UnitKit offers various utility scripts that help automate common tasks and enhance productivity in a Linux environment. These scripts cover various aspects of system management, file operations, and development workflows.

## Scripts

### 📋 Clipboard Management
- **clip** - Copy file contents to clipboard with flexible line selection

### 🔧 System Management
- **die** - Easily shut down, log out, or put your system to sleep
- **killer** - A safer alternative to xkill that prevents desktop termination
- **ScreenKiller** - Turn off the screen with a simple command

### 💻 Development Tools
- **cleanBranches** - Clean up Git branches with interactive or force options
- **scriptRunner** - Run scripts in different languages without worrying about compiler selection
- **ScriStaller** - Install and manage custom scripts on your system
- **zoomer** - Store and quickly access Zoom meeting links

### 🔐 Password Management
- **passman** - Secure CLI password manager with MySQL backend
- **passpath** - Find paths of secured files

### 🛠️ Generic Utilities
- **Add_quotes_json** - Add quotes to keys in JSON files
- **One_automation** - Remove extensions from files and recommit them
- **lame** - Quick access to Llama3 via Ollama

## Installation

### Installing Dependencies

KubuntuCustoms provides an automatic dependency installer that works across multiple operating systems:

```bash
# Make the installer executable
chmod +x install_dependencies.sh

# Run the installer
./install_dependencies.sh
```

The installer will automatically detect your operating system (Ubuntu/Debian, Arch Linux, Fedora, NixOS, or macOS) and install the required packages. All dependencies are defined in the `DEPS.json` file and loaded dynamically by the installer.

#### NixOS Support

For NixOS users:

- The installer provides guidance on adding packages to your `configuration.nix` file
- A temporary shell with all required packages is offered for immediate usage
- Docker setup instructions specific to NixOS are provided

For non-NixOS systems with Nix installed:

- The system will use your native package manager (apt, pacman, dnf) if available
- If no native package manager is found, Nix-specific options are provided:
  - A temporary Nix shell with all dependencies
  - A `shell.nix` file for your project directory
- No packages are installed using `nix-env` to respect Nix's declarative approach

#### Managing Dependencies

A dependency manager script is also provided to help maintain the dependencies list:

```bash
# List dependencies for a specific system
./deps_manager.sh list Debian

# Add a package to a system's dependencies
./deps_manager.sh add Arch fzf

# Add a Python package for the assistant tool
./deps_manager.sh addpy pandas

# Export dependencies to individual files for each system
./deps_manager.sh export
```

See [DEPENDENCIES.md](DEPENDENCIES.md) for a detailed description of all dependencies.

### Installing Scripts

To install any individual script:

```bash
./scriptInstaller/ScriStaller /path/to/script desired_command_name
