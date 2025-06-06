#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'ollama' feature with no options.

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "ollama installed" bash -c "ollama -v | grep 'ollama version is'"

# Report result
reportResults