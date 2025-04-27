#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'ollama' feature with no options.

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "ollama installed" bash -c "command -v ollama"
check "ollama client installed" bash -c "ollama --version"

# Report result
reportResults