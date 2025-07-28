#!/usr/bin/env bash

# =============================================================================
# Dependencies Manager for KubuntuCustoms
# This script helps manage the DEPS.json file
# =============================================================================

# Set colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPS_FILE="$SCRIPT_DIR/DEPS.json"

# Print usage
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Manage dependencies for KubuntuCustoms"
    echo ""
    echo "Options:"
    echo "  list <system>        List dependencies for a specific system (Debian, Arch, Fedora, macOS)"
    echo "  add <system> <pkg>   Add a package to a system's dependencies"
    echo "  remove <system> <pkg> Remove a package from a system's dependencies"
    echo "  addpy <pkg>          Add a Python package to the assistant tool dependencies"
    echo "  rempy <pkg>          Remove a Python package from the assistant tool dependencies"
    echo "  export               Export dependencies to individual files for each system"
    echo "  help                 Display this help message"
    echo ""
    echo "Examples:"
    echo "  $0 list Debian       # List all Debian dependencies"
    echo "  $0 add Arch fzf      # Add fzf to Arch dependencies"
    echo "  $0 addpy pandas      # Add pandas to Python dependencies"
    exit 1
}

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo -e "${RED}Error: jq is required for parsing JSON but not installed.${NC}"
    echo "Please install jq first."
    exit 1
fi

# Check if the dependencies file exists
if [ ! -f "$DEPS_FILE" ]; then
    echo -e "${RED}Error: Dependencies file not found: $DEPS_FILE${NC}"
    exit 1
fi

# Function to list dependencies for a specific system
list_deps() {
    local system="$1"
    
    if [ -z "$system" ]; then
        echo "Available systems:"
        jq -r '.systems | keys[]' "$DEPS_FILE"
        echo ""
        echo "To list dependencies for a system, use: $0 list <system>"
        return
    fi
    
    # Check if the system exists in the JSON
    if ! jq -e ".systems.$system" "$DEPS_FILE" > /dev/null; then
        echo -e "${RED}Error: System '$system' not found in dependencies file.${NC}"
        echo "Available systems:"
        jq -r '.systems | keys[]' "$DEPS_FILE"
        return 1
    fi
    
    echo -e "${BLUE}Dependencies for $system:${NC}"
    jq -r ".systems.$system.packages[]" "$DEPS_FILE" | sort | awk '{print "  - " $0}'
    
    if jq -e ".systems.$system.docker.packages" "$DEPS_FILE" > /dev/null; then
        echo -e "\n${BLUE}Docker dependencies for $system:${NC}"
        jq -r ".systems.$system.docker.packages[]" "$DEPS_FILE" | sort | awk '{print "  - " $0}'
    fi
}

# Function to add a package to a system's dependencies
add_package() {
    local system="$1"
    local package="$2"
    
    if [ -z "$system" ] || [ -z "$package" ]; then
        echo -e "${RED}Error: Both system and package name are required.${NC}"
        echo "Usage: $0 add <system> <pkg>"
        return 1
    fi
    
    # Check if the system exists in the JSON
    if ! jq -e ".systems.$system" "$DEPS_FILE" > /dev/null; then
        echo -e "${RED}Error: System '$system' not found in dependencies file.${NC}"
        echo "Available systems:"
        jq -r '.systems | keys[]' "$DEPS_FILE"
        return 1
    fi
    
    # Check if the package already exists
    if jq -e ".systems.$system.packages | index(\"$package\")" "$DEPS_FILE" > /dev/null; then
        echo -e "${YELLOW}Package '$package' already exists in $system dependencies.${NC}"
        return 0
    fi
    
    # Add the package
    jq ".systems.$system.packages += [\"$package\"]" "$DEPS_FILE" > "$DEPS_FILE.tmp"
    mv "$DEPS_FILE.tmp" "$DEPS_FILE"
    
    echo -e "${GREEN}Added package '$package' to $system dependencies.${NC}"
}

# Function to remove a package from a system's dependencies
remove_package() {
    local system="$1"
    local package="$2"
    
    if [ -z "$system" ] || [ -z "$package" ]; then
        echo -e "${RED}Error: Both system and package name are required.${NC}"
        echo "Usage: $0 remove <system> <pkg>"
        return 1
    fi
    
    # Check if the system exists in the JSON
    if ! jq -e ".systems.$system" "$DEPS_FILE" > /dev/null; then
        echo -e "${RED}Error: System '$system' not found in dependencies file.${NC}"
        echo "Available systems:"
        jq -r '.systems | keys[]' "$DEPS_FILE"
        return 1
    fi
    
    # Remove the package
    jq ".systems.$system.packages -= [\"$package\"]" "$DEPS_FILE" > "$DEPS_FILE.tmp"
    mv "$DEPS_FILE.tmp" "$DEPS_FILE"
    
    echo -e "${GREEN}Removed package '$package' from $system dependencies.${NC}"
}

# Function to add a Python package to the assistant tool dependencies
add_python_package() {
    local package="$1"
    
    if [ -z "$package" ]; then
        echo -e "${RED}Error: Package name is required.${NC}"
        echo "Usage: $0 addpy <pkg>"
        return 1
    fi
    
    # Check if the package already exists
    if jq -e ".pythonDeps.assistant | index(\"$package\")" "$DEPS_FILE" > /dev/null; then
        echo -e "${YELLOW}Package '$package' already exists in Python dependencies.${NC}"
        return 0
    fi
    
    # Add the package
    jq ".pythonDeps.assistant += [\"$package\"]" "$DEPS_FILE" > "$DEPS_FILE.tmp"
    mv "$DEPS_FILE.tmp" "$DEPS_FILE"
    
    echo -e "${GREEN}Added package '$package' to Python dependencies.${NC}"
}

# Function to remove a Python package from the assistant tool dependencies
remove_python_package() {
    local package="$1"
    
    if [ -z "$package" ]; then
        echo -e "${RED}Error: Package name is required.${NC}"
        echo "Usage: $0 rempy <pkg>"
        return 1
    fi
    
    # Remove the package
    jq ".pythonDeps.assistant -= [\"$package\"]" "$DEPS_FILE" > "$DEPS_FILE.tmp"
    mv "$DEPS_FILE.tmp" "$DEPS_FILE"
    
    echo -e "${GREEN}Removed package '$package' from Python dependencies.${NC}"
}

# Function to export dependencies to individual files for each system
export_deps() {
    local export_dir="$SCRIPT_DIR/deps"
    
    # Create the export directory if it doesn't exist
    mkdir -p "$export_dir"
    
    # Export dependencies for each system
    for system in $(jq -r '.systems | keys[]' "$DEPS_FILE"); do
        local file="$export_dir/$system.deps"
        jq -r ".systems.$system.packages[]" "$DEPS_FILE" | sort > "$file"
        echo -e "${GREEN}Exported $system dependencies to $file${NC}"
        
        # Export Docker dependencies if they exist
        if jq -e ".systems.$system.docker.packages" "$DEPS_FILE" > /dev/null; then
            local docker_file="$export_dir/$system.docker.deps"
            jq -r ".systems.$system.docker.packages[]" "$DEPS_FILE" | sort > "$docker_file"
            echo -e "${GREEN}Exported $system Docker dependencies to $docker_file${NC}"
        fi
    done
    
    # Export Python dependencies
    local python_file="$export_dir/python.deps"
    jq -r ".pythonDeps.assistant[]" "$DEPS_FILE" | sort > "$python_file"
    echo -e "${GREEN}Exported Python dependencies to $python_file${NC}"
    
    echo -e "${GREEN}All dependencies exported to $export_dir${NC}"
}

# Main function
main() {
    local command="$1"
    shift
    
    case "$command" in
        list)
            list_deps "$1"
            ;;
        add)
            add_package "$1" "$2"
            ;;
        remove)
            remove_package "$1" "$2"
            ;;
        addpy)
            add_python_package "$1"
            ;;
        rempy)
            remove_python_package "$1"
            ;;
        export)
            export_deps
            ;;
        help|--help|-h)
            usage
            ;;
        *)
            usage
            ;;
    esac
}

# Run the main function
main "$@"
