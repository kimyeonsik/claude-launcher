#!/usr/bin/env zsh
# Claude Launcher - 제거 스크립트

INSTALL_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config/claude-launcher"
ZSHRC="$HOME/.zshrc"

# ── 출력 헬퍼 ─────────────────────────────────────────────────────────────────
ok()   { printf "\033[0;32m  ✓\033[0m %s\n" "$1"; }
info() { printf "\033[0;34m  →\033[0m %s\n" "$1"; }

echo ""
echo "  Claude Launcher 제거"
echo "  ─────────────────────────────────────"

# ── 1. 스크립트 제거 ───────────────────────────────────────────────────────────
info "스크립트 제거 중..."
if [[ -f "$INSTALL_DIR/claude-launcher" ]]; then
    rm -f "$INSTALL_DIR/claude-launcher"
    ok "~/.local/bin/claude-launcher 제거됨"
else
    ok "~/.local/bin/claude-launcher 없음 (이미 제거됨)"
fi

# ── 2. .zshrc 정리 ────────────────────────────────────────────────────────────
info ".zshrc 정리 중..."
if grep -q 'claude-launcher' "$ZSHRC" 2>/dev/null; then
    # Claude Launcher 관련 라인 제거 (주석 포함)
    sed -i '' '/[Cc]laude [Ll]auncher/d' "$ZSHRC"
    sed -i '' '/claude-launcher/d'       "$ZSHRC"
    ok "~/.zshrc에서 claude-launcher 제거됨"
else
    ok "~/.zshrc에 claude-launcher 없음"
fi

# ── 3. 설정 및 데이터 처리 ─────────────────────────────────────────────────────
echo ""
printf "  프로젝트 목록 (~/.config/claude-launcher/)도 삭제하시겠습니까? [y/N] "
read -r confirm < /dev/tty

if [[ "$confirm" =~ ^[Yy]$ ]]; then
    rm -rf "$CONFIG_DIR"
    ok "~/.config/claude-launcher/ 제거됨"
else
    ok "~/.config/claude-launcher/ 보존됨 (재설치 시 데이터 유지)"
fi

# ── 완료 ──────────────────────────────────────────────────────────────────────
echo ""
echo "  ─────────────────────────────────────"
echo "  제거 완료."
echo ""
