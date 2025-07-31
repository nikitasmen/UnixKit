# clip

A cross-platform Bash script to copy file contents to your clipboard, with flexible line selection and smart file search.

## Features
- Copy file contents to clipboard
- Specify number of lines to copy
- Smart file search and interactive selection
- Works on macOS, Linux X11, and Wayland

## Usage
```bash
./clip <file> [-p path] [-l lines] [-h]
```

### Options
- `-p`: Specify the path to search for the file
- `-l`: Number of lines to copy (default: entire file)
- `-h`: Display help message

### Example
```bash
./clip my_file.txt -l 5
```

## Installation
You can install clip using the ScriStaller script:
```bash
./scriptInstaller/ScriStaller ./clip/clip clip
```

## License
This script is part of the KubuntuCustoms toolkit.

