# キャンバスに描くやつをセットするベース

module.exports = class CanvasClass
  # デバイス系のデータ
  clk: false
  pos: { x: -1, y: -1 }
  canvas: null
  context: null

  # コンストラクタ
  constructor: (canvas) ->
    @canvas = canvas
    @context = canvas.getContext('2d')

  # マウスの座標をセット
  setMousePos: (event) ->
    rect = event.target.getBoundingClientRect()
    @pos.x = event.clientX - rect.left
    @pos.y = event.clientY - rect.top

  # マウスのクリックフラグ
  setMouseClk: (flag) ->
    @clk = flag

  # キャンバスへの描画処理などを行う
  update: ->
    console.log "Canvas Update"

  # テンプレート描画
  #  e.g.) setTemplate("body", template)
  setTemplate: (tag, template, idx = 0) ->
    if template?
      document.getElementsByTagName(tag)[idx]?.innerHTML = template

