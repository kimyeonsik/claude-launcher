#!/usr/bin/env zsh
# Claude Launcher - 설치 스크립트

set -e

INSTALL_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config/claude-launcher"
PROJECTS_FILE="$CONFIG_DIR/projects.json"
ZSHRC="$HOME/.zshrc"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ── 출력 헬퍼 ─────────────────────────────────────────────────────────────────
info()    { printf "\033[0;34m  →\033[0m %s\n" "$1"; }
ok()      { printf "\033[0;32m  ✓\033[0m %s\n" "$1"; }
warn()    { printf "\033[0;33m  !\033[0m %s\n" "$1"; }
fail()    { printf "\033[0;31m  ✗\033[0m %s\n" "$1" >&2; exit 1; }

echo ""
echo "  Claude Launcher 설치"
echo "  ─────────────────────────────────────"

# ── 1. 의존성 확인 ─────────────────────────────────────────────────────────────
info "의존성 확인 중..."

# zsh 확인
[[ -n "$ZSH_VERSION" ]] || fail "zsh 환경에서 실행해야 합니다. (zsh install.sh)"

# python3 확인
PYTHON3=$(command -v python3 2>/dev/null)
[[ -z "$PYTHON3" && -x "/opt/homebrew/bin/python3" ]] && PYTHON3="/opt/homebrew/bin/python3"
[[ -z "$PYTHON3" && -x "/usr/bin/python3" ]]          && PYTHON3="/usr/bin/python3"
[[ -z "$PYTHON3" ]] && fail "python3가 없습니다."
ok "python3: $PYTHON3"

# fzf 확인 (없으면 brew로 설치)
if ! command -v fzf &>/dev/null && [[ ! -x "/opt/homebrew/bin/fzf" ]]; then
    if command -v brew &>/dev/null; then
        info "fzf 설치 중..."
        brew install fzf
        ok "fzf 설치 완료"
    else
        fail "fzf가 없습니다. 'brew install fzf'로 먼저 설치해주세요."
    fi
else
    ok "fzf: $(command -v fzf 2>/dev/null || echo /opt/homebrew/bin/fzf)"
fi

# ── 2. ~/.local/bin 준비 ───────────────────────────────────────────────────────
info "설치 디렉토리 준비 중..."
mkdir -p "$INSTALL_DIR"

# PATH에 없으면 .zshrc에 추가
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    if ! grep -qF 'local/bin' "$ZSHRC" 2>/dev/null; then
        printf '\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$ZSHRC"
        warn "~/.local/bin 을 PATH에 추가했습니다. (~/.zshrc)"
    fi
fi
ok "~/.local/bin 준비됨"

# ── 3. 스크립트 설치 ───────────────────────────────────────────────────────────
info "claude-launcher 설치 중..."
cp "$SCRIPT_DIR/claude-launcher" "$INSTALL_DIR/claude-launcher"
chmod +x "$INSTALL_DIR/claude-launcher"
ok "~/.local/bin/claude-launcher 설치됨"

# ── 4. 설정 디렉토리 초기화 ────────────────────────────────────────────────────
info "설정 초기화 중..."
mkdir -p "$CONFIG_DIR"
if [[ ! -f "$PROJECTS_FILE" ]]; then
    printf "[]" > "$PROJECTS_FILE"
    ok "~/.config/claude-launcher/projects.json 생성됨"
else
    ok "~/.config/claude-launcher/projects.json 유지됨 (기존 데이터 보존)"
fi

# ── 5. .zshrc 등록 ────────────────────────────────────────────────────────────
info ".zshrc 등록 중..."
LAUNCHER_LINE='[[ -f "$HOME/.local/bin/claude-launcher" ]] && source "$HOME/.local/bin/claude-launcher"'

if grep -qF 'claude-launcher' "$ZSHRC" 2>/dev/null; then
    warn "~/.zshrc에 이미 claude-launcher가 등록되어 있습니다."
else
    cat >> "$ZSHRC" << 'ZSHRC_EOF'

# Claude Launcher - 새 터미널마다 프로젝트 선택기 표시
# 비활성화: CLAUDE_LAUNCHER_SKIP=1 zsh
[[ -f "$HOME/.local/bin/claude-launcher" ]] && source "$HOME/.local/bin/claude-launcher"
ZSHRC_EOF
    ok "~/.zshrc에 등록됨"
fi

# ── 완료 ──────────────────────────────────────────────────────────────────────
echo ""
echo "  ─────────────────────────────────────"
echo "  설치 완료! 🚀"
echo ""
echo "  새 터미널을 열거나 다음을 실행하세요:"
echo "    source ~/.zshrc"
echo ""
echo "  런처 없이 터미널 열기:"
echo "    CLAUDE_LAUNCHER_SKIP=1 zsh"
echo ""
