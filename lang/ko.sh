#!/usr/bin/env zsh
# Claude Launcher - Korean language file

# Menu items
_CL_MSG_MENU_TERMINAL="[→ 일반 터미널로]"
_CL_MSG_MENU_ADD="[+ 새 프로젝트 추가]"

# fzf headers
_CL_MSG_FZF_HEADER=" Claude Code Launcher | Enter:선택  Esc:종료"
_CL_MSG_BROWSE_HEADER=" 디렉토리 탐색 | 타이핑으로 필터  Enter:선택  Esc:취소"

# Countdown
_CL_MSG_COUNTDOWN_L1="아무 키나 누르면 프로젝트 목록이 표시됩니다."
_CL_MSG_COUNTDOWN_L2="%d초 후 일반 터미널로 자동 전환됩니다."
_CL_MSG_COUNTDOWN_TIP="팁: CLAUDE_LAUNCHER_SKIP=1 zsh 으로 바로 열기"

# Add project
_CL_MSG_ADD_TITLE="새 프로젝트 추가"
_CL_MSG_ADD_NAME="  이름: "
_CL_MSG_ADD_NAME_REQ="  이름을 입력해야 합니다."
_CL_MSG_ADD_BROWSE="  경로를 탐색하여 선택하세요..."
_CL_MSG_ADD_CANCEL="  취소되었습니다."
_CL_MSG_ADD_INVALID="  유효하지 않은 경로입니다."
_CL_MSG_ADD_OK="  '%s' 추가됨"
_CL_MSG_ADD_DUP="  이미 등록된 경로입니다."
_CL_MSG_ADD_ERR="  오류: %s"

# Errors
_CL_MSG_PATH_ERR="경로를 찾을 수 없습니다: '%s'"
_CL_MSG_NO_PY="Claude Launcher: python3를 찾을 수 없습니다."
_CL_MSG_NO_FZF="Claude Launcher: fzf가 설치되어 있지 않습니다."
_CL_MSG_NO_FZF_HINT="   설치: brew install fzf"
_CL_MSG_NO_LAST="없음"

# Preview
_CL_MSG_PREV_NOPATH="경로를 찾을 수 없습니다:"
_CL_MSG_PREV_TERM="런처를 종료하고 현재 디렉토리에서 터미널을 시작합니다."
_CL_MSG_PREV_ADD1="새 프로젝트를 목록에 추가합니다."
_CL_MSG_PREV_ADD2="프로젝트 이름과 경로를 입력하면 projects.json에 저장됩니다."
