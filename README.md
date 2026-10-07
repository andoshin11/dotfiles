# クイックスタート

以下のコマンドを実行するだけでセットアップが完了します :heart_eyes::sparkles:

```shell
$ xcode-select --install
$ curl -fsSL https://raw.githubusercontent.com/andoshin11/dotfiles/master/install.sh | ROLE=server bash
```

`ROLE` の指定は必須です。

- `client`: 手元で操作するノート PC。SSH 鍵は 1Password の SSH agent から使います。
- `server`: 常時稼働させてリモートから操作するマシン（Mac mini）。GitHub へは SSH 鍵ではなく `gh` の認証（HTTPS）でアクセスします。

インストールの前に、下記の「インストール前の準備」を済ませてください。

# インストール前の準備 :clipboard:

## 共通

- **App Store にサインイン**しておく（初回セットアップで Apple アカウントにサインインしていれば不要）。`mas` による Mac App Store アプリのインストールは、未サインインだと応答待ちのまま停止します。

## 1Password（`server`、新しい端末を用意する前に別の端末で実施）

サーバーは 1Password のサービスアカウント経由で、その端末専用の vault だけを読み取ります。サービスアカウントの権限（アクセスできる vault と読み書き）は作成後に変更できないため、先に vault を用意します。

1. **端末専用の vault を作る**：1Password で新しい vault（例: `mac-mini`）を作成し、その端末で使うシークレット（API キーなど）だけを入れる。Personal / Private / Employee vault と既定の Shared vault はサービスアカウントに許可できません。
2. **サービスアカウントを作る**：1Password.com の Developer → Service Accounts から、上の vault への**読み取り専用**の権限で作成する（CLI の場合は下記）。
   ```shell
   $ op service-account create mac-mini --vault mac-mini:read_items
   ```
3. **トークンを保存する**：トークンは作成時に一度しか表示されません。すぐに自分の Private vault に保存してください。
4. **SSH ログイン用の鍵を作る**：自分の Private vault で新しい SSH 鍵（ed25519）を生成する（例: `mac-mini login`）。秘密鍵は Private vault にだけ置き、接続元の端末から 1Password の SSH agent 経由で使います。
5. **公開鍵をサーバーの vault に置く**：上の vault（例: `mac-mini`）にセキュアノート `authorized-keys` を作り、本文に公開鍵を 1 行ずつ貼る。サーバーはこのノートを読んで `~/.ssh/authorized_keys` に追記します（サービスアカウントからは公開鍵しか見えません）。

## サーバー（`server`、新しい端末で実施）

`scripts/16_server.sh` は、FileVault がオンのとき、またはサービスアカウントのトークンがないときにエラーで停止します。

1. **FileVault をオフにする**：停電・アップデート後の再起動でパスワード入力待ちにならないようにします。初回セットアップで Apple アカウントにサインインすると FileVault は自動でオンになるため、セットアップ完了後にシステム設定 → プライバシーとセキュリティ → FileVault でオフにし、復号の完了を待つ。状態は `fdesetup status` で確認できます（`FileVault is Off.` になれば完了）。
2. **リモートログイン**：システム設定 → 一般 → 共有 → 「リモートログイン」をオンにする。
3. **サービスアカウントのトークンを置く**：1Password に保存したトークンを貼り付けて Ctrl-D で確定する（シェルの履歴に残さないため）。
   ```shell
   $ (umask 077; mkdir -p ~/.config/op && cat > ~/.config/op/service-account-token)
   ```

# インストール後の手作業 :hand:

以下はスクリプト化できない作業です。`install.sh` の完了後に、次のコマンドで 1 つずつ案内を受けながら進められます。各手順の完了はコマンドで確認され、完了済みの手順は飛ばされるので、何度でも再実行できます。

```shell
$ make post-install ROLE=server
```

## サーバー（`server`）

1. **自動ログイン**：システム設定 → ユーザとグループ → 「自動ログイン」で自分のユーザーを選ぶ（再起動後にアプリが自動起動するように）。
2. **Tailscale**：アプリを起動してログインし、ログイン時に自動起動するよう設定する。
3. **1Password CLI を確認する**：`fish/conf.d/dotfiles.fish` は、トークンのファイルがある場合に限り `op` の実行時だけトークンを渡します（シェル全体の環境変数にはしません）。
   ```shell
   $ op whoami       # サービスアカウントとして認証されていること
   $ op vault list   # 端末専用の vault だけが見えること
   ```
   シークレットをアプリに渡すときは、`op://` 参照を書いた env ファイルと `op run` を使います。
   ```shell
   $ op run --env-file=.env -- <command>
   ```
4. **GitHub に gh でログインする**：git（HTTPS）と `gh` の両方がこの認証を使います。`make post-install` から実行されます。
   ```shell
   $ gh auth login --hostname github.com --git-protocol https --web --scopes read:packages
   ```
   「Authenticate Git with your GitHub credentials?」には **n** と答えてください。git の認証に `gh` を使う設定は、このリポジトリの `.gitconfig` で管理しています（`~/.gitconfig` はこのリポジトリへの symlink なので、y だとリポジトリの `.gitconfig` が書き換わります）。`read:packages` は GitHub Packages（npm）を読むための権限です。
   マシンの紛失や侵害が起きた場合は、GitHub の Settings → Applications で gh（GitHub CLI）の認証を取り消し、1Password でサービスアカウントのトークンも失効させてください。

`16_server.sh` はスリープの無効化（画面のみ 10 分で消灯）、停電復旧後の自動起動、1Password の `authorized-keys` ノートからの公開鍵の登録、SSH の鍵認証のみ化を設定します。接続元の端末からは、Private vault の SSH 鍵を使って 1Password の SSH agent 経由でログインします。

## VS Code

設定・拡張機能・キーボードショートカットは、このリポジトリではなく VS Code の Settings Sync で管理します。VS Code を起動し、アカウントメニューの **Backup and Sync Settings** から GitHub アカウントでサインインしてください。

## fish

- `~/.config/fish/config.fish` はマシン固有の設定（シークレット、ツールが追記する行など）用で、このリポジトリでは管理しません。共通設定は `fish/conf.d/dotfiles.fish` に書いてください。
- プラグインを追加・削除したら `fish/fish_plugins` にも反映し、`fisher update` で同期します。

## SSH（共通）

- `~/.ssh/config` は、存在しない場合に限り `etc/ssh/config.$ROLE` からコピーされます。マシン固有のホスト（業務用の踏み台など）は `~/.ssh/config` に直接記述し、このリポジトリには含めないでください。
- すでにファイルが存在した場合、インストール時にはスキップされます。テンプレートと比較し、必要な差分を手動で反映してください。
  ```shell
  $ diff etc/ssh/config.$ROLE ~/.ssh/config
  ```

# 注意事項 :warning:
これらのスクリプトはすべての環境での動作を検証しておらず、マシンに深刻なダメージを与える可能性が**非常に**高いです :computer:

実際にマシンで実行する前に、フォークして自分用にカスタマイズすることを強くおすすめします。


# 何が行われるか

`install.sh` は、環境に応じてこのリポジトリを clone またはダウンロードします。

## 初期化
`make init` コマンドで、`./scripts` 配下のスクリプトがファイル名順に実行されます。いずれかが失敗した時点で停止するので、原因を解消してから `make install ROLE=...` を再実行してください（各スクリプトは再実行しても安全です）。

- `~/.ssh` を作成。`client` の場合は `etc/ssh/config.client` を初期テンプレートとして `~/.ssh/config` にコピー（既に存在する場合はスキップ。マシン固有のホストはそこに直接追記） :key:
- Homebrew のインストールと `etc/Brewfile` の CLI・アプリ・フォントの導入（`brew bundle`） :beer:
- fish をログインシェルに設定し、共通設定 `fish/conf.d/dotfiles.fish` を `~/.config/fish/conf.d/` に symlink。`fish/fish_plugins` を初回のみコピーし、fisher でプラグイン（bobthefish など）を導入 :fish:
- Mac App Store アプリのインストール（`mas`） :apple:
- Node.js の Active LTS を nodebrew で導入し、yarn をインストール :earth_asia:
- Terraform の最新安定版を tfenv で導入（バージョンは `~/.tfenv` に保存） :building_construction:
- Python 3 の最新安定版を uv でインストール（ビルド済みバイナリ）し、`python` / `python3` を `~/.local/bin` に配置 :snake:
- Claude Code のインストール（公式ネイティブインストーラー。自動更新される） :robot:
- `server` の場合のみ、スリープ無効化・停電復旧後の自動起動・1Password からの公開鍵の登録・SSH の鍵認証のみ化を設定 :desktop_computer:


## デプロイ
`make deploy` コマンドで、すべての dotfiles のシンボリックリンクが作成されます。

- .gitconfig
- .tmux.conf

# 連絡先
Shin Ando (andoshin11)

<shinglish11@gmail.com>
