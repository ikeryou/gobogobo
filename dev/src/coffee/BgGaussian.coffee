Rect       = require('./libs/object/Rect');
BgDotParts = require('./BgDotParts');


# ---------------------------------------------------
# 背景 / ぼかしフィルタを適応したテクスチャを描画
# ---------------------------------------------------
class BgGaussian
  
  
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
    
    # ぼかし適応前の書き込み先
    @_beforeFrameBuffer;
    
    # ぼかし適応後の書き込み先
    @_afterFrameBuffer;
    @_after2FrameBuffer;
    
    # 描画サイズ
    @_drawSize = new Rect();
    
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
    @_prg = MY.gu.createProgram(@_gl, MY.gu.createShader(@_gl, 'vGaussian'), MY.gu.createShader(@_gl, 'fGaussian'));
  
  
  
  # -----------------------------------------------
  # 描画時のサイズ設定
  # -----------------------------------------------
  canvasSize: (w, h) =>
    
    # フレームバッファオブジェクト作成
    @_drawSize.w = w;
    @_drawSize.h = h;
    @_beforeFrameBuffer = MY.gu.createFramebuffer(@_gl, @_drawSize.w, @_drawSize.h);
    @_afterFrameBuffer  = MY.gu.createFramebuffer(@_gl, @_drawSize.w, @_drawSize.h);
    @_after2FrameBuffer = MY.gu.createFramebuffer(@_gl, @_drawSize.w, @_drawSize.h);
    
    # プレーンなモデルデータ作成
    @_model = MY.gu.planeModelData(w, h);
    
    # VBO作成
    @_vbo.position = MY.gu.createVBO(@_gl, @_prg, "position", 3, @_model.p);
    @_vbo.texCoord = MY.gu.createVBO(@_gl, @_prg, "texCoord", 2, @_model.t);
    
    # IBO作成
    @_ibo = MY.gu.createIBO(@_gl, @_model.i);
  
  
  
  # -----------------------------------------------
  # テクスチャへの書き込み開始
  # -----------------------------------------------
  startCapture: =>
    
    @_gl.bindFramebuffer(@_gl.FRAMEBUFFER, @_beforeFrameBuffer.f);
    
    # バッファ初期化
    @_gl.clear(@_gl.COLOR_BUFFER_BIT | @_gl.DEPTH_BUFFER_BIT);
  
  
  
  # -----------------------------------------------
  # テクスチャへの書き込み終了
  # -----------------------------------------------
  stopCapture: =>
    
    @_gl.bindFramebuffer(@_gl.FRAMEBUFFER, null);
  
  
  
  # -----------------------------------------------
  # 描画
  # -----------------------------------------------
  draw: (cameraMtx) =>
    
    # シェーダ選択
    MY.gu.attachProgram(@_gl, @_prg);
    
    # シェーダ送信用行列の更新
    m = MY.gu.m();
    m.identity(@_modelMtx);
    m.multiply(cameraMtx, @_modelMtx, @_mvpMtx);
    
    # ぼかしフィルタ1回目
    @_gl.bindFramebuffer(@_gl.FRAMEBUFFER, @_afterFrameBuffer.f);
    
    # 1回目はバッファ初期化
    @_gl.clear(@_gl.COLOR_BUFFER_BIT | @_gl.DEPTH_BUFFER_BIT);
    
    # 1回目の書き込み
    @_render(true, @_beforeFrameBuffer.t);
    
    
    # ぼかしフィルタ2回目
    # 2回目はバッファの初期化なし
    @_gl.bindFramebuffer(@_gl.FRAMEBUFFER, @_after2FrameBuffer.f);
    
    # 2回目の書き込み
    @_render(false, @_afterFrameBuffer.t);
  
  
  
  # -----------------------------------------------
  # 
  # -----------------------------------------------
  _render: (horizontal, tex) =>
    
    MY.gu.attachUniform(@_gl, @_prg, "mvpMatrix", "mat4", @_mvpMtx);
    MY.gu.attachUniform(@_gl, @_prg, "horizontal", "int", horizontal);
    MY.gu.attachUniform(@_gl, @_prg, "weight", "floatarray", @_weight(100));
    MY.gu.attachUniform(@_gl, @_prg, "resolution", "vec2", [@_drawSize.w, @_drawSize.h]);
    
    @_gl.activeTexture(@_gl.TEXTURE0);
    @_gl.bindTexture(@_gl.TEXTURE_2D, tex);
    MY.gu.attachUniform(@_gl, @_prg, "texture", "int", 0);
    
    @_gl.bindBuffer(@_gl.ELEMENT_ARRAY_BUFFER, @_ibo);
    MY.gu.attachVBO(@_gl, @_vbo.position);
    MY.gu.attachVBO(@_gl, @_vbo.texCoord);
    
    @_gl.drawElements(@_gl.TRIANGLES, @_model.i.length, @_gl.UNSIGNED_SHORT, 0);
  
  
  
  # -----------------------------------------------
  # ぼかしの強さ
  # -----------------------------------------------
  _weight: (blurStrength) =>
    
    blurStrength = blurStrength || 50;
    
    weight = [];
    t = 0;
    d = blurStrength * blurStrength / 100;
    
    i = 0;
    while i < 10
      r = 1 + 2 * i;
      w = Math.exp(-0.5 * (r * r) / d);
      weight[i] = w;
      if i > 0
        w *= 2;
      t += w;
      i++;
    
    for val,i in weight
      weight[i] /= t;
    
    return weight;
  
  
  
  # -----------------------------------------------
  # テクスチャの取得
  # -----------------------------------------------
  texture: =>
    
    return {
      before:@_beforeFrameBuffer.t,
      after:@_after2FrameBuffer.t
    };









module.exports = BgGaussian;