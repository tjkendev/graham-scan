
# 頂点データを扱うためのクラス
module.exports = class DotClass

  vert: []
  canvas: null
  rad: 5

  # コンストラクタ
  constructor: (canvas)->
    @canvas = canvas

  # 頂点データ全削除
  clear: ->
    @vert = []

  # 頂点追加
  add: (x, y)->
    @vert.push {x: x, y: y}

  # 頂点削除
  delete: (i)->
    @vert.spice i, 1

  # 頂点半径設定
  setRadian: (r)->
    @rad = r

  # 頂点描画
  drawVertex: ->
    @canvas.beginPath()
    for e in @vert
      @canvas.arc e.x, e.y, @rad, 0, Math.PI*2, true
    @canvas.fill()
