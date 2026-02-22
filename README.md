# Claude Launcher

A zsh launcher that shows your registered projects when opening a new terminal. Select a project to navigate to its directory and automatically run `claude`.

**[한국어](#한국어)**

## Features

- **5-second countdown** — press any key to open the selector, or wait for a normal terminal
- **fzf interactive UI** — browse and select projects with directory preview
- **Recent-first sorting** — last used project appears at the top
- **Directory browser** — add projects by browsing with fzf instead of typing paths
- **Warp compatible** — uses precmd hook to avoid shell startup timeout
- **i18n support** — English and Korean (auto-detected from `$LANG`)

## Requirements

| Tool | Install |
|------|---------|
| zsh | Built into macOS |
| python3 | Built into macOS or `brew install python` |
| fzf | `brew install fzf` (auto-installed by install script) |
| claude | [Claude Code](https://claude.ai/code) |

## Install

```bash
git clone https://github.com/kimyeonsik/claude-launcher.git
cd claude-launcher
zsh install.sh
```

During installation, you'll be prompted to select a language:

```
  Available languages:
  * 1) Auto-detect (from $LANG)
    2) English
    3) 한국어 (Korean)

  Select language [1]:
```

Then open a new terminal, or:

```bash
source ~/.zshrc
```

## Uninstall

```bash
cd claude-launcher
zsh uninstall.sh
```

## Usage

### Basic flow

Opens automatically with every new terminal:

```
╔══════════════════════════════════════════════════════╗
║              Claude Code Launcher                    ║
║                                                      ║
║   Press any key to open project list.                ║
║   5 seconds until normal terminal.                   ║
╚══════════════════════════════════════════════════════╝
```

| Action | Result |
|--------|--------|
| Wait 5s | Normal terminal |
| Press any key | Project selector |

### Project selector

```
▶ (type to filter)
────────────────────────────────────────────────────────────
  [→ Normal Terminal]
  [+ Add New Project]
  my-app                    │ /Users/you/projects/my-app   │ 2026-02-22T11:00:00
  api-server                │ /Users/you/projects/api      │ 2026-02-21T09:30:00
```

| Key | Action |
|-----|--------|
| `↑` / `↓` | Navigate |
| `Enter` | Select (project → run claude) |
| `Esc` | Normal terminal |

### Skip launcher

```bash
CLAUDE_LAUNCHER_SKIP=1 zsh
```

### Language

Language is selected during installation. To change later:

```bash
zsh install.sh                          # reinstall with new selection
export CLAUDE_LAUNCHER_LANG=ko          # override via env var
```

Priority: `$CLAUDE_LAUNCHER_LANG` > config file > `$LANG` auto-detect > English

### Adding a new language

1. Copy `lang/en.sh` to `lang/{code}.sh` (e.g. `lang/ja.sh`)
2. Update `_CL_LANG_LABEL` (e.g. `"日本語 (Japanese)"`)
3. Translate all `_CL_MSG_*` strings
4. Run `zsh install.sh` — the new language appears automatically

## File structure

```
~/.local/bin/claude-launcher          # Main script
~/.config/claude-launcher/
├── config                            # Language setting (LANG=ko)
├── projects.json                     # Project list (JSON)
├── preview.sh                        # fzf preview script (auto-generated)
└── lang/
    ├── en.sh                         # English strings
    └── ko.sh                         # Korean strings
```

### projects.json format

```json
[
  {
    "name": "my-app",
    "path": "/Users/you/projects/my-app",
    "last_used": "2026-02-22T11:00:00"
  }
]
```

## License

MIT

---

# 한국어

새 터미널을 열 때마다 등록된 프로젝트 목록을 보여주고, 선택하면 해당 경로로 이동 후 `claude`를 자동 실행하는 zsh 런처입니다.

## 기능

- **5초 카운트다운** — 아무 키를 누르면 선택 UI, 타임아웃 시 일반 터미널
- **fzf 인터랙티브 UI** — 프로젝트 목록 탐색 및 선택, 디렉토리 미리보기
- **최근 사용 순 정렬** — 마지막으로 열었던 프로젝트가 상단에 표시
- **디렉토리 탐색으로 프로젝트 추가** — 경로를 직접 타이핑하지 않고 fzf로 탐색
- **Warp 호환** — precmd 훅 방식으로 쉘 시작 타임아웃 없이 동작
- **다국어 지원** — 영어, 한국어 (`$LANG` 자동 감지)

## 요구사항

| 도구 | 설치 |
|------|------|
| zsh | macOS 기본 내장 |
| python3 | macOS 기본 내장 또는 `brew install python` |
| fzf | `brew install fzf` (설치 스크립트가 자동 설치) |
| claude | [Claude Code](https://claude.ai/code) |

## 설치

```bash
git clone https://github.com/kimyeonsik/claude-launcher.git
cd claude-launcher
zsh install.sh
```

설치 후 새 터미널을 열거나:

```bash
source ~/.zshrc
```

## 제거

```bash
cd claude-launcher
zsh uninstall.sh
```

## 사용법

### 기본 흐름

새 터미널을 열면 자동 실행됩니다:

```
╔══════════════════════════════════════════════════════╗
║              Claude Code Launcher                    ║
║                                                      ║
║   아무 키나 누르면 프로젝트 목록이 표시됩니다.       ║
║   5초 후 일반 터미널로 자동 전환됩니다.              ║
╚══════════════════════════════════════════════════════╝
```

| 동작 | 결과 |
|------|------|
| 5초 대기 | 일반 터미널로 전환 |
| 아무 키 | 프로젝트 선택 UI |

### 프로젝트 선택 UI

```
▶ (검색어 입력)
────────────────────────────────────────────────────────────
  [→ 일반 터미널로]
  [+ 새 프로젝트 추가]
  my-app                    │ /Users/bread/projects/my-app   │ 2026-02-22T11:00:00
  api-server                │ /Users/bread/projects/api      │ 2026-02-21T09:30:00
```

| 키 | 동작 |
|----|------|
| `↑` / `↓` | 이동 |
| `Enter` | 선택 (프로젝트 → claude 실행) |
| `Esc` | 일반 터미널 |

### 런처 없이 터미널 열기

```bash
CLAUDE_LAUNCHER_SKIP=1 zsh
```

### 언어 설정

설치 시 언어를 선택할 수 있습니다. 나중에 변경하려면:

```bash
zsh install.sh                          # 재설치하면서 언어 다시 선택
export CLAUDE_LAUNCHER_LANG=ko          # 환경 변수로 오버라이드
```

우선순위: `$CLAUDE_LAUNCHER_LANG` > config 파일 > `$LANG` 자동 감지 > 영어

## 파일 구조

```
~/.local/bin/claude-launcher          # 메인 스크립트
~/.config/claude-launcher/
├── config                            # 언어 설정 (LANG=ko)
├── projects.json                     # 프로젝트 목록 (JSON)
├── preview.sh                        # fzf 미리보기 스크립트 (자동 생성)
└── lang/
    ├── en.sh                         # 영어 문자열
    └── ko.sh                         # 한국어 문자열
```

## 라이선스

MIT
