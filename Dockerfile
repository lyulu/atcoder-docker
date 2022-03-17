# Ubuntu 18.04
FROM ubuntu:18.04

# 環境変数 (DEBIAN_FRONTEND は tzdata のインストール時に必要)
ENV DEBIAN_FRONTEND=noninteractive

ENV TZ=Asia/Tokyo

ENV PYTHON_VERSION 3.8.12

ENV RUST_VERSION 1.42.0

# git や Python に必要なものなどをインストール
RUN apt-get update -y && \
    apt update -y && \
    apt install -y binutils build-essential curl git git-core \
        libbz2-dev libdb-dev libffi-dev libgdbm-dev liblzma-dev libncursesw5-dev \
        libreadline-dev libsqlite3-dev libssl-dev libxml2-dev libxmlsec1-dev \
        make pkg-config python3-pip time tk-dev tree tzdata uuid-dev vim wget xz-utils zlib1g-dev

# C/C++ をインストール (gcc)
RUN apt-get update -y && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
    apt update -y && \
    apt install -y gcc-9 g++-9 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 10 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 10

# Python のインストール
WORKDIR /tmp

RUN curl -O https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz && \
    tar -xJf Python-$PYTHON_VERSION.tar.xz && \
    cd Python-$PYTHON_VERSION && \
    ./configure --prefix=/usr/local/python \
        --enable-loadable-sqlite-extensions \
        --enable-optimizations \
        --enable-option-checking=fatal \
        --with-system-ffi && \
    make && \
    make install

# PyPy のインストール
RUN add-apt-repository -y ppa:pypy/ppa && \
    apt update -y && \
    apt install -y pypy pypy3

# Rust のインストール
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile minimal -y

ENV PATH $PATH":/root/.cargo/bin"

RUN rustup toolchain install $RUST_VERSION && \
    rustup default $RUST_VERSION && \
    rustup component add --toolchain $RUST_VERSION rls rust-analysis rust-src

# Python ライブラリのインストール
COPY requirements.txt /home

RUN /usr/local/python/bin/python3 -m pip install --upgrade pip && \
    /usr/local/python/bin/python3 -m pip install -r /home/requirements.txt

# ac-library のインストール (/lib/ac-library に atcoder フォルダができる)
RUN git clone https://github.com/atcoder/ac-library.git /lib/ac-library

ENV CPLUS_INCLUDE_PATH /lib/ac-library

# online-judge-tools をインストール
RUN python3 -m pip install online-judge-tools

# Rust で Hello, world! を実行してライブラリをコンパイル
COPY rust/ /usr/local/rust/

WORKDIR /usr/local/rust

RUN cargo build --release --quiet && \
    cargo run

# ファイルのコピー
COPY atcoder/ /home/atcoder/

# 不要ファイルの削除
RUN rm -r /tmp/*

# コンテナ起動時の命令
WORKDIR /home/atcoder

RUN mkdir ./bin

ENTRYPOINT [ "/bin/bash" ]
