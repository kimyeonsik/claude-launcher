#!/usr/bin/env zsh
# Claude Launcher - Uninstall script

INSTALL_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config/claude-launcher"
ZSHRC="$HOME/.zshrc"

# ── Output helpers ───────────────────────────────────────────────────────────
ok()   { printf "\033[0;32m  ✓\033[0m %s\n" "$1"; }
info() { printf "\033[0;34m  →\033[0m %s\n" "$1"; }

echo ""
echo "  Claude Launcher Uninstall"
echo "  ─────────────────────────────────────"

# ── 1. Remove script ────────────────────────────────────────────────────────
info "Removing script..."
if [[ -f "$INSTALL_DIR/claude-launcher" ]]; then
    rm -f "$INSTALL_DIR/claude-launcher"
    ok "~/.local/bin/claude-launcher removed"
else
    ok "~/.local/bin/claude-launcher not found (already removed)"
fi

# ── 2. Clean .zshrc ─────────────────────────────────────────────────────────
info "Cleaning .zshrc..."
if grep -q 'claude-launcher' "$ZSHRC" 2>/dev/null; then
    sed -i '' '/[Cc]laude [Ll]auncher/d' "$ZSHRC"
    sed -i '' '/claude-launcher/d'       "$ZSHRC"
    ok "claude-launcher removed from ~/.zshrc"
else
    ok "claude-launcher not found in ~/.zshrc"
fi

# ── 3. Handle config and data ───────────────────────────────────────────────
echo ""
printf "  Delete project list (~/.config/claude-launcher/) too? [y/N] "
read -r confirm < /dev/tty

if [[ "$confirm" =~ ^[Yy]$ ]]; then
    rm -rf "$CONFIG_DIR"
    ok "~/.config/claude-launcher/ removed"
else
    ok "~/.config/claude-launcher/ preserved (data kept for reinstall)"
fi

# ── Done ─────────────────────────────────────────────────────────────────────
echo ""
echo "  ─────────────────────────────────────"
echo "  Uninstall complete."
echo ""
