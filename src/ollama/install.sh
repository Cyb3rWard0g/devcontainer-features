#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# Helpers
###############################################################################
log() { echo "▶ $*"; }

# Usage: ensure_packages curl jq git
ensure_packages() {
  local missing=()
  for pkg in "$@"; do
    dpkg -s "$pkg" >/dev/null 2>&1 || missing+=("$pkg")
  done
  [[ ${#missing[@]} -eq 0 ]] && return

  # Run apt-get update only once per script run
  if [[ -z "${_APT_UPDATED:-}" ]]; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y
    _APT_UPDATED=1
  fi

  apt-get -y install --no-install-recommends "${missing[@]}"
}

###############################################################################
# Install Ollama (always CPU; GPU optional)
###############################################################################
ensure_packages ca-certificates curl gnupg

log "Installing Ollama ..."
curl -fsSL https://ollama.ai/install.sh | bash

###############################################################################
# Optional CUDA/NVIDIA support
###############################################################################
if [[ "${WITHGPU:-false}" == "true" ]]; then
  if command -v nvidia-smi >/dev/null 2>&1; then
    log "Enabling CUDA support (host GPU detected)"

    # Add NVIDIA container-toolkit repo (signed)
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey \
        | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit.gpg
    curl -fsSL https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list \
        | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit.gpg] https://#' \
        | tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

    ensure_packages nvidia-container-toolkit cuda-toolkit-12-3
    echo 'export OLLAMA_ORCHESTRATOR=cuda' >> /etc/profile.d/ollama.sh
  else
    log "WITHGPU=true requested but no NVIDIA runtime present — skipping GPU setup"
  fi
fi

###############################################################################
# Pre-pull models (if any)
###############################################################################
if [[ -n "${MODELS:-}" && "${MODELS,,}" != "none" ]]; then
  log "Pre-pulling models: ${MODELS}"
  # Launch Ollama in the background for pulls
  ollama serve &
  OLLAMA_PID=$!
  sleep 3

  # Split comma-separated list and pull each
  IFS=',' read -ra _MODELS <<< "${MODELS}"
  for m in "${_MODELS[@]}"; do
    m="$(echo "$m" | xargs)"    # trim
    [[ -n "$m" ]] && log "Pulling $m" && ollama pull "$m"
  done

  # Clean up
  kill "$OLLAMA_PID" || true
  wait "$OLLAMA_PID" 2>/dev/null || true
else
  log "No models specified for pre-pull"
fi

###############################################################################
# Permissions for non-root user
###############################################################################
if [[ -n "${_REMOTE_USER:-}" && "${_REMOTE_USER}" != "root" ]]; then
  log "Setting ownership for ${_REMOTE_USER}"
  chown -R "${_REMOTE_USER}:${_REMOTE_USER}" /usr/local/share/ollama 2>/dev/null || true
fi

log "✅ Ollama Feature installation complete"