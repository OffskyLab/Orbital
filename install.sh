#!/bin/bash
set -e

REPO="https://github.com/OffskyLab/orbital.git"
INSTALL_DIR="/usr/local/bin"
BINARY_NAME="orbital"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()    { echo -e "${GREEN}==>${NC} $1"; }
warn()    { echo -e "${YELLOW}Warning:${NC} $1"; }
error()   { echo -e "${RED}Error:${NC} $1"; exit 1; }

echo ""
echo "  orbital — AI CLI environment manager"
echo ""

# macOS only
if [[ "$(uname)" != "Darwin" ]]; then
  error "orbital requires macOS."
fi

# Check Swift
if ! command -v swift &>/dev/null; then
  error "Swift not found. Install Xcode or the Xcode Command Line Tools:\n  xcode-select --install"
fi

SWIFT_VERSION=$(swift --version 2>&1 | head -1)
info "Found: $SWIFT_VERSION"

# Check install dir is writable
if [[ ! -w "$INSTALL_DIR" ]]; then
  warn "$INSTALL_DIR is not writable. Will use sudo."
  USE_SUDO=1
fi

# Clone to temp dir
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

info "Cloning orbital..."
git clone --depth 1 "$REPO" "$TMP_DIR/orbital" --quiet

# Build
info "Building (this may take a minute)..."
cd "$TMP_DIR/orbital"
swift build -c release --quiet 2>&1

BUILT_BINARY="$TMP_DIR/orbital/.build/release/$BINARY_NAME"
if [[ ! -f "$BUILT_BINARY" ]]; then
  error "Build failed — binary not found."
fi

# Install
info "Installing to $INSTALL_DIR/$BINARY_NAME..."
if [[ "$USE_SUDO" == "1" ]]; then
  sudo cp "$BUILT_BINARY" "$INSTALL_DIR/$BINARY_NAME"
  sudo chmod +x "$INSTALL_DIR/$BINARY_NAME"
else
  cp "$BUILT_BINARY" "$INSTALL_DIR/$BINARY_NAME"
  chmod +x "$INSTALL_DIR/$BINARY_NAME"
fi

# Verify
if ! command -v orbital &>/dev/null; then
  warn "orbital installed to $INSTALL_DIR but it's not in your PATH."
  warn "Add to your shell profile: export PATH=\"$INSTALL_DIR:\$PATH\""
fi

echo ""
info "orbital $(orbital --version 2>/dev/null || echo 'installed') successfully!"
echo ""
echo "  Next step — add shell integration:"
echo ""
echo "    orbital setup"
echo ""
echo "  Or manually add to ~/.zshrc:"
echo ""
echo '    eval "$(orbital init)"'
echo ""
