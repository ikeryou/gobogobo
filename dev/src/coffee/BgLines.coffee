

# ---------------------------------------------------
# 輪っかモチーフ
# ---------------------------------------------------
class BgLines
  
  
  constructor: (gl) ->
    
    @_gl = gl;
    
    # モデルデータ
    @_model = {};
    
    # モデル用行列オブジェクト
    @_modelMtx;
    
    # シェーダ送信用行列オブジェクト
    @_mvpMtx;
    
    # プログラムオブジェクト
    @_prg;
    
    # VBO
    @_vbo = {};
    
    @_rangeOffset = 1;
  
  
  
  # -----------------------------------------------
  # 初期化
  # -----------------------------------------------
  init: =>
    
    # モデル用行列オブジェクト
    @_modelMtx = MY.gu.createMatrix();
    
    # シェーダ送信用行列オブジェクト
    @_mvpMtx = MY.gu.createMatrix();
    
    # プログラムオブジェクト
    @_prg = MY.gu.createProgram(@_gl, MY.gu.createShader(@_gl, "vLine"), MY.gu.createShader(@_gl, "fLine"));
  
  
  
  # -----------------------------------------------
  # 描画時のサイズ設定
  # -----------------------------------------------
  canvasSize: (w, h) =>
    
    # モデルデータ作成
    @_createModelData(w, h);
    
    # VBO作成
    @_vbo.position = MY.gu.createVBO(@_gl, @_prg, "position", 3, @_model.p);
    @_vbo.id       = MY.gu.createVBO(@_gl, @_prg, "id", 1, @_model.id);
    @_vbo.range    = MY.gu.createVBO(@_gl, @_prg, "range", 3, @_model.range);
  
  
  
  # -----------------------------------------------
  # 描画
  # -----------------------------------------------
  draw: (cameraMtx) =>
    
    if !MY.param.line
      return;
      
#     rangeOffset = 1;
#     if MY.u.hit(100)
#       rangeOffset = 10;
#     @_rangeOffset += (rangeOffset - @_rangeOffset) * 0.1;
    
    if MY.param.lineMove
      @_rangeOffset = 1;
    else
      @_rangeOffset = 0;
    
    # シェーダ選択
    MY.gu.attachProgram(@_gl, @_prg);
    
    # シェーダ送信用行列の更新
    m = MY.gu.m();
    m.identity(@_modelMtx);
    m.rotate(@_modelMtx, MY.update.cnt * MY.param.speed * 0.00001, [0,0,1], @_modelMtx);
    m.multiply(cameraMtx, @_modelMtx, @_mvpMtx);
    
    # uniform変数設定
    MY.gu.attachUniform(@_gl, @_prg, "mvpMatrix", "mat4", @_mvpMtx);
#     MY.gu.attachUniform(@_gl, @_prg, "time", "float", MY.update.cnt * 0.01);
    MY.gu.attachUniform(@_gl, @_prg, "time", "float", MY.update.cnt * 0.05);
    MY.gu.attachUniform(@_gl, @_prg, "baseColor", "vec4", [
      MY.conf.BASE_COLOR[0], 
      MY.conf.BASE_COLOR[1], 
      MY.conf.BASE_COLOR[2], 
      MY.param.lineAlpha * 0.01
    ]);
    MY.gu.attachUniform(@_gl, @_prg, "rangeOffset", "float", @_rangeOffset);
    
    # attribute変数登録
    MY.gu.attachVBO(@_gl, @_vbo.position);
    MY.gu.attachVBO(@_gl, @_vbo.id);
    MY.gu.attachVBO(@_gl, @_vbo.range);
    
    @_gl.drawArrays(@_gl.LINE_STRIP, 0, @_model.p.length / 3);
  
  
  
  # -----------------------------------------------
  # モデルデータの作成
  # -----------------------------------------------
  _createModelData: (w, h) =>
    
    positionBuffer = [];
    idBuffer       = [];
    rangeBuffer    = [];
    
    i = 0;
    num = 400;
    while i < num
      
      c = 0.65;
      r = 0.05;
      radiusOut = Math.min(w, h) * (c + r);
      radiusIn  = Math.min(w, h) * (c - r);
    
      @_addVertex(i, radiusOut, radiusIn, 120, positionBuffer, idBuffer, rangeBuffer);
      i++;
    
    @_model.p     = positionBuffer;
    @_model.id    = idBuffer;
    @_model.range = rangeBuffer;
  
  
  
  # -----------------------------------------------
  # 頂点データ追加
  # -----------------------------------------------
  _addVertex: (offset, radiusOut, radiusIn, add, positionBuffer, idBuffer, rangeBuffer) =>
    
    i = 0;
    ang = -offset;
    while ang <= 360 - offset
      
      radius = if i % 2 == 0 then radiusOut else radiusIn;
      radian = MY.u.radian(ang);
      x = Math.sin(radian) * radius;
      y = Math.cos(radian) * radius;
      
      positionBuffer.push(x);
      positionBuffer.push(y);
      positionBuffer.push(0);
      
      idBuffer.push(i * 20);
      
      range = MY.u.random(10, 200);
      range = 20;
      rangeBuffer.push(range);
      rangeBuffer.push(range);
      rangeBuffer.push(0);
      
      i++;
      ang += add;




















module.exports = BgLines;