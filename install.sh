#!/usr/bin/env zsh
# Claude Launcher - Install script

# No set -e: we handle errors explicitly via fail()

INSTALL_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config/claude-launcher"
CONFIG_FILE="$CONFIG_DIR/config"
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

# ── 5. Select language ──────────────────────────────────────────────────────
info "Selecting language..."

# Scan available languages from lang/ directory
typeset -a _lang_codes _lang_labels
_lang_idx=0
_code=""
_label=""
for f in "$SCRIPT_DIR/lang/"*.sh(N); do
    _code="${f:t:r}"  # filename without extension
    _label=$(grep '^_CL_LANG_LABEL=' "$f" 2>/dev/null | head -1 | cut -d'"' -f2)
    [[ -z "$_label" ]] && _label="$_code"
    _lang_codes+=("$_code")
    _lang_labels+=("$_label")
    (( _lang_idx++ ))
done

SELECTED_LANG="auto"

if (( _lang_idx >= 1 )); then
    echo ""
    echo "  Available languages:"
    printf "  * 1) Auto-detect (from \$LANG)\n"
    for (( i=1; i<=_lang_idx; i++ )); do
        printf "    %d) %s\n" "$(( i + 1 ))" "${_lang_labels[$i]}"
    done
    echo ""
    printf "  Select language [1]: "
    _choice=""
    { read -r _choice < /dev/tty } 2>/dev/null || true

    # Default to 1 (auto-detect)
    [[ -z "$_choice" ]] && _choice=1

    if [[ "$_choice" == "1" ]]; then
        SELECTED_LANG="auto"
    elif [[ "$_choice" -ge 2 && "$_choice" -le $(( _lang_idx + 1 )) ]] 2>/dev/null; then
        SELECTED_LANG="${_lang_codes[$(( _choice - 1 ))]}"
    else
        warn "Invalid choice, defaulting to auto-detect"
        SELECTED_LANG="auto"
    fi
fi

if [[ "$SELECTED_LANG" == "auto" ]]; then
    ok "Language: auto-detect"
else
    ok "Language: $SELECTED_LANG"
fi

# ── 6. Init config directory ────────────────────────────────────────────────
info "Initializing config..."
mkdir -p "$CONFIG_DIR"

# Save language selection to config (auto = remove LANG line, let auto-detect work)
if [[ "$SELECTED_LANG" == "auto" ]]; then
    if [[ -f "$CONFIG_FILE" ]]; then
        sed -i '' '/^LANG=/d' "$CONFIG_FILE"
    fi
    ok "Language: auto-detect (saved)"
else
    if [[ -f "$CONFIG_FILE" ]]; then
        if grep -q '^LANG=' "$CONFIG_FILE" 2>/dev/null; then
            sed -i '' "s/^LANG=.*/LANG=$SELECTED_LANG/" "$CONFIG_FILE"
        else
            printf "LANG=%s\n" "$SELECTED_LANG" >> "$CONFIG_FILE"
        fi
    else
        printf "LANG=%s\n" "$SELECTED_LANG" > "$CONFIG_FILE"
    fi
    ok "Language: $SELECTED_LANG (saved)"
fi
if [[ ! -f "$PROJECTS_FILE" ]]; then
    printf "[]" > "$PROJECTS_FILE"
    ok "~/.config/claude-launcher/projects.json created"
else
    ok "~/.config/claude-launcher/projects.json preserved (existing data kept)"
fi

# ── 7. Register in .zshrc ───────────────────────────────────────────────────
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
echo "  Change language later:"
echo "    zsh install.sh                          # reinstall with new selection"
echo "    export CLAUDE_LAUNCHER_LANG=ko          # override via env var"
echo ""
