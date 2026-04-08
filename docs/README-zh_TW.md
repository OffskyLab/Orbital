# orbital

<p align="center">
  <img src="../assets/icon-1024x1024.png" alt="orbital" width="256" height="256" />
</p>

Per-shell 環境管理工具，為 AI CLI 工具（Claude Code、Codex CLI、Gemini CLI）隔離帳號，輕鬆切換工作與個人情境。

## 問題

Claude Code、Codex、Gemini 等 AI CLI 工具，會將設定（API 金鑰、認證 token、偏好設定）存放在單一全域目錄。如果你同時有工作帳號與個人帳號，切換時就得手動搬移憑證，或者乾脆準備兩台電腦。`orbital` 讓每個情境都有自己獨立的設定目錄，只在當前 shell 生效。

## 運作方式

`orbital` 管理存放在 `~/.orbital/envs/<name>/` 下的命名環境，每個環境包含：
- 一組工具（`claude`、`codex`、`gemini`）及其獨立的設定子目錄
- 自訂環境變數（API 金鑰等）

執行 `orbital use work` 時，shell function 會攔截指令、呼叫內部指令 `orbital _export work`，然後 `eval` 輸出結果 — 僅在當前 shell 設定 `CLAUDE_CONFIG_DIR`、`CODEX_CONFIG_DIR` 等變數。其他終端機視窗不受影響。

## 系統需求

- macOS 13+ 或 Linux
- bash 或 zsh

## 安裝

### 安裝腳本（推薦）

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/OffskyLab/orbital/main/install.sh)"
```

從原始碼編譯並安裝到 `/usr/local/bin`。需要 Swift（Xcode 或 Xcode Command Line Tools）。

### Homebrew

```bash
brew install OffskyLab/orbital/orbital
```

### 從原始碼編譯

```bash
git clone https://github.com/OffskyLab/orbital.git
cd orbital
swift build -c release
cp .build/release/orbital /usr/local/bin/orbital
```

### Shell 整合

安裝後執行一次：

```bash
eval "$(orbital setup)"
```

這會將 `eval "$(orbital setup)"` 寫入你的 shell rc 檔（`~/.zshrc` 或 `~/.bashrc`，自動偵測），並在當前 shell 立即生效。

## 快速開始

```bash
# 建立環境
orbital create work --description "工作帳號"
orbital create personal --description "個人帳號"

# 管理環境中的工具（互動式多選）
orbital tools -e work
orbital tools -e personal

# 儲存憑證
orbital set env ANTHROPIC_API_KEY sk-ant-work123 -e work
orbital set env ANTHROPIC_API_KEY sk-ant-personal456 -e personal

# 切換環境（需要 shell 整合）
orbital use work
orbital use personal

# 停用（清除所有 orbital 環境變數）
orbital deactivate
```

## 指令

### 環境管理

| 指令 | 說明 |
|---|---|
| `orbital create <name>` | 建立新環境 |
| `orbital create <name> --clone <source>` | 從現有環境複製工具與環境變數 |
| `orbital create <name> --isolate-sessions` | 建立環境並隔離 session（預設為共享） |
| `orbital delete <name>` | 刪除環境（會要求確認） |
| `orbital delete <name> --force` | 不確認直接刪除 |
| `orbital list` | 列出所有環境（`*` 標示目前啟用的） |
| `orbital info [name]` | 顯示環境的詳細資訊（預設為目前啟用的環境） |

### 切換

> 需要 shell 整合（`eval "$(orbital setup)"`）

| 指令 | 說明 |
|---|---|
| `orbital use <name>` | 在當前 shell 啟用環境 |
| `orbital deactivate` | 停用目前的環境 |
| `orbital current` | 顯示目前啟用的環境名稱 |

### 設定

| 指令 | 說明 |
|---|---|
| `orbital tools [-e <name>]` | 互動式管理工具（多選） |
| `orbital set env <KEY> <VALUE> -e <name>` | 設定環境變數 |
| `orbital unset env <KEY> -e <name>` | 移除環境變數 |
| `orbital which <tool>` | 顯示目前環境中工具的設定目錄路徑 |

> 如果已啟用環境（`orbital use <name>`），可省略 `-e` 參數。

### Shell 整合

| 指令 | 說明 |
|---|---|
| `orbital setup` | 安裝 shell 整合到 rc 檔（冪等操作） |
| `orbital init` | 輸出 shell 整合腳本（供手動設定） |

## Session 共享

預設情況下，不同環境會共享 session 資料（對話歷史），讓你可以在切換帳號後接續同一個對話。共享的目錄會存放在 `~/.orbital/shared/<tool>/`，透過 symlink 連結到各環境。

如果需要完全隔離 session，可在建立環境時加上 `--isolate-sessions` 參數。

## 儲存結構

環境存放在 `$ORBITAL_HOME`（預設：`~/.orbital`）底下：

```
~/.orbital/
  current              # 上次啟用的環境名稱
  shared/              # 共享的 session 資料
    claude/
      projects/
      sessions/
      session-env/
  envs/
    <UUID>/
      env.json         # 中繼資料：工具、環境變數、時間戳
      claude/          # CLAUDE_CONFIG_DIR 指向此處
        projects -> ~/.orbital/shared/claude/projects
        sessions -> ~/.orbital/shared/claude/sessions
      codex/           # CODEX_CONFIG_DIR 指向此處
    <UUID>/
      env.json
      claude/
```

設定 `ORBITAL_HOME` 環境變數可使用自訂路徑。

## orbital use 設定的環境變數

| 工具 | 變數 |
|---|---|
| `claude` | `CLAUDE_CONFIG_DIR` |
| `codex` | `CODEX_CONFIG_DIR` |
| `gemini` | `GEMINI_CONFIG_DIR` |

透過 `orbital set env` 設定的自訂環境變數也會在 `orbital use` 時匯出。

## 多語系支援

orbital 會偵測系統語系（`LC_ALL`、`LC_MESSAGES`、`LANG`），自動切換繁體中文或英文介面。

## 授權

Apache 2.0
