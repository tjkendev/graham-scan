# Graham Scan の可視化

## 概要

2014年頃に制作

HTML5上でGrahamScan(凸包アルゴリズム)を表示できるようにしたもの

ステップ的に可視化して凸包を計算する

以下で実行しているものが見られる

- http://smijake3.s602.xrea.com/tips/algorithm/graham_scan/

## 構築環境

- npm v7.6.3
  - grunt
    - webpack
  - coffee
  - pug
    - (jadeで実装していたので今も一部jade)
  - less

## コンパイル

npmで必要なモジュールをインストール

```bash
npm install
```

プログラムのコンパイル

```bash
npm run compile
```

コンパイルに成功すると"public"フォルダ内に成果物ができる

## その他

### - watch

ファイルを変更するごとに自動でコンパイルしてくれる

```bash
npm run watch
```
