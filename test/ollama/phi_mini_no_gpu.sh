#!/bin/bash

# This test file will be executed against a devcontainer.json that
# includes the 'ollama' feature with specific options for the scenario.
# In this case: models="phi:mini", withGPU=false

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Check for scenario-specific configuration
check "2.7b model available" bash -c "ollama list | grep 'phi:2.7b'"

# Report result
reportResults