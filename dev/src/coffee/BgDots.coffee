BgDotParts = require('./BgDotParts');


# ---------------------------------------------------
# 背景 / ドット
# ---------------------------------------------------
class BgDots
  
  
  constructor: (gl) ->
    
    @_gl = gl;
    
    @_parts = [];
  
  
  
  
  # -----------------------------------------------
  # 初期化
  # -----------------------------------------------
  init: =>
  
  
  
  
  
  # -----------------------------------------------
  # ドットの作成
  # -----------------------------------------------
  createDots: (w, h) =>
    
    # まず全部破棄する
    @disposeDots();
    @_parts = [];
    
#     p = linesModel.p;
#     i = 0;
#     num = p.length;
#     while i < num
#       
#       if MY.u.hit(2)
#         
#         x = p[i+0];
#         y = p[i+1];
#         z = p[i+2] + MY.u.range(100) * 0.1;
#         dotRadius = MY.u.random(20, 40) * 0.1;
#         
#         parts = new BgDotParts(@_gl, linesModel.id[i/3]);
#         parts.init();
#         parts.createVertex(x, y, z, dotRadius);
#         
#         @_parts.push(parts);
#       
#       i += 3;
    
    
#     minRadius = Math.min(w, h) * 0.545;
#     maxRadius = Math.min(w, h) * 0.455;
    
    c = 0.5;
    r = 0.04;
    minRadius = Math.min(w, h) * (c + r);
    maxRadius = Math.min(w, h) * (c - r);
    
    i = 0;
    max = 360;
    add = 360 / MY.param.dotNum;
    while i < max
      
      if @_parts.length % 2 == 0
        radius = minRadius;
      else
        radius = maxRadius;
        
      if MY.u.hit(3)
        radius = MY.u.random(minRadius, maxRadius);
      
      radian = MY.u.radian(i);
      x = Math.sin(radian) * radius;
      y = Math.cos(radian) * radius;
      z = MY.u.range(10);
      dotRadius = MY.u.random(10, 300) * 0.1;
      
      parts = new BgDotParts(@_gl, @_parts.length);
      parts.init();
      parts.createVertex(x, y, z, dotRadius);
      
      @_parts.push(parts);
#       i += MY.u.random(12, 15) * 0.1;
      i += add;
  
  
  
  # -----------------------------------------------
  # ドットの破棄
  # -----------------------------------------------
  disposeDots: =>
    
    if @_parts?
      for val,i in @_parts
        val.dispose();
      @_parts = null;
  
  
  
  # -----------------------------------------------
  # ドットの描画
  # -----------------------------------------------
  draw: (camera) =>
    
    for val,i in @_parts
      val.draw(camera);













module.exports = BgDots;