# このレポジトリについて
AtCoder のジャッジサーバーに近い環境を Docker で構築することを目的としています。  
対象言語は、C (gcc)、C++ (gcc)、Python、Rust の4つです。  
また、VSCode (の Code Runner 拡張機能) を使用していることが前提となっています。  
Docker 初心者が作成したものです。不備があった等の責任は一切負いません。各自自己責任でご利用ください。  
現状イメージサイズが 3.7 GB とかなり重くなってしまっているので、どうにかしたいと思っているところです。

# Docker Hub から pull する方法
以下のコマンドを実行します。([Docker Hub](https://hub.docker.com/r/lyulu/atcoder/tags))

```
docker pull lyulu/atcoder:latest
```

# Dockerfile からのイメージ作成方法
このレポジトリを　`git clone` した後、 `Dockerfile` のあるディレクトリで以下を実行します。  
ここではイメージ名を `atcoder` タグ名を `latest` としています。(以下同様)

```
docker image build -t atcoder:latest .
```

# コンテナの起動方法
VSCode の Remote - Containers 拡張機能とかを使った方が早いと思いますが、一応載せておきます。  
以下のコマンドを実行します。  
オプションで `--rm` をつけても良いです。(後述)

```
docker run -it atcoder:latest
```

VSCode からコンテナにアクセスする場合、初回起動時 VSCode の必要な各拡張機能をインストールします。  
各言語ごとに `test.[ext]` とついたファイルがあるので、Code Runner 拡張機能を使って実行の確認ができるようになっています。
(ガチガチのテストコードというわけではないので注意してください。)

# コンテナの削除方法
`docker ps -a` コマンドで `IMAGE` が `atcoder` となっている行を探し、その行の `CONTAINER ID` を `[cid]` とした時、以下のコマンドを実行します。  
コンテナ起動時に `--rm` オプションをつけると、終了時に自動的に削除されます。

```
docker rm [cid]
```

# イメージの削除方法
`docker images` コマンドで `REPOSITORY` が `AtCoder` となっている行を探し、その行の `IMAGE ID` を `[iid]` とした時、以下のコマンドを実行します。

```
docker rmi [iid]
```

# 各言語の使用方法
作業ディレクトリは `/home/atcoder` で、コンテナ起動時はここに入ります。  
繰り返しになりますが、VSCode の Code Runner 拡張機能を使用することを前提としています。
各言語の実行コマンドは、適宜 `/home/atcoder/.vscode/settings.json` を参照してください。

# AtCoder の実行環境
各コンテストページのフッターから飛んで確認できるルールページと、[AtCoder 2019/7 Language Update](https://docs.google.com/spreadsheets/d/1PmsqufkF3wjKN6g1L0STS80yP4a6u-VdGiEv5uOHe0M) を参照しました。  
GCC に関してはバージョンが 9.4.0、Python に関してはバージョンが 3.8.12 と少し異なっています。

Python のライブラリのバージョンをコードテストなどで確認したところ、上記スプレッドシート(シート1) とは異なっていたので、以下の表の太字のように修正しています。

| ライブラリ名 | バージョン |
| ----: | ----: |
| Cython | 0.29.16 |
| networkx | 2.4 |
| numba | **0.48.0** |
| numpy | **1.18.2** |
| scikit-learn | **0.22.2.post1** |
| scipy | 1.4.1 |
