// webpack.config.js
var path = require('path');
var webpack = require('webpack');
var TerserPlugin = require('terser-webpack-plugin');

module.exports = {
  mode: 'production',

  // 進捗状況を表示する
  progress: true,

  // エントリーファイル
  entry: './src/coffee/main.coffee',

  // 出力パス
  output: {
    path: __dirname,
    filename: './public/js/app.js',
  },

  // module
  module: {
    rules: [
      {test: /\.jade$/, loader: "pug-loader"},
      {test: /\.less$/, loader: 'style!css!less'},
      {test: /\.coffee$/, loader: 'coffee-loader'},
    ],
  },

  // ファイルパスの解決
  resolve: {
    modules: [
      "node_modules",
      path.resolve('./src'),
    ],
    extensions: [
      '.coffee',
      '.webpack.js',
      '.web.js',
      '.js',
      '.jade',
    ],
  },

  // 外部プラグイン
  plugins: [
    new webpack.ProvidePlugin(
      {
        jQuery: 'jquery',
        $: 'jquery',
        _: 'underscore',
      }
    )
  ],

  optimization: {
    minimizer: [
      new TerserPlugin({
        terserOptions: {
          ecma: 6
        }
      })
    ]
  }
};
