#!/bin/bash
# Interactive checklist for manual steps after `make install`.
# Each step is verified by a command; finished steps are skipped, so re-running is safe.

set -euo pipefail

case "${ROLE:-}" in
client | server) ;;
*) echo "ERROR: ROLE must be client or server" >&2; exit 1 ;;
esac

SETTINGS="x-apple.systempreferences:"
OP_TOKEN_FILE="$HOME/.config/op/service-account-token"
GITHUB_KEY="$HOME/.ssh/id_ed25519_github"
TAILSCALE=/Applications/Tailscale.app/Contents/MacOS/Tailscale
SKIPPED=()

# --- checks -----------------------------------------------------------------

check_filevault_off() { [ "$(fdesetup status)" = "FileVault is Off." ]; }

check_remote_login() { nc -z -G 2 127.0.0.1 22 >/dev/null 2>&1; }

check_auto_login() {
    [ "$(defaults read /Library/Preferences/com.apple.loginwindow autoLoginUser 2>/dev/null)" = "$USER" ]
}

check_tailscale() {
    [ -x "$TAILSCALE" ] && [ "$("$TAILSCALE" status --json 2>/dev/null | jq -r '.BackendState')" = "Running" ]
}

check_op() {
    [ -s "$OP_TOKEN_FILE" ] && OP_SERVICE_ACCOUNT_TOKEN=$(cat "$OP_TOKEN_FILE") op whoami >/dev/null 2>&1
}

check_github_key() {
    ssh -T -o BatchMode=yes -o StrictHostKeyChecking=accept-new git@github.com 2>&1 |
        grep -q "successfully authenticated"
}

# --- runner -----------------------------------------------------------------

# step <title> <check function> <action> <instructions...>
# action: a System Settings pane id, an app name prefixed with "app:", a URL, or "-" for none
step() {
    local title=$1 check=$2 action=$3
    shift 3

    if "$check"; then
        echo "✓ $title"
        return
    fi

    while ! "$check"; do
        echo
        echo "▶ $title"
        printf '  %s\n' "$@"
        case "$action" in
        -) ;;
        app:*) open -a "${action#app:}" ;;
        https://*) open "$action" ;;
        *) open "$SETTINGS$action" ;;
        esac

        local answer
        read -r -p "  完了したら Enter（s: スキップ / q: 中断）> " answer </dev/tty ||
            { echo; echo "入力が終了したため中断しました" >&2; exit 1; }
        case "$answer" in
        s) SKIPPED+=("$title"); return ;;
        q) echo "中断しました" >&2; exit 1 ;;
        esac
        "$check" || echo "  ✗ まだ完了していないようです。もう一度確認してください。"
    done
    echo "✓ $title"
}

# --- steps --------------------------------------------------------------------

if [ "$ROLE" = "server" ]; then
    step "FileVault をオフにする" check_filevault_off com.apple.settings.PrivacySecurity.extension \
        "プライバシーとセキュリティ → FileVault をオフにし、復号の完了を待つ。" \
        "（状態は 'fdesetup status' で確認できます）"

    step "リモートログインをオンにする" check_remote_login com.apple.Sharing-Settings.extension \
        "共有 → 「リモートログイン」をオンにする。"

    step "自動ログインを設定する" check_auto_login com.apple.Users-Groups-Settings.extension \
        "ユーザとグループ → 「自動ログイン」で $USER を選ぶ。" \
        "（FileVault がオンだと選べません）"

    step "Tailscale にログインする" check_tailscale app:Tailscale \
        "Tailscale アプリでログインし、設定で「ログイン時に起動」をオンにする。"

    step "1Password サービスアカウントで op が使える" check_op - \
        "$OP_TOKEN_FILE にトークンを置く（README「インストール前の準備」参照）。" \
        "ディレクトリのパーミッションは 700、ファイルは 600 にしてください。"

    if [ -f "$GITHUB_KEY.pub" ] && ! check_github_key; then
        pbcopy <"$GITHUB_KEY.pub"
        echo
        echo "  GitHub 用の公開鍵をクリップボードにコピーしました: $GITHUB_KEY.pub"
    fi
    step "GitHub に Mac mini 専用の鍵を登録する" check_github_key https://github.com/settings/ssh/new \
        "Title に端末が分かる名前（例: mac-mini-server）を入れ、Key に貼り付けて登録する。"
fi

echo
if [ ${#SKIPPED[@]} -gt 0 ]; then
    echo "スキップした手順があります。完了後にもう一度実行してください:"
    printf '  - %s\n' "${SKIPPED[@]}"
    exit 1
fi
echo "==> すべての手順が完了しています。"
