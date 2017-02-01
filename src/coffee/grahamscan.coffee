CanvasClass = require 'coffee/base/canvas'
ConvexHullClass = require 'coffee/base/convex-hull.coffee'

module.exports = class CanvasApp extends CanvasClass

  # 凸包クラス
  ch: null
  # 生成頂点の幅
  stroke: 2
  # 生成する頂点の周りの空白
  padding: 10

  # 頂点数
  num: 20
  # ウェイト
  wait: 500
  # ステップ再生か
  is_step: false
  # 今のタイマーID
  fid: 0

  # コンストラクタ
  constructor: ->
    super
    @ch = new ConvexHullClass()

  # 初期化処理
  init: (n)->
    @ch.clear()
    wid = @canvas.width
    hei = @canvas.height
    for i in [0..n-1]
      x = Math.floor(Math.random() * (wid-2*@padding) / @stroke) * @stroke + @padding
      y = Math.floor(Math.random() * (hei-2*@padding) / @stroke) * @stroke + @padding
      @ch.add(x, y)

  # 描画されたオブジェクトとの連結処理
  load: ->
    $wf = $("#wait_frame")
    if $wf.length > 0
      $wf.val(@wait)
    $vn = $("#vertex_num")
    if $vn.length > 0
      $vn.val(@num)
    $st = $("#step_to")
    if $st.length > 0
      $st.click(
        =>
          @get_wait()
          if !@is_step
            @set_timer(@wait)
          else
            @step()
      )
    $sp = $("#step_play")
    if $sp.length > 0
      $sp.change(
        =>
          @is_step = $sp.prop("checked")
      )
    $cvi = $("#cv_init")
    if $cvi.length > 0
      $cvi.click(
        =>
          @get_num()
          @ch_step(@num)
          @render(true)
      )
    $cvr = $("#cv_reset")
    if $cvr.length > 0
      $cvr.click(
        =>
          @get_num()
          @ch_reset()
          @render(true)
      )

  # 後処理
  after: ->
    @load()
    @get_num()
    @ch_step(@num)

  update: ->
    alert 1

  # 凸包一括処理
  ch_all: (n)->
    @init(n)
    @ch.convex_hull()
    @render()

  # 凸包ステップ処理
  ch_step: (n)->
    @get_wait()
    if @wait <= 0 && !@is_step
      @ch_all(n)
      return
    @init(n)
    @ch.step_init()
    if !@is_step
      @render(true)
      @set_timer(@wait)

  # 凸包リセット処理
  ch_reset: ->
    @get_wait()
    @ch.step_init()
    if !@is_step
      @render(true)
      @set_timer(@wait)

  # タイマーセット(ステップ実行または一括実行)
  set_timer: (time, id=-1)->
    if id==-1
      id = ++@fid
    else if @fid != id
      return
    if @wait <= 0
      @all_step()
    else
      window.setTimeout((=>@step(id)), time)

  # 入力からのウェイト取得
  get_wait: ->
    $el = $("#wait_frame") if !$el?
    return if $el.length == 0
    @wait = Number($el.val())

  # 入力からの頂点数取得
  get_num: ->
    $el = $("#vertex_num") if !$el?
    return if $el.length == 0
    @num = Number($el.val())

  # ステップ処理
  step: (id=-1)=>
    return true if id!=@fid && id!=-1
    ret = @ch.step_convex_hull()
    @render(true)
    if !ret && !@is_step
      @get_wait()
      @set_timer(@wait, id)
    return ret

  # 一括ステップ処理
  all_step: ->
    while !@ch.step_convex_hull()
      null
    @render(true)

  # 描画処理
  render: (ch_b = false)->
    @context.beginPath()
    @context.fillStyle = "#fff"
    @context.fillRect 0, 0, @canvas.width, @canvas.height
    @context.fill()
    va = @ch.getVertex()
    n = va.length
    ###
    # 探索順序を表示する
    @context.beginPath()
    @context.strokeStyle = "#eee"
    @context.moveTo va[0][0], va[0][1]
    for i in [1..n-1]
      @context.lineTo va[i][0], va[i][1]
    @context.stroke()
    ###

    # 頂点
    for i in [0..n-1]
      @context.beginPath()
      @context.fillStyle = if i!=@ch.i then "#000" else "#00f"
      @context.arc va[i][0], va[i][1], 5, 0, 2*Math.PI, true
      @context.fill()
    @context.strokeStyle = "#f00"
    chva = @ch.getCHVertex()
    n = chva.length
    if n>=2
      # 非アクティブな線分
      @context.beginPath()
      @context.moveTo chva[0][0], chva[0][1]
      for i in [0..n-2]
        @context.lineTo chva[i+1][0], chva[i+1][1]
      @context.stroke()
    if n>=1 && 0<=@ch.i && @ch.i < va.length
      # アクティブな線分
      @context.strokeStyle= "#0f0"
      @context.beginPath()
      @context.moveTo chva[n-1][0], chva[n-1][1]
      @context.lineTo va[@ch.i][0], va[@ch.i][1]
      @context.stroke()
    if n>=1 && ch_b
      # 通過済みの頂点
      @context.fillStyle = "#fb4"
      for i in [0..n-1]
        @context.beginPath()
        @context.arc chva[i][0], chva[i][1], 5, 0, 2*Math.PI, true
        @context.fill()

