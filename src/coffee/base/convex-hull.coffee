# 凸包の計算クラス
module.exports = class ConvexHullClass

  # 頂点データ
  vert: []
  c_vert: []
  mode: 0
  k: 0

  # 頂点全削除
  clear: ->
    @vert = []

  # 頂点追加
  add: (x, y)->
    @vert.push [x, y]

  # 頂点ソート処理
  sort: ->
    @vert.sort(
      (e1, e2)->
        if e1[0] != e2[0]
          return if e1[0] < e2[0] then -1 else 1
        else if e1[1] != e2[1]
          return if e1[1] < e2[1] then -1 else 1
        return 0
    )

  # c_vert初期化
  cv_init: ->
    @c_vert = []
    @t = 0
    @i = 0
    @mode = 0

  # 外積
  cross: (a, b, c)->
    x0 = b[0] - a[0]; y0 = b[1] - a[1]
    x1 = c[0] - a[0]; y1 = c[1] - a[1]
    return x0*y1 - x1*y0

  # (i)下側凸包 (i = 0 -> n-1)
  bottom_ch: (i)->
    k = @c_vert.length
    if k>1 && @cross(@c_vert[k-2], @c_vert[k-1], @vert[i])<=0
      @c_vert.pop()
      return false
    @c_vert.push @vert[i]
    if i==@vert.length-1
      @t = @c_vert.length
    return true

  # (ii)上側凸包 (i = n-2 -> 0)
  top_ch: (i)->
    k = @c_vert.length
    if k>@t && @cross(@c_vert[k-2], @c_vert[k-1], @vert[i])<=0
      @c_vert.pop()
      return false
    @c_vert.push @vert[i]
    return true

  # セットした頂点データを返す
  getVertex: ->
    return @vert

  # 求めた(求めている)凸包の頂点データを返す
  getCHVertex: ->
    return @c_vert

  # 凸包通し
  convex_hull: ->
    n = @vert.length
    if n < 2
      @c_vert = @vert
      return @c_vert
    @cv_init()
    @sort()
    for i in [0..n-1]
      while !@bottom_ch(i)
        null
    for i in [n-2..0]
      while !@top_ch(i)
        null
    return @c_vert

  # 凸包ステップ初期化
  step_init: ->
    @cv_init()
    @sort()

  # 凸包ステップ
  step_convex_hull: ->
    n = @vert.length
    if n < 2
      @c_vert = @vert
      return true
    if @mode == 0
      if @i < n
        if @bottom_ch(@i)
          ++@i
      if @i == n
        ++@mode
        @i = n-2
    else if @mode == 1
      if @i>=0
        if @top_ch(@i)
          --@i
      if @i < 0
        ++@mode
        return true
    else
      return true
    return false
