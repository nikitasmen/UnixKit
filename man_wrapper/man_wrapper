#!/usr/bin/env bash

# =============================================================================
# man_wrapper.sh - Documentation viewer for KubuntuCustoms scripts
# Displays script docs, README, or man pages with beautiful Markdown rendering
# =============================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Print messages with color
print_info() { echo -e "${GREEN}ℹ  $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠  $1${NC}"; }
print_error() { echo -e "${RED}✖ $1${NC}"; }

# Show script's internal docs
show_script_docs() {
    local script_path=$1
    if grep -q '^# =' "$script_path"; then
        awk '/^# =/,/^# =====/{if (!/^# =/ && !/^# =====/) print}' "$script_path" | \
            sed 's/^# //' | less -F -X -E -R
        return 0
    fi
    return 1
}

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Display markdown file with the best available viewer
show_markdown() {
    local file=$1
    
    # Try different markdown viewers in order of preference
    if command_exists glow; then
        # Use glow with custom style if available
        glow -s dark "$file"
    elif command_exists mdcat; then
        # Use mdcat if available
        mdcat "$file"
    elif command_exists pandoc; then
        # Use pandoc to convert to terminal output
        pandoc -t plain "$file" | less -F -X -E -R
    else
        # Fallback to basic less
        less -F -X -E -R "$file"
    fi
}

# Show README file if it exists
show_readme() {
    local script_dir=$(dirname "$1")
    local readme_file=$(find "$script_dir" -maxdepth 1 -iname 'README*' | head -n 1)
    
    if [ -n "$readme_file" ] && [ -f "$readme_file" ]; then
        case "$readme_file" in
            *.md|*.markdown)
                show_markdown "$readme_file"
                ;;
            *)
                less -F -X -E -R "$readme_file"
                ;;
        esac
        return 0
    fi
    return 1
}

# Find script by name
find_script() {
    local script_name=$1
    
    # Check if it's a path to a file
    [ -f "$script_name" ] && { echo "$script_name"; return 0; }
    
    # Find in current directory or subdirectories
    local script_path=$(find . -type f \( -name "${script_name}" -o -name "${script_name}.sh" \) -print -quit 2>/dev/null)
    [ -n "$script_path" ] && echo "$script_path" && return 0
    
    return 1
}

# Show usage
show_usage() {
    echo "Usage: $(basename "$0") [OPTIONS] SCRIPT_NAME"
    echo "\nDisplay documentation for KubuntuCustoms scripts"
    echo "\nOptions:"
    echo "  -h, --help     Show this help"
    echo "  -v, --version  Show version"
}

# Main function
main() {
    [ $# -eq 0 ] && { show_usage; exit 1; }
    
    case "$1" in
        -h|--help) show_usage; exit 0 ;;
        -v|--version) echo "man_wrapper.sh v1.0.0"; exit 0 ;;
    esac
    
    local script_name=$1
    local script_path
    
    if ! script_path=$(find_script "$script_name"); then
        print_error "Script '$script_name' not found"
        exit 1
    fi
    
    print_info "Documentation for $(basename "$script_path"):"
    
    # Try different documentation methods
    if ! show_script_docs "$script_path" && \
       ! show_readme "$script_path"; then
        print_warning "No local documentation found"
        command man "$(basename "$script_path")" 2>/dev/null || \
            print_error "No man page found for $(basename "$script_path")"
    fi
}

# Run main function
main "$@"
exit $?
