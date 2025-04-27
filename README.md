# Dev Container Features

This repository contains a collection of Dev Container Features for use with [Visual Studio Code Dev Containers](https://code.visualstudio.com/docs/remote/containers) or [GitHub Codespaces](https://github.com/features/codespaces).

## Features

| Feature | Description |
| --- | --- |
| [ollama](./src/ollama/README.md) | Installs the Ollama runtime for local LLM inference with optional GPU acceleration and model pre-loading. |

## Usage

To use these features in your devcontainer, add them to your `devcontainer.json` file:

```jsonc
"features": {
    "ghcr.io/cyb3rward0g/devcontainer-features/ollama:1": {
        "models": "phi3,gemma:2b",
        "withGPU": false
    }
}
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.