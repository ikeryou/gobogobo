Rect = require('./libs/object/Rect');


# ---------------------------------------------------
# キャプチャーオブジェクト
# ---------------------------------------------------
class FrameBuffer
  
  
  constructor: (gl) ->
    
    @_gl = gl;
    @_frameBuffer;
  
  
  
  # -----------------------------------------------
  # 初期化
  # -----------------------------------------------
  init: =>
  
  
  
  # -----------------------------------------------
  # レンダリング領域のサイズ設定
  # -----------------------------------------------
  canvasSize: (w, h) =>
    
    # フレームバッファオブジェクト作成
    @_frameBuffer = MY.gu.createFramebuffer(@_gl, w, h);
  
  
  
  # -----------------------------------------------
  # テクスチャへの書き込み開始
  # -----------------------------------------------
  startCapture: =>
    
    @_gl.bindFramebuffer(@_gl.FRAMEBUFFER, @_frameBuffer.f);
    
    # バッファ初期化
    @_gl.blendFuncSeparate(@_gl.SRC_ALPHA, @_gl.ONE_MINUS_SRC_ALPHA, @_gl.ONE, @_gl.ONE);
    @_gl.clear(@_gl.COLOR_BUFFER_BIT | @_gl.DEPTH_BUFFER_BIT);
  
  
  
  # -----------------------------------------------
  # テクスチャへの書き込み終了
  # -----------------------------------------------
  stopCapture: =>
    
    @_gl.bindFramebuffer(@_gl.FRAMEBUFFER, null);
  
  
  
  # -----------------------------------------------
  # テクスチャの取得
  # -----------------------------------------------
  texture: =>
    
    return @_frameBuffer.t;









module.exports = FrameBuffer;