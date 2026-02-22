# Claude Launcher

새 터미널을 열 때마다 등록된 프로젝트 목록을 보여주고, 선택하면 해당 경로로 이동 후 `claude`를 자동 실행하는 zsh 런처.

## 기능

- **5초 카운트다운** — 아무 키를 누르면 선택 UI, 타임아웃 시 일반 터미널
- **fzf 인터랙티브 UI** — 프로젝트 목록 탐색 및 선택, 오른쪽 패널에 디렉토리 미리보기
- **최근 사용 순 정렬** — 마지막으로 열었던 프로젝트가 상단에 표시
- **디렉토리 탐색으로 프로젝트 추가** — 경로를 직접 타이핑하지 않고 fzf로 탐색
- **Warp 호환** — precmd 훅 방식으로 쉘 시작 타임아웃 없이 동작

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
zsh uninstall.sh
```

## 사용법

### 기본 흐름

새 터미널을 열면 자동 실행됩니다.

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

## 파일 구조

설치 후 생성되는 파일:

```
~/.local/bin/claude-launcher          # 메인 스크립트
~/.config/claude-launcher/
├── projects.json                     # 프로젝트 목록 (JSON)
└── preview.sh                        # fzf 미리보기 스크립트 (자동 생성)
```

### projects.json 형식

```json
[
  {
    "name": "my-app",
    "path": "/Users/bread/projects/my-app",
    "last_used": "2026-02-22T11:00:00"
  }
]
```

## 라이선스

MIT
