# cleanBranches

A script to manage and clean up your Git branches, automating the process of deleting local branches that have already been merged into the main branch.

## Features
- List all local branches
- Delete local branches that have been merged into the main branch
- Option to force delete branches
- Interactive mode for selective branch deletion

## Usage
```bash
./cleanBranches
```

## Options
- `-f`, `--force`: Force delete branches without confirmation
- `-i`, `--interactive`: Enable interactive mode for selective branch deletion

## Example
To run the script in interactive mode:
```bash
./cleanBranches -i
```

## License
This script is part of the KubuntuCustoms toolkit.
