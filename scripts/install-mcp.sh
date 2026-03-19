#!/bin/bash
# Install script for Neovim MCP and VectorCode dependencies

set -e

echo "Installing MCP and VectorCode dependencies..."

# Install uv if not present
if ! command -v uv &> /dev/null; then
    echo "Installing uv (Python package manager)..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
fi

# Install MCP Hub (for MCP server management)
echo "Installing MCP Hub..."
sudo npm install -g mcp-hub@latest

# Install VectorCode with sentence-transformers
echo "Installing VectorCode (this may take a bit)..."
uv tool install "vectorcode[sentence-transformers]"

echo "Done! Restart Neovim and run :Lazy to install the plugins."
