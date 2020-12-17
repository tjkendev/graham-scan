window._ = _ = require 'underscore'
window.$ = $ = require 'jquery'

CanvasClass = require 'coffee/router'

# 読み込み完了時
window.onload = ->

  # bodyにベースを描画
  $("body").html(require('jade/main.jade')())

  # canvasを取得
  canvas = $('#app_canvas')[0]

  # 描画するもの
  cvs = new CanvasClass(canvas)

  # 後処理
  cvs.after?()

  # マウスを移動させた時
  canvas.onmousemove = (event) ->
    # ブラウザごとに取れるattrが違うらしい
    # buttons -> firefox, IE10
    # which -> chrome
    # button -> IE9
    state = event.buttons ? event.which ? event.button
    cvs.setMousePos(event)
    cvs.setMouseClk(state > 0)
  # マウスを離した時
  canvas.onmouseup = (event) ->
    cvs.setMousePos(event)
    cvs.setMouseClk(false)
  # マウスでクリックした時
  canvas.onmousedown = (event) ->
    cvs.setMousePos(event)
    cvs.setMouseClk(true)

  return true

