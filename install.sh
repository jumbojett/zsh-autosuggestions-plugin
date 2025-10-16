#!/bin/bash

#==============================================================================
# ZSH Auto-Suggestions Installation Script
#==============================================================================
# This script installs the plugin and configures your ~/.zshrc

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PLUGIN_URL="https://raw.githubusercontent.com/jumbojett/zsh-autosuggestions-plugin/main/zsh-autosuggestions.zsh"
INSTALL_DIR="${HOME}/.zsh"
PLUGIN_FILE="${INSTALL_DIR}/zsh-autosuggestions.zsh"
ZSHRC="${HOME}/.zshrc"

echo -e "${BLUE}=== ZSH Auto-Suggestions Installer ===${NC}\n"

# Check if zsh is installed
if ! command -v zsh &> /dev/null; then
    echo -e "${RED}✗ Zsh is not installed${NC}"
    echo "Please install zsh first:"
    echo "  macOS: brew install zsh"
    echo "  Ubuntu: sudo apt-get install zsh"
    exit 1
fi

echo -e "${GREEN}✓ Zsh found: $(zsh --version)${NC}"

# Create installation directory
if [ ! -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}Creating directory: $INSTALL_DIR${NC}"
    mkdir -p "$INSTALL_DIR"
fi

# Download plugin
echo -e "${YELLOW}Downloading plugin...${NC}"
if command -v curl &> /dev/null; then
    curl -fsSL "$PLUGIN_URL" -o "$PLUGIN_FILE"
elif command -v wget &> /dev/null; then
    wget -q "$PLUGIN_URL" -O "$PLUGIN_FILE"
else
    echo -e "${RED}✗ Neither curl nor wget found${NC}"
    echo "Please install curl or wget first"
    exit 1
fi

echo -e "${GREEN}✓ Plugin downloaded to: $PLUGIN_FILE${NC}"

# Check if already in .zshrc
SOURCE_LINE="source ${PLUGIN_FILE}"
if grep -Fxq "$SOURCE_LINE" "$ZSHRC" 2>/dev/null; then
    echo -e "${YELLOW}⚠ Plugin already configured in $ZSHRC${NC}"
else
    # Backup .zshrc
    if [ -f "$ZSHRC" ]; then
        echo -e "${YELLOW}Backing up $ZSHRC to ${ZSHRC}.backup${NC}"
        cp "$ZSHRC" "${ZSHRC}.backup"
    fi
    
    # Add to .zshrc
    echo -e "\n# ZSH Auto-Suggestions" >> "$ZSHRC"
    echo "$SOURCE_LINE" >> "$ZSHRC"
    echo -e "${GREEN}✓ Plugin added to $ZSHRC${NC}"
fi

# Success message
echo -e "\n${GREEN}=== Installation Complete! ===${NC}\n"
echo "To activate the plugin, run:"
echo -e "  ${BLUE}source ~/.zshrc${NC}"
echo ""
echo "Or restart your terminal."
echo ""
echo "Usage:"
echo "  • Type a command and see suggestions in gray"
echo "  • Press ↑/↓ to cycle through suggestions"
echo "  • Press → or Tab to accept"
echo ""
echo -e "${YELLOW}Enjoy your fish-style auto-suggestions! 🐟${NC}"
