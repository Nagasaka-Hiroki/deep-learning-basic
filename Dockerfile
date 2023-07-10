#Pythonのバージョンは3.11.2
#ディストリビューションはdebian系を選択する。
FROM python:3.11.2-slim-bullseye

#シェルをbashにする。
SHELL ["/bin/bash","-c"]

#docker compose file経由で.envファイルの変数を参照する。
ARG GROUP_ID
ARG GROUP_NAME
ARG USER_ID
ARG USER_NAME
ARG LIB_PATH

#一般ユーザを追加する。
RUN groupadd -g ${GROUP_ID} ${GROUP_NAME} \
 && useradd -m -s /bin/bash -u ${USER_ID} -g ${GROUP_ID} ${USER_NAME}

#GUI環境を有効にするためのツールをインストールする。
RUN apt-get update && apt-get upgrade -y \
 && apt-get install python3-tk tk-dev -y

#追加でツールをインストールする。
RUN apt-get update && apt-get upgrade -y \
 && apt-get install -y git eog libcanberra-gtk* dbus-x11

#ユーザを切り替える。
USER ${USER_NAME}

#外部ライブラリをインストールする。
RUN pip install --upgrade pip \
 && pip install numpy \
 && pip install matplotlib

#サポートサイトのソースコードを入手する。
RUN git clone https://github.com/oreilly-japan/deep-learning-from-scratch.git ${LIB_PATH}

#作業ディレクトリをホームに設定する。
WORKDIR ${WORK_DIR}

CMD ["/bin/bash"]