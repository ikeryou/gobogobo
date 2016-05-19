Rect = require('./libs/object/Rect');


# ---------------------------------------------------
# 基本フィルタ
# フィルタ系のクラスはこのクラスを継承
# ---------------------------------------------------
class BaseFilter
  
  
  constructor: (gl, shader) ->
    
    @_gl = gl;
    @_shader = shader; # f:"", v:""
    
    # モデルデータ
    @_model;
    
    # モデル用行列オブジェクト
    @_modelMtx;
    
    # シェーダ送信用行列オブジェクト
    @_mvpMtx;
    
    # プログラムオブジェクト
    @_prg;
    
    # フィルタ適応させるテクスチャ
    @_texture;
    
    # 描画サイズ
    @_drawSize = new Rect();
    
    # 書き込み先
    @_frameBuffer;
    
    # VBO
    @_vbo = {};
    
    # IBO
    @_ibo;
  
  
  
  # -----------------------------------------------
  # 初期化
  # -----------------------------------------------
  init: =>
    
    # モデル用行列オブジェクト
    @_modelMtx = MY.gu.createMatrix();
    
    # シェーダ送信用行列オブジェクト
    @_mvpMtx = MY.gu.createMatrix();
    
    # プログラムオブジェクト
    @_prg = MY.gu.createProgram(@_gl, MY.gu.createShader(@_gl, @_shader.v), MY.gu.createShader(@_gl, @_shader.f));
    
    # プレーンなモデルデータ作成
    @_model = MY.gu.planeModelData();
    
    # VBO作成
    @_vbo.position = MY.gu.createVBO(@_gl, @_prg, "position", 3, @_model.p);
    
    # IBO作成
    @_ibo = MY.gu.createIBO(@_gl, @_model.i);
  
  
  
  # -----------------------------------------------
  # 描画時のサイズ設定
  # -----------------------------------------------
  canvasSize: (w, h) =>
    
    @_drawSize.w = w;
    @_drawSize.h = h;
    
    @_frameBuffer = MY.gu.createFramebuffer(@_gl, @_drawSize.w, @_drawSize.h);
  
  
  
  # -----------------------------------------------
  # テクスチャ登録
  # -----------------------------------------------
  attachTexture: (texture) =>
    
    @_texture = texture;
  
  
  
  # -----------------------------------------------
  # 描画
  # -----------------------------------------------
  draw: (cameraMtx, isDrawMainBuffer) =>
    
    # 書き込み先設定
    if isDrawMainBuffer
      @_gl.bindFramebuffer(@_gl.FRAMEBUFFER, null);
    else
      @_gl.bindFramebuffer(@_gl.FRAMEBUFFER, @_frameBuffer.f);
    
    # バッファ初期化
    @_gl.clear(@_gl.COLOR_BUFFER_BIT | @_gl.DEPTH_BUFFER_BIT);
    
    # シェーダ選択
    MY.gu.attachProgram(@_gl, @_prg);
    
    # シェーダ送信用行列の更新
    m = MY.gu.m();
    m.identity(@_modelMtx);
    m.multiply(cameraMtx, @_modelMtx, @_mvpMtx);
    
    # uniform変数設定
    @_attachUniform();
    
    # テクスチャ設定
    @_gl.activeTexture(@_gl.TEXTURE0);
    @_gl.bindTexture(@_gl.TEXTURE_2D, @_texture);
    MY.gu.attachUniform(@_gl, @_prg, "texture", "int", 0);
    
    # attribute変数登録
    @_gl.bindBuffer(@_gl.ELEMENT_ARRAY_BUFFER, @_ibo);
    MY.gu.attachVBO(@_gl, @_vbo.position);
    
    @_gl.drawElements(@_gl.TRIANGLES, @_model.i.length, @_gl.UNSIGNED_SHORT, 0);
    
    # 書き込み先初期化
    @_gl.bindFramebuffer(@_gl.FRAMEBUFFER, null);
  
  
  
  # -----------------------------------------------
  # uniform変数の設定
  # -----------------------------------------------
  _attachUniform: =>
    
    MY.gu.attachUniform(@_gl, @_prg, "mvpMatrix", "mat4", @_mvpMtx);
    MY.gu.attachUniform(@_gl, @_prg, "resolution", "vec2", [@_drawSize.w, @_drawSize.h]);
  
  
  
  # -----------------------------------------------
  # 書き込み先のテクスチャの取得
  # -----------------------------------------------
  texture: =>
    
    return @_frameBuffer.t;









module.exports = BaseFilter;