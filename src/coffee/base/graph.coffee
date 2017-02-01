module.exports = class GraphClass

  canvas: null
  graph: {}

  constructor: (canvas)->
    @canvas = canvas

  clear: ->
    @graph = {}

  # 頂点の追加
  setNode: (i, x, y, r)->
    if i in @graph
      @graph[i].x = x
      @graph[i].y = y
      @graph[i].r = r
    else
      @graph[i] = {
        x: x
        y: y
        r: r
        edges: []
      }

  # 頂点情報の取得
  getNode: (i)->
    return null if i in @graph
    return @graph[i]

  # 辺の追加
  setEdge: (i, j, c=0)->
    return false if !(i in @graph) || !(j in @graph)
    @graph[i].edges.push j
    return true

  # 頂点の描画
  drawNodes: ->
    @canvas.beginPath()
    for node in @graph
      @canvas.arc(node.x, node.y, node.r, 0, Math.PI*2, true)
      @canvas.arc(node.x, node.y, node.r, 0, Math.PI*2, false)
    @canvas.fill()
    @canvas.stroke()

  # 辺の描画
  drawEdges: ->
    @canvas.beginPath()
    _.each @graph, (e, from)=>
      x0 = e.x; y0 = e.y
      _.each e.edges, (to)=>
        @canvas.moveTo e.x, e.y
        @canvas.lineTo @graph[to].x, @graph[to].y
    @canvas.stroke()
