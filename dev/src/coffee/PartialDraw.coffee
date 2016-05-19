

# ---------------------------------------------------
# 部分描画オブジェクト
# ---------------------------------------------------
class PartialDraw
  
  
  constructor: (gl) ->
    
    @_gl = gl;
    
    # モデルデータ
    @_model;
    
    # モデル用行列オブジェクト
    @_modelMtx;
    
    # シェーダ送信用行列オブジェクト
    @_mvpMtx;
    
    # プログラムオブジェクト
    @_prg;
    
    # VBO
    @_vbo = {};
    
    # IBO
    @_ibo;
    
    # シェーダに渡すテクスチャ
    @_texture = [];
  
  
  
  # -----------------------------------------------
  # 初期化
  # -----------------------------------------------
  init: =>
    
    # モデル用行列オブジェクト
    @_modelMtx = MY.gu.createMatrix();
    
    # シェーダ送信用行列オブジェクト
    @_mvpMtx = MY.gu.createMatrix();
    
    # プログラムオブジェクト
    @_prg = MY.gu.createProgram(@_gl, MY.gu.createShader(@_gl, 'vPartialDraw'), MY.gu.createShader(@_gl, 'fPartialDraw'));
    
    # プレーンなモデルデータ作成
    @_model = MY.gu.planeModelData();
    
    # VBO作成
    @_vbo.position = MY.gu.createVBO(@_gl, @_prg, "position", 3, @_model.p);
    @_vbo.texCoord = MY.gu.createVBO(@_gl, @_prg, "texCoord", 2, @_model.t);
    
    # IBO作成
    @_ibo = MY.gu.createIBO(@_gl, @_model.i);
  
  
  
  # -----------------------------------------------
  # テクスチャ登録
  # -----------------------------------------------
  attachTexture: (tex0, tex1, tex2, noiseTex) =>
    
    @_texture[0] = tex0;
    @_texture[1] = tex1;
    @_texture[2] = tex2;
    
    @_texture[3] = noiseTex;
  
  
  
  # -----------------------------------------------
  # 描画
  # -----------------------------------------------
  draw: (cameraMtx) =>
    
    if !@_texture[3]?
      return;
    
    time = MY.update.cnt;
    
    # シェーダ選択
    MY.gu.attachProgram(@_gl, @_prg);
    
    # シェーダ送信用行列の更新
    m = MY.gu.m();
    m.identity(@_modelMtx);
    m.multiply(cameraMtx, @_modelMtx, @_mvpMtx);
    
    # Uniform変数設定
    MY.gu.attachUniform(@_gl, @_prg, "alpha", "float", MY.param.alpha * 0.01);
    MY.gu.attachUniform(@_gl, @_prg, "mvpMatrix", "mat4", @_mvpMtx);
    MY.gu.attachUniform(@_gl, @_prg, "speed", "floatarray", [time * MY.param.speed0 * 0.001, time * MY.param.speed1 * 0.001, time * MY.param.speed2 * 0.001]);
    MY.gu.attachUniform(@_gl, @_prg, "offset", "floatarray", [MY.param.offset0, MY.param.offset1, MY.param.offset2]);
    
    # テクスチャ送信
    for val,i in @_texture
      @_gl.activeTexture(@_gl["TEXTURE" + String(i)]);
      @_gl.bindTexture(@_gl.TEXTURE_2D, val);
      MY.gu.attachUniform(@_gl, @_prg, "texture" + String(i), "int", i);
    
    # Attribute変数設定
    @_gl.bindBuffer(@_gl.ELEMENT_ARRAY_BUFFER, @_ibo);
    MY.gu.attachVBO(@_gl, @_vbo.position);
    MY.gu.attachVBO(@_gl, @_vbo.texCoord);
    
    @_gl.drawElements(@_gl.TRIANGLES, @_model.i.length, @_gl.UNSIGNED_SHORT, 0);







module.exports = PartialDraw;