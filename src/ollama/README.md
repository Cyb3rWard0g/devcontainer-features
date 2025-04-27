# Ollama Dev Container Feature

This feature installs [Ollama](https://ollama.ai/), a tool that lets you run open-source large language models (LLMs) locally.

## Example Usage

```json
"features": {
    "ghcr.io/cyb3rward0g/devcontainer-features/ollama:1": {
        "models": "phi3,gemma:2b",
        "withGPU": false
    }
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| models | Comma-separated list of models to pre-pull (e.g. "phi3,gemma:2b") | string | "" |
| withGPU | Install CUDA 12 libs and enable GPU acceleration (self-hosted runners only) | boolean | false |

## Using Ollama in your Dev Container

Once installed, you can interact with Ollama using its CLI:

```bash
# List models
ollama list

# Run inference with a model
ollama run phi3 "Explain quantum computing in simple terms"
```

## OS Support

This feature is tested and supported on Ubuntu Linux. GPU acceleration (CUDA) only works on systems with NVIDIA GPUs.

## Notes on GPU Support in GitHub Codespaces

Currently, GitHub Codespaces only provides CPU-based virtual machines, so the `withGPU` option won't have any effect in Codespaces environments. However, the option is kept for compatibility with self-hosted runners that have NVIDIA GPUs.

If you're using this feature in a self-hosted environment with GPU support, enabling the `withGPU` option will:

1. Install CUDA 12.3 toolkit
2. Set the `OLLAMA_ORCHESTRATOR=cuda` environment variable
3. Configure Ollama to use GPU acceleration

## License

This project is licensed under the MIT License.