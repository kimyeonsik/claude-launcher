#!/usr/bin/env zsh
# Claude Launcher - Install script

set -e

INSTALL_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config/claude-launcher"
LANG_DIR="$CONFIG_DIR/lang"
PROJECTS_FILE="$CONFIG_DIR/projects.json"
ZSHRC="$HOME/.zshrc"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ── Output helpers ───────────────────────────────────────────────────────────
info()    { printf "\033[0;34m  →\033[0m %s\n" "$1"; }
ok()      { printf "\033[0;32m  ✓\033[0m %s\n" "$1"; }
warn()    { printf "\033[0;33m  !\033[0m %s\n" "$1"; }
fail()    { printf "\033[0;31m  ✗\033[0m %s\n" "$1" >&2; exit 1; }

echo ""
echo "  Claude Launcher Install"
echo "  ─────────────────────────────────────"

# ── 1. Check dependencies ───────────────────────────────────────────────────
info "Checking dependencies..."

# zsh
[[ -n "$ZSH_VERSION" ]] || fail "Must run in zsh. (zsh install.sh)"

# python3
PYTHON3=$(command -v python3 2>/dev/null)
[[ -z "$PYTHON3" && -x "/opt/homebrew/bin/python3" ]] && PYTHON3="/opt/homebrew/bin/python3"
[[ -z "$PYTHON3" && -x "/usr/bin/python3" ]]          && PYTHON3="/usr/bin/python3"
[[ -z "$PYTHON3" ]] && fail "python3 not found."
ok "python3: $PYTHON3"

# fzf (auto-install via brew if missing)
if ! command -v fzf &>/dev/null && [[ ! -x "/opt/homebrew/bin/fzf" ]]; then
    if command -v brew &>/dev/null; then
        info "Installing fzf..."
        brew install fzf
        ok "fzf installed"
    else
        fail "fzf not found. Install with: brew install fzf"
    fi
else
    ok "fzf: $(command -v fzf 2>/dev/null || echo /opt/homebrew/bin/fzf)"
fi

# ── 2. Prepare ~/.local/bin ─────────────────────────────────────────────────
info "Preparing install directory..."
mkdir -p "$INSTALL_DIR"

# Add to PATH if needed
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    if ! grep -qF 'local/bin' "$ZSHRC" 2>/dev/null; then
        printf '\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$ZSHRC"
        warn "Added ~/.local/bin to PATH (~/.zshrc)"
    fi
fi
ok "~/.local/bin ready"

# ── 3. Install script ───────────────────────────────────────────────────────
info "Installing claude-launcher..."
cp "$SCRIPT_DIR/claude-launcher" "$INSTALL_DIR/claude-launcher"
chmod +x "$INSTALL_DIR/claude-launcher"
ok "~/.local/bin/claude-launcher installed"

# ── 4. Install language files ────────────────────────────────────────────────
info "Installing language files..."
mkdir -p "$LANG_DIR"
if [[ -d "$SCRIPT_DIR/lang" ]]; then
    cp "$SCRIPT_DIR/lang/"*.sh "$LANG_DIR/"
    ok "Language files installed ($(ls "$SCRIPT_DIR/lang/"*.sh | wc -l | tr -d ' ') languages)"
else
    warn "Language directory not found, using defaults"
fi

# ── 5. Init config directory ────────────────────────────────────────────────
info "Initializing config..."
mkdir -p "$CONFIG_DIR"
if [[ ! -f "$PROJECTS_FILE" ]]; then
    printf "[]" > "$PROJECTS_FILE"
    ok "~/.config/claude-launcher/projects.json created"
else
    ok "~/.config/claude-launcher/projects.json preserved (existing data kept)"
fi

# ── 6. Register in .zshrc ───────────────────────────────────────────────────
info "Registering in .zshrc..."
LAUNCHER_LINE='[[ -f "$HOME/.local/bin/claude-launcher" ]] && source "$HOME/.local/bin/claude-launcher"'

if grep -qF 'claude-launcher' "$ZSHRC" 2>/dev/null; then
    warn "claude-launcher already registered in ~/.zshrc"
else
    cat >> "$ZSHRC" << 'ZSHRC_EOF'

# Claude Launcher - show project selector on new terminal
# Disable: CLAUDE_LAUNCHER_SKIP=1 zsh
[[ -f "$HOME/.local/bin/claude-launcher" ]] && source "$HOME/.local/bin/claude-launcher"
ZSHRC_EOF
    ok "Registered in ~/.zshrc"
fi

# ── Done ─────────────────────────────────────────────────────────────────────
echo ""
echo "  ─────────────────────────────────────"
echo "  Install complete! 🚀"
echo ""
echo "  Open a new terminal or run:"
echo "    source ~/.zshrc"
echo ""
echo "  Open terminal without launcher:"
echo "    CLAUDE_LAUNCHER_SKIP=1 zsh"
echo ""
echo "  Set language (default: auto-detect from \$LANG):"
echo "    export CLAUDE_LAUNCHER_LANG=ko  # Korean"
echo "    export CLAUDE_LAUNCHER_LANG=en  # English"
echo ""
