# 環境構築メモ
　pythonの環境を用意する。インストールすることも考えたが、dockerでコンテナから使ったほうが楽だと思ったのでコンテナを準備する。

最新安定版を調べると3.11.2であると思われる。以下に示す。

- [ Python Source Releases｜Python.org](https://www.python.org/downloads/source/)

コンテナイメージは以下。

- [Python｜Docker](https://hub.docker.com/_/python)

脆弱性の部分が25Lとなっている、これは気になるが以下のブログを読むと、どんなイメージにも脆弱性はあるのであまり気にしても仕方が無いので気にしないことにする。

- [DockerHubで公開されているコンテナが安全か確かめてみた結果【人気のコンテナ上位800個】 - Qiita](https://qiita.com/tomoyamachi/items/e0e69da521505e73237b)

コマンドは以下でプルする。先にプルしたほうがプルする回数を減らせると思うのでしておく。

```bash
docker pull python:3.11.2-slim-bullseye
```

選んだ基準としては脆弱性が低い、debian系、バージョンは3.11.2として選んだ。

これをプルしたあとにコンテナを作るDockerfileとdocker composeコマンドでコンテナ作成できるようにdocker-compose.ymlを作る。

## Dockerの準備
### Dockerfile&docker-compose.ymlの作成
　以前に作った基本を利用する。

- [GitHub - Nagasaka-Hiroki/ruby_edinet_api_sample_1: EDINET APIをコマンドラインとRubyから使う練習。](https://github.com/Nagasaka-Hiroki/ruby_edinet_api_sample_1)

### コンテナの作成
　以下のコマンドで作成できる。

```bash
docker compose up -d --build
```

これでコンテナの作成ができた。環境構築の基本的なところは以上。以降は本を読みながら調整をする。

一応コンテナ内で動作確認。

```bash
user01@74b8a575eb7e:~/deep_learning$ python -V
Python 3.11.2
user01@74b8a575eb7e:~/deep_learning$ python3 -V
Python 3.11.2
```

### 外部ライブラリ
　本を読んでいると、どうやらanacondaを使っているそうだ。

---

anacondaについて。

- [Anaconda パッケージリポジトリが「大規模な」商用利用では有償になっていた - Qiita](https://qiita.com/tfukumori/items/f8fc2c53077b234384fc)
- [Anaconda｜Pricing](https://www.anaconda.com/pricing)

インストールのドキュメントは以下。

- [Anaconda Documentation — Anaconda documentation](https://docs.anaconda.com/)
- [Installing on Linux — Anaconda documentation](https://docs.anaconda.com/anaconda/install/linux/)

調べているとanacndaはライセンスが少し面倒かもしれない。個人利用であっても組織に所属していれば費用がかかるかもしれない。利用の停止方法は使わなければいいということらしいが。

過去にanacondaを使ったことはあるが、機能をほとんど使い切っていない気がした。そのため必要なものを個別にインストールしたほうがいいだろう。特に今はOSがLinuxなのでインストールもそこまで難しいわけではないと思うのでなおさらである。

そのためホストにインストールするのはやめておいたほうがいいかもしれない。スクリプトを実行して途中でライセンスに同意しないでインストールをキャンセルした。

とりあえず、本を読んでいるとNumPyとMatplotlibを使っている感じだったのでそれらをインストールすればいいと思う。そのためコンテナの構成もいつもどおりで問題ないはずだ。

---

NumPyとMatplotlibは以下。

- [numpy · PyPI](https://pypi.org/project/numpy/)
- [matplotlib · PyPI](https://pypi.org/project/matplotlib/)

`pip install`と`python -m pip install`の違いは以下。

- [【Python】”pip install” と “python -m pip install” の違い｜だえうホームページ](https://daeudaeu.com/python-pip-difference/)

確認する。

```bash
$ pip -V
pip 22.3.1 from /usr/local/lib/python3.11/site-packages/pip (python 3.11)
$ python -V
Python 3.11.2
```

つまり、パッチバージョンが違うが、マイナーバージョンまで同一なので、このコンテナに関しては`pip install`と`python -m pip install`は動作は同じになる。

### GUIを使えるようにする。
　dockerでGUIを使うには以下を参考にしたほうが良さそうだ。簡単に調べたところ公式ドキュメントにdisplay環境変数についての言及が見つからなかったのでまずは以下を調べる。

- [DockerでGUIを表示するときの仕組みについて - Qiita](https://qiita.com/Spritaro/items/f907a9b52cb78e4fbec0)
- [Dockerコンテナ上でGUIアプリを表示する（Linux）](https://zenn.dev/ysuito/articles/fdc4a49d83614a)
- [Docker コンテナ内のGUIアプリを起動してホスト側に表示する](https://zukucode.com/2019/07/docker-gui-show.html)
- [Docker上のX11GUIをWindowsで使う](https://zenn.dev/dozo/articles/3ef1565b2b069e)

上記をもとに、docker-compose.ymlを編集する。

```python
import numpy as np
import matplotlib.pyplot as plt
x=np.arange(0,6,0.1)
y=np.sin(x)
plt.plot(x,y)
plt.show()
```

エラーが出る。複数のサイトで追加のツールのインストールで解決するとあった。代表例を示す。

- [[Python][WSL] matplotlib でグラフを描画│Gari Vinegar in HOUSE](https://garivinegar.com/python-wsl-matplotlib/)

xhostを使ってみたがうまく行かない。おそらく問題なくもとに戻せているはず。（ローカルの設定しか変更していないのでセキュリティの問題は無いはず）

設定を検討した結果、DISPLAYの設定が間違っているそうだ。`DISPLAY`をホストと同じにすれば問題なかった。

一応要点をメモする。

#### GUIの有効化設定の要点
　以下にdebian系のコンテナでのGUI(X11 apps)を有効にする要点を示す。

1. ユーザーIDを同じにする。
1. Xサーバーソケットを共有する。
1. DISPLAY環境変数を共有する。

以上である。詳細は以下。以下のブログがきれいにまとまっている。しかしdockerコマンドで打ち込みが長いので私はdocker-compose.ymlに記述した。

- [Dockerコンテナ上でGUIアプリを表示する（Linux）](https://zenn.dev/ysuito/articles/fdc4a49d83614a)

また、pythonでグラフの描画をするためには追加で以下をイメージに追加する必要がある。

```bash
#GUI環境を有効にするためのツールをインストールする。
RUN apt-get update && apt-get upgrade -y \
 && apt-get install python3-tk tk-dev -y
```

以上で以下ができるようになった。

1. pipで追加でライブラリを追加できる。
1. GUIのコマンドを実行できる。

これで本の続きができるようになった。

### Dockerの設定完了
　とりあえず上記までで開発環境のセットアップは完了とする。必要に応じて追記する。