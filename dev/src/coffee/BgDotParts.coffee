

# ---------------------------------------------------
# 背景 / ドット / パーツ
# ---------------------------------------------------
class BgDotParts
  
  
  constructor: (gl, id) ->
    
    @_gl = gl;
    @_id = id;
    
    # モデルデータ
    @_model = {};
    
    # モデル用行列オブジェクト
    @_modelMtx;
    
    # シェーダ送信用行列オブジェクト
    @_mvpMtx;
    
    # プログラムオブジェクト
    @_vsObj;
    @_fsObj;
    @_prg;
    
    # VBO
    @_vbo = {};
    
    # 拡大範囲
    @_range;
    
    # 拡大速度
    @_speed;
    
    # 位置
    @_translate = {x:0, y:0, z:0};
    @_translateOffset = {x:0, y:0, z:0};
    
    # 回転速度
    @_rotateSpeed;
  
  
  
  # -----------------------------------------------
  # 初期化
  # -----------------------------------------------
  init: =>
    
    # モデル用行列オブジェクト
    @_modelMtx = MY.gu.createMatrix();
    
    # シェーダ送信用行列オブジェクト
    @_mvpMtx = MY.gu.createMatrix();
    
    # プログラムオブジェクト
    @_vsObj = MY.gu.createShader(@_gl, "vDot");
    @_fsObj = MY.gu.createShader(@_gl, "fDot");
    @_prg = MY.gu.createProgram(@_gl, @_vsObj, @_fsObj);
  
  
  
  # -----------------------------------------------
  # 破棄
  # -----------------------------------------------
  dispose: =>
    
    if @_prg?
      MY.gu.disposeProgram(@_gl, @_prg, @_vsObj, @_fsObj);
      @_prg = null;
      @_vsObj = null;
      @_fsObj = null;
    
    @_modelMtx = null;
    @_model = null;
    @_mvpMtx = null;
    @_vbo = null;
    @_gl = null;
  
  
  
  # -----------------------------------------------
  # 頂点データの作成
  # -----------------------------------------------
  createVertex: (x, y, z, radius) =>
    
    if MY.u.hit(2)
      @_model = sphere(2, 8, radius);
    else
      @_model = cube(radius);
    
    # 頂点座標を移動
#     i = 0;
#     num = @_model.p.length;
#     while i < num
#     
#       @_model.p[i+0] += x;
#       @_model.p[i+1] += y;
#       @_model.p[i+2] = 20;
#       
#       i += 3;
    
    # 位置
    @_translate.x = x;
    @_translate.y = y;
    @_translate.z = z;
    
    # VBO作成
    @_vbo.position = MY.gu.createVBO(@_gl, @_prg, "position", 3, @_model.p);
    @_vbo.normal   = MY.gu.createVBO(@_gl, @_prg, "normal", 3, @_model.n);
    
    # IBO作成
    @_ibo = MY.gu.createIBO(@_gl, @_model.i);
    
    # 拡大範囲
    @_range = MY.u.random(5, 40);
    
    # 拡大速度
    @_speed = MY.u.random(100, 300) * 0.0001;
    
    # 回転速度
    @_rotateSpeed = MY.u.range(300) * 0.0001;
  
  
  
  # -----------------------------------------------
  # 描画
  # -----------------------------------------------
  draw: (cameraMtx) =>
    
    # ゆらゆらさせる
    radian = @_id + MY.update.cnt * 0.01;
    radius = @_range * MY.u.map(Math.sin(MY.u.radian((@_id * 0.5 + MY.update.cnt) * 3)), 1, MY.param.dotRange, -1, 1);
    @_translateOffset.x = Math.sin(radian) * radius;
    @_translateOffset.y = Math.cos(radian) * radius;
    @_translateOffset.z = Math.sin(radian) * radius;
    
    dotRange = @_range * (MY.param.dotSize * 0.01);
    
    # シェーダ選択
    MY.gu.attachProgram(@_gl, @_prg);
    
    # シェーダ送信用行列の更新
    m = MY.gu.m();
    m.identity(@_modelMtx);
    m.translate(@_modelMtx, [
      @_translate.x + @_translateOffset.x, 
      @_translate.y + @_translateOffset.y, 
      @_translate.z + @_translateOffset.z
    ], @_modelMtx);
    m.rotate(@_modelMtx, MY.update.cnt * @_rotateSpeed, [1,1,1], @_modelMtx);
    m.multiply(cameraMtx, @_modelMtx, @_mvpMtx);
    
    # uniform変数設定
    MY.gu.attachUniform(@_gl, @_prg, "mvpMatrix", "mat4", @_mvpMtx);
    MY.gu.attachUniform(@_gl, @_prg, "time", "float", MY.update.cnt * @_speed);
    MY.gu.attachUniform(@_gl, @_prg, "baseColor", "vec4", [
      MY.conf.BASE_COLOR[0], 
      MY.conf.BASE_COLOR[1], 
      MY.conf.BASE_COLOR[2], 
      1
    ]);
    MY.gu.attachUniform(@_gl, @_prg, "id", "float", @_id * 0.5);
    MY.gu.attachUniform(@_gl, @_prg, "range", "float", dotRange);
    
    # attribute変数登録
    @_gl.bindBuffer(@_gl.ELEMENT_ARRAY_BUFFER, @_ibo);
    MY.gu.attachVBO(@_gl, @_vbo.position);
    MY.gu.attachVBO(@_gl, @_vbo.normal);
    
    @_gl.drawElements(@_gl.TRIANGLES, @_model.i.length, @_gl.UNSIGNED_SHORT, 0);






module.exports = BgDotParts;