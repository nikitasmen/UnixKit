#!/usr/bin/env bash

# =============================================================================
# KubuntuCustoms Dependencies Installer
# Installs all required dependencies for the KubuntuCustoms project
# Supports: Ubuntu/Debian, Arch Linux, Fedora, macOS
# =============================================================================

# Set colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Icons for visual representation
CHECK_ICON="✅"
ERROR_ICON="❌"
WARNING_ICON="⚠️"
INFO_ICON="ℹ️"

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Dependencies file
DEPS_FILE="$SCRIPT_DIR/DEPS.json"

# Check if the dependencies file exists
if [ ! -f "$DEPS_FILE" ]; then
    echo -e "${RED}${ERROR_ICON} Dependencies file not found: $DEPS_FILE${NC}"
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo -e "${YELLOW}${WARNING_ICON} jq is required for parsing JSON but not installed.${NC}"
    echo -e "${BLUE}${INFO_ICON} Attempting to install jq...${NC}"
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install jq
        else
            echo -e "${RED}${ERROR_ICON} Homebrew is not installed. Please install jq manually.${NC}"
            exit 1
        fi
    elif command -v nix &> /dev/null || [ -d "/nix" ] || [ -f "/etc/nix/nix.conf" ]; then
        # NixOS or system with Nix
        # Check if this is NixOS
        is_nixos=false
        if [ -f "/etc/os-release" ]; then
            . /etc/os-release
            if [ "$ID" = "nixos" ]; then
                is_nixos=true
            fi
        fi
        
        if command -v nix-shell &> /dev/null; then
            # Create a temporary shell with jq
            echo -e "${BLUE}${INFO_ICON} Creating a temporary shell with jq for parsing...${NC}"
            
            # We use nix-shell with --pure to avoid PATH pollution, and run the rest of the script
            # with jq available in the PATH
            exec nix-shell -p jq --run "exec \"$0\" \"$@\""
            # If exec fails, we'll continue with the script, but jq won't be available
        else
            echo -e "${RED}${ERROR_ICON} Could not create a Nix shell with jq. Please install jq manually.${NC}"
            exit 1
        fi
    elif command -v apt-get &> /dev/null; then
        # Debian/Ubuntu
        sudo apt-get update && sudo apt-get install -y jq
    elif command -v pacman &> /dev/null; then
        # Arch
        sudo pacman -Sy --noconfirm jq
    elif command -v dnf &> /dev/null; then
        # Fedora
        sudo dnf install -y jq
    else
        echo -e "${RED}${ERROR_ICON} Could not install jq. Please install it manually.${NC}"
        exit 1
    fi
    
    if ! command -v jq &> /dev/null; then
        echo -e "${RED}${ERROR_ICON} Failed to install jq. Please install it manually.${NC}"
        exit 1
    fi
fi

# Print styled messages
print_info() {
    echo -e "${BLUE}${INFO_ICON} $1${NC}"
}

print_success() {
    echo -e "${GREEN}${CHECK_ICON} $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}${WARNING_ICON} $1${NC}"
}

print_error() {
    echo -e "${RED}${ERROR_ICON} $1${NC}"
}

# Function to check command existence
check_command() {
    if command -v "$1" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to detect the OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macOS"
    elif [ -f /etc/os-release ]; then
        . /etc/os-release
        case $ID in
            ubuntu|debian|raspbian|linuxmint|pop|elementary|zorin)
                OS="Debian"
                ;;
            arch|manjaro|endeavouros)
                OS="Arch"
                ;;
            fedora|rhel|centos|rocky|almalinux)
                OS="Fedora"
                ;;
            nixos)
                OS="Nix"
                ;;
            *)
                # Additional checks for systems with Nix but not categorized yet
                if command -v nix &> /dev/null || [ -d "/nix" ] || [ -f "/etc/nix/nix.conf" ]; then
                    # Determine if it's NixOS or just a system with Nix installed
                    if grep -q "nixos" /etc/os-release 2>/dev/null; then
                        OS="Nix"
                    else
                        # This is a non-NixOS system with Nix installed
                        # Prioritize the native OS package manager
                        if command -v apt-get &> /dev/null; then
                            OS="Debian"
                        elif command -v pacman &> /dev/null; then
                            OS="Arch"
                        elif command -v dnf &> /dev/null; then
                            OS="Fedora"
                        else
                            # Only use Nix as last resort
                            OS="Nix"
                        fi
                    fi
                else
                    OS="Unknown"
                fi
                ;;
        esac
    elif command -v nix &> /dev/null || [ -d "/nix" ] || [ -f "/etc/nix/nix.conf" ]; then
        # For systems with Nix installed but no OS release info
        # Determine if it's NixOS or just a system with Nix installed
        if command -v nixos-version &> /dev/null; then
            OS="Nix"
        else
            # This is a non-NixOS system with Nix installed
            # Prioritize the native OS package manager
            if command -v apt-get &> /dev/null; then
                OS="Debian"
            elif command -v pacman &> /dev/null; then
                OS="Arch"
            elif command -v dnf &> /dev/null; then
                OS="Fedora"
            else
                # Only use Nix as last resort
                OS="Nix"
            fi
        fi
    else
        OS="Unknown"
    fi
    echo "$OS"
}

# Function to install Homebrew on macOS
install_homebrew() {
    if ! check_command "brew"; then
        print_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [ $? -eq 0 ]; then
            print_success "Homebrew installed successfully."
            # Add Homebrew to PATH for the current session
            if [[ $(uname -m) == "arm64" ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            else
                eval "$(/usr/local/bin/brew shellenv)"
            fi
        else
            print_error "Failed to install Homebrew. Please install it manually."
            exit 1
        fi
    else
        print_success "Homebrew is already installed."
    fi
}

# Function to read JSON values from the dependencies file
get_json_value() {
    local json_path="$1"
    jq -r "$json_path" "$DEPS_FILE"
}

# Function to install dependencies on macOS
install_macos_deps() {
    print_info "Installing macOS dependencies with Homebrew..."
    
    # Install Homebrew if not present
    install_homebrew
    
    # Update Homebrew
    brew update
    
    # Get packages from JSON file
    local packages=$(get_json_value '.systems.macOS.packages[]')
    
    # Install dependencies
    print_info "Installing packages: $packages"
    brew install $packages
    
    # Check Docker Desktop
    if ! check_command "docker"; then
        print_warning "Docker not found."
        local docker_instructions=$(get_json_value '.systems.macOS.docker.instructions')
        print_info "$docker_instructions"
    fi
    
    print_success "macOS dependencies installed."
}

# Function to install dependencies on Debian/Ubuntu-based systems
install_debian_deps() {
    print_info "Installing dependencies for Ubuntu/Debian..."
    
    # Update package lists
    sudo apt update
    
    # Get packages from JSON file
    local packages=$(get_json_value '.systems.Debian.packages[]')
    
    # Install dependencies
    print_info "Installing packages: $packages"
    sudo apt install -y $packages
    
    # Install Docker if not present
    if ! check_command "docker"; then
        print_info "Installing Docker..."
        
        # Get Docker packages from JSON file
        local docker_packages=$(get_json_value '.systems.Debian.docker.packages[]')
        sudo apt install -y $docker_packages
        
        # Execute Docker setup commands
        for cmd in $(get_json_value '.systems.Debian.docker.commands[]'); do
            eval "$cmd"
        done
        
        print_warning "Log out and back in for Docker group changes to take effect."
    fi
    
    print_success "Debian/Ubuntu dependencies installed."
}

# Function to install dependencies on Arch Linux-based systems
install_arch_deps() {
    print_info "Installing dependencies for Arch Linux..."
    
    # Update package lists
    sudo pacman -Syu
    
    # Get packages from JSON file
    local packages=$(get_json_value '.systems.Arch.packages[]')
    
    # Install dependencies
    print_info "Installing packages: $packages"
    sudo pacman -S --needed $packages
    
    # Install Docker if not present
    if ! check_command "docker"; then
        print_info "Installing Docker..."
        
        # Get Docker packages from JSON file
        local docker_packages=$(get_json_value '.systems.Arch.docker.packages[]')
        sudo pacman -S --needed $docker_packages
        
        # Execute Docker setup commands
        for cmd in $(get_json_value '.systems.Arch.docker.commands[]'); do
            eval "$cmd"
        done
        
        print_warning "Log out and back in for Docker group changes to take effect."
    fi
    
    print_success "Arch Linux dependencies installed."
}

# Function to install dependencies on Fedora/RHEL-based systems
install_fedora_deps() {
    print_info "Installing dependencies for Fedora/RHEL..."
    
    # Update package lists
    sudo dnf check-update
    
    # Get packages from JSON file
    local packages=$(get_json_value '.systems.Fedora.packages[]')
    
    # Install dependencies
    print_info "Installing packages: $packages"
    sudo dnf install -y $packages
    
    # Install Docker if not present
    if ! check_command "docker"; then
        print_info "Installing Docker..."
        
        # Get Docker packages from JSON file
        local docker_packages=$(get_json_value '.systems.Fedora.docker.packages[]')
        sudo dnf install -y $docker_packages
        
        # Execute Docker setup commands
        for cmd in $(get_json_value '.systems.Fedora.docker.commands[]'); do
            eval "$cmd"
        done
        
        print_warning "Log out and back in for Docker group changes to take effect."
    fi
    
    print_success "Fedora/RHEL dependencies installed."
}

# Function to install dependencies on NixOS or systems with Nix
install_nix_deps() {
    print_info "Installing dependencies using Nix..."
    
    # Check if this is NixOS or just a system with Nix installed
    local is_nixos=false
    if [ -f "/etc/os-release" ]; then
        . /etc/os-release
        if [ "$ID" = "nixos" ]; then
            is_nixos=true
        fi
    fi
    
    # Get packages from JSON file
    local packages=$(get_json_value '.systems.Nix.packages[]')
    
    if [ "$is_nixos" = true ]; then
        print_info "Detected NixOS system"
        
        # For NixOS, show how to add packages to configuration.nix
        print_info "To install these packages permanently, add them to your configuration.nix:"
        echo "environment.systemPackages = with pkgs; ["
        echo "$packages" | while read -r pkg; do
            echo "    $pkg"
        done
        echo "];"
        
        print_info "Then run: sudo nixos-rebuild switch"
        
        # Offer to create a temporary shell with all packages
        print_info "Creating a temporary shell with required packages..."
        local package_list=$(echo "$packages" | tr '\n' ' ')
        nix-shell -p $package_list --run "echo 'Nix shell with required packages is ready. You can run KubuntuCustoms commands here. Press Ctrl+D to exit.'; bash"
    else
        # For systems with Nix but not NixOS, provide guidance
        print_info "Detected non-NixOS system with Nix package manager"
        print_info "For non-NixOS systems, we recommend the following approaches:"
        
        echo "1. Create a development shell with all dependencies:"
        echo "   $ nix-shell -p $(echo "$packages" | tr '\n' ' ')"
        echo ""
        echo "2. Create a shell.nix file with the following content:"
        echo "   { pkgs ? import <nixpkgs> {} }:"
        echo "   pkgs.mkShell {"
        echo "     buildInputs = with pkgs; ["
        echo "$packages" | while read -r pkg; do
            echo "       $pkg"
        done
        echo "     ];"
        echo "   }"
        echo ""
        echo "   Then run: $ nix-shell"
        
        print_info "Would you like to create a temporary shell with the required packages now? (y/N)"
        read -r create_shell
        if [[ "$create_shell" =~ ^[Yy]$ ]]; then
            local package_list=$(echo "$packages" | tr '\n' ' ')
            nix-shell -p $package_list --run "echo 'Nix shell with required packages is ready. You can run KubuntuCustoms commands here. Press Ctrl+D to exit.'; bash"
        fi
        
        # Create shell.nix file for future use
        print_info "Creating shell.nix in the project directory for future use..."
        cat > "$SCRIPT_DIR/shell.nix" << EOF
# KubuntuCustoms development environment
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
$(echo "$packages" | while read -r pkg; do echo "    $pkg"; done)
  ];
  
  shellHook = ''
    echo "KubuntuCustoms development environment loaded"
    echo "Run 'exit' or press Ctrl+D to exit the shell"
  '';
}
EOF
        print_success "Created shell.nix. Use 'nix-shell' in the project directory to start a development environment."
    fi
    
    # Handle Docker differently on NixOS
    if ! check_command "docker"; then
        print_info "Docker setup on NixOS/Nix:"
        
        if [ "$is_nixos" = true ]; then
            print_info "For NixOS, add this to your configuration.nix:"
            get_json_value '.systems.Nix.docker.nixConfig[]' | while read -r line; do
                echo "$line"
            done
            print_info "Then run: sudo nixos-rebuild switch"
        else
            # For non-NixOS systems with Nix
            print_info "For Docker with Nix on non-NixOS systems, use one of these approaches:"
            echo "1. Install Docker using your host system's package manager"
            echo "2. Use Docker in a nix-shell: nix-shell -p docker"
            echo "3. For NixOS-like declarative Docker setup, consider using home-manager"
            
            # If systemctl exists, provide standard setup instructions
            if command -v systemctl &> /dev/null; then
                print_info "To enable and start Docker service:"
                for cmd in $(get_json_value '.systems.Nix.docker.commands[]'); do
                    echo "    $cmd"
                done
                print_warning "Log out and back in for Docker group changes to take effect."
            fi
        fi
    fi
    
    print_success "Nix dependencies setup completed."
}

# Function to install Python packages for assistant tool
install_python_deps() {
    print_info "Installing Python dependencies for assistant tool..."
    
    # First try to use requirements.txt if it exists
    if [ -f "$SCRIPT_DIR/assistant/requirments.txt" ]; then
        if check_command "pip3"; then
            pip3 install -r "$SCRIPT_DIR/assistant/requirments.txt"
        elif check_command "pip"; then
            pip install -r "$SCRIPT_DIR/assistant/requirments.txt"
        else
            print_error "Could not find pip or pip3. Please install manually."
            return 1
        fi
        print_success "Python dependencies installed from requirements.txt"
        return 0
    fi
    
    # If requirements.txt doesn't exist, use the packages from DEPS.json
    print_info "Using dependencies from DEPS.json"
    
    # Get Python packages for assistant tool
    local packages=$(get_json_value '.pythonDeps.assistant[]')
    
    # Install packages
    if [ -n "$packages" ]; then
        if check_command "pip3"; then
            print_info "Installing Python packages: $packages"
            for pkg in $packages; do
                pip3 install "$pkg"
            done
        elif check_command "pip"; then
            print_info "Installing Python packages: $packages"
            for pkg in $packages; do
                pip install "$pkg"
            done
        else
            print_error "Could not find pip or pip3. Please install manually."
            return 1
        fi
        print_success "Python dependencies installed."
    else
        print_warning "No Python dependencies found in DEPS.json"
    fi
}

# Main installation function
main() {
    echo "==========================================================="
    echo "         KubuntuCustoms Dependencies Installer             "
    echo "==========================================================="
    echo ""
    
    # Check for root/sudo access
    if [ "$EUID" -eq 0 ] && [ "$OS" != "macOS" ]; then
        print_warning "Running as root. It's recommended to run as a normal user with sudo."
        read -p "Continue anyway? (y/N): " continue_as_root
        if [[ ! "$continue_as_root" =~ ^[Yy]$ ]]; then
            print_info "Please run this script as a normal user with sudo access."
            exit 1
        fi
    fi
    
    # Detect the operating system
    OS=$(detect_os)
    print_info "Detected operating system: $OS"
    
    # Install based on the detected OS
    case "$OS" in
        "macOS")
            install_macos_deps
            ;;
        "Debian")
            install_debian_deps
            ;;
        "Arch")
            install_arch_deps
            ;;
        "Fedora")
            install_fedora_deps
            ;;
        "Nix")
            install_nix_deps
            ;;
        *)
            print_error "Unsupported operating system: $OS"
            print_info "Please install dependencies manually by referring to the DEPENDENCIES.md file."
            exit 1
            ;;
    esac
    
    # Install Python dependencies for the assistant tool
    install_python_deps
    
    echo ""
    print_success "Installation complete!"
    print_info "You may need to log out and back in for some changes to take effect."
    
    if [ "$OS" != "macOS" ]; then
        print_info "To test Docker access without logging out, run:"
        echo "    newgrp docker"
    fi
    
    echo ""
    print_info "For more details about the dependencies, see DEPENDENCIES.md"
}

# Run the main function
main

exit 0
