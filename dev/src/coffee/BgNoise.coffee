Texture = require('./Texture');


# ---------------------------------------------------
# 背景 / ノイズ
# ---------------------------------------------------
class BgNoise
  
  
  constructor: (gl) ->
    
    @_gl = gl;
    
    # モデルデータ
    @_model;
    
    # プログラムオブジェクト
    @_prg;
    
    # フレームバッファオブジェクト
    @_fBuffer;
    
    # スマホ用ノイズテクスチャ
    @_noiseTexture;
    
    # VBO
    @_vbo = {};
    
    # IBO
    @_ibo;
  
  
  
  # -----------------------------------------------
  # 初期化
  # -----------------------------------------------
  init: =>
    
    # スマホ用ノイズテクスチャ
    if MY.u.isSmt()
      @_noiseTexture = new Texture(@_gl, MY.conf.PATH_IMG + "/noise.jpg", 0);
    
    # プレーンなモデルデータ作成
    @_model = MY.gu.planeModelData();
    
    # プログラムオブジェクト
    @_prg = MY.gu.createProgram(@_gl, MY.gu.createShader(@_gl, 'vNoise'), MY.gu.createShader(@_gl, 'fNoise'));
    
    # VBO作成
    @_vbo.position = MY.gu.createVBO(@_gl, @_prg, "position", 3, @_model.p);
    
    # IBO作成
    @_ibo = MY.gu.createIBO(@_gl, @_model.i);
  
  
  
  # -----------------------------------------------
  # ノイズ作成
  # -----------------------------------------------
  create: (w, h) =>
    
    # スマホは作らない
    if @_noiseTexture?
      return;
    
    # フレームバッファオブジェクト作成
    @_fBuffer = MY.gu.createFramebuffer(@_gl, w, h);
    
    # 書き込み先指定
    @_gl.bindFramebuffer(@_gl.FRAMEBUFFER, @_fBuffer.f);
    
    # バッファ初期化
    @_gl.clear(@_gl.COLOR_BUFFER_BIT);
    
    # シェーダ選択
    MY.gu.attachProgram(@_gl, @_prg);
    
    MY.gu.attachUniform(@_gl, @_prg, "resolution", "vec2", [w, h]);
    MY.gu.attachUniform(@_gl, @_prg, "offset", "vec2", [MY.u.range(w), MY.u.range(h)]);
    
    @_gl.bindBuffer(@_gl.ELEMENT_ARRAY_BUFFER, @_ibo);
    MY.gu.attachVBO(@_gl, @_vbo.position);
    @_gl.drawElements(@_gl.TRIANGLES, @_model.i.length, @_gl.UNSIGNED_SHORT, 0);
    
    # 書き込み先初期化
    @_gl.bindFramebuffer(@_gl.FRAMEBUFFER, null);
  
  
  
  # -----------------------------------------------
  # ノイズ書き込んだテクスチャを取得
  # -----------------------------------------------
  texture: =>
    
    if @_noiseTexture?
      return @_noiseTexture.t;
    else
      return @_fBuffer.t;









module.exports = BgNoise;