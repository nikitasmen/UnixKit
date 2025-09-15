# lame

A script for quick access to multiple AI models via Ollama Docker container.

## Features
- Support for multiple AI models (Llama3, Mistral, CodeLlama, Gemma, etc.)
- Simple command-line usage
- Model validation and helpful error messages
- Container status checking
- Built-in help and model listing

## Usage
```bash
./lame [MODEL_NAME] [OPTIONS]
```

### Options
- `-h`, `--help`: Show help message
- `-l`, `--list`: List all available models
- `-s`, `--status`: Show container status

### Available Models
- **Llama3 variants**: `llama3`, `llama3.1`, `llama3.1:8b`, `llama3.1:70b`
- **CodeLlama variants**: `codellama`, `codellama:7b`, `codellama:13b`, `codellama:34b`
- **Mistral variants**: `mistral`, `mistral:7b`, `mistral:13b`
- **Gemma variants**: `gemma`, `gemma:2b`, `gemma:7b`
- **Other models**: `neural-chat`, `starling-lm`, `orca-mini`, `phi`, `tinyllama`

### Examples
```bash
./lame                    # Run default model (llama3)
./lame mistral           # Run mistral model
./lame codellama:7b      # Run specific codellama variant
./lame --list            # List all available models
./lame --status          # Check container status
./lame --help            # Show help
```

## Requirements
- Docker installed and running
- Internet connection (for downloading models)

## License
This script is part of the KubuntuCustoms toolkit. 