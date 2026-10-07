# クイックスタート

以下のコマンドを実行するだけでセットアップが完了します :heart_eyes::sparkles:

```shell
$ xcode-select --install
$ curl -fsSL https://raw.githubusercontent.com/andoshin11/dotfiles/master/install.sh | ROLE=server bash
```

`ROLE` の指定は必須です。

- `client`: 手元で操作するノート PC。SSH 鍵は 1Password の SSH agent から使います。
- `server`: 常時稼働させてリモートから操作するマシン（Mac mini）。承認待ちで処理が止まらないよう、GitHub 用にパスフレーズなしの専用鍵を使います。

実行前に **App Store にサインイン**しておいてください。`mas` による Mac App Store アプリのインストールは、未サインインだと応答待ちのまま停止します。

# インストール後の手作業 :hand:

以下はスクリプト化できない作業です。`install.sh` の完了後に一度だけ実施してください。

## SSH（`server`）

1. 生成された公開鍵を GitHub に登録します（**Settings > SSH and GPG keys > New SSH key**）。この鍵だけを個別に失効できるよう、マシンを識別できるタイトル（例: `mac-mini-server`）を付けてください。
   ```shell
   $ cat ~/.ssh/id_ed25519_github.pub
   ```
2. 接続を確認します。
   ```shell
   $ ssh -T git@github.com
   ```

無人ジョブが止まらないよう、この鍵にはパスフレーズを設定していません。マシンの紛失や侵害が起きた場合は、直ちに GitHub でこの鍵を失効させてください。

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
`make init` コマンドで、`./scripts` 配下のすべてのスクリプトが初期化のために実行されます。

- `etc/ssh/config.$ROLE` を初期テンプレートとして `~/.ssh/config` にコピー（既に存在する場合はスキップ。マシン固有のホストはそこに直接追記）。`server` の場合は GitHub 用の専用鍵を生成 :key:
- Homebrew のインストールと `etc/Brewfile` の CLI・アプリの導入（`brew bundle`） :beer:
- fish シェルのセットアップ :fish:
- powerline フォントと fish テーマのインストール :art:
- Mac App Store アプリのインストール（`mas`） :apple:
- dein.vim のセットアップ :pencil2:
- Node 環境のセットアップ :earth_asia:
- Go 環境のセットアップ :muscle:
- VSCode のセットアップ :pencil:
- Google Cloud SDK のセットアップ :cloud:
- Claude Code のインストール（公式ネイティブインストーラー。自動更新される） :robot:


## デプロイ
`make deploy` コマンドで、すべての dotfiles のシンボリックリンクが作成されます。

- .gitconfig
- .tmux.conf
- .vimrc
- .zshrc

# 連絡先
Shin Ando (andoshin11)

<shinglish11@gmail.com>
