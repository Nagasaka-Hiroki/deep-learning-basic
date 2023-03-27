# ゼロから作るDeep Learning
　読みながら作業をしていく。GitHubのリポジトリもあるそうだ。以下に示す。

- [GitHub - oreilly-japan/deep-learning-from-scratch: 『ゼロから作る Deep Learning』(O'Reilly Japan, 2016)](https://github.com/oreilly-japan/deep-learning-from-scratch)

## 学習環境
　以下に学習環境をメモする。

|学習環境|設定|
|-|-|
|ホストOS|Ubuntu 22.04|
|エディタ|VSCode|
|docker|23.0.1|
|docker compose|v2.16.0|
|ベースイメージ|python:3.11.2-slim-bullseye|

　GUI(X11 apps)を有効にするためホストの設定を一部コンテナに渡している。

dockerのコンテナを使って学習をする。コンテナの作成は以下のコマンドを実行する。

```bash
docker compose up -d --build
```

## 外部ライブラリ
　本を読んていると以下のライブラリを使用するそうだ。`pip`でインストールする。

- [numpy · PyPI](https://pypi.org/project/numpy/)
- [matplotlib · PyPI](https://pypi.org/project/matplotlib/)

## 素材について
　本の途中で画像などを使うケースがある。そのデータはGitHubリポジトリに準備されている。

- [GitHub - oreilly-japan/deep-learning-from-scratch: 『ゼロから作る Deep Learning』(O'Reilly Japan, 2016)](https://github.com/oreilly-japan/deep-learning-from-scratch)

例えば、画像は以下。

[deep-learning-from-scratch/lena.png at master · oreilly-japan/deep-learning-from-scratch · GitHub](https://github.com/oreilly-japan/deep-learning-from-scratch/blob/master/dataset/lena.png)

画像をダウンロードはホストのコマンドを使うとコンテナに新しく追加しなくて良くなる。ホストで`curl`が使えるようにして以下を実行する。

```bash
curl https://raw.githubusercontent.com/oreilly-japan/deep-learning-from-scratch/master/dataset/lena.png -o lena.png
```

URLは、GitHubのダウンロードのボタンを押すと表示される。そこからコピーしてきた。この要領で他の画像についても同様に操作する。