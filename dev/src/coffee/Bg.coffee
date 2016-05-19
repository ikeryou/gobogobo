Camera                = require('./Camera');
FrameBuffer           = require('./FrameBuffer');
BlurFilter            = require('./BlurFilter');
FxaaFilter            = require('./FxaaFilter');
GlitchFilter          = require('./GlitchFilter');
ColorCorrectionFilter = require('./ColorCorrectionFilter');
BgNoise               = require('./BgNoise');
PartialDraw           = require('./PartialDraw');
BgLines               = require('./BgLines');
BgDots                = require('./BgDots');


# ---------------------------------------------------
# 背景
# ---------------------------------------------------
class Bg
  
  
  # -----------------------------------------------
  # コンストラクタ
  # -----------------------------------------------
  constructor: (id) ->
    
    @_id = id || "xBg";
    
    # Canvas要素
    @_c;
    
    # WebGLコンテキスト
    @_gl;
    
    # カメラ
    @_camera;
    
    # メインとなる輪っかのモチーフ
    @_lines;
    
    # ドット
    @_dots;
    
    # キャプチャー管理オブジェクト
    @_capture;
    
    # カラー調整フィルタ
    @_colorFilter = [];
    
    # FXAAフィルタ
    @_fxaa;
    
    # グリッチフィルタ
    @_glitch;
    
    # ノイズ生成オブジェクト
    @_noise;
    @_noiseGlitch;
    
    # 部分描画オブジェクト
    @_partial;
    
    @_colors = [];
  
  
  
  # -----------------------------------------------
  # 初期化
  # -----------------------------------------------
  init: =>
    
    # Canvas要素取得
    @_c = document.getElementById(@_id);
    
    # WebGLコンテキスト取得
    @_gl = MY.gu.getGlContext(@_id);
    
    # 深度テスト有効
    @_gl.enable(@_gl.DEPTH_TEST);
    @_gl.depthFunc(@_gl.LEQUAL);
    
    # ブレンディング有効
    @_gl.enable(@_gl.BLEND);
    @_gl.blendFuncSeparate(@_gl.SRC_ALPHA, @_gl.ONE_MINUS_SRC_ALPHA, @_gl.ONE, @_gl.ONE);
    
    @_gl.clearColor(0,0,0,1);
    
    # カリング有効に
    @_gl.enable(@_gl.CULL_FACE);
    
    # カメラ
    @_camera = new Camera(45);
    @_camera.init();
    
    # メインとなる輪っかのモチーフ
    @_lines = new BgLines(@_gl);
    @_lines.init();
    
    # ドット
    @_dots = new BgDots(@_gl);
    @_dots.init();
    
    # カラー調整フィルタ
    i = 0;
    num = 3;
    while i < num
      color = new ColorCorrectionFilter(@_gl);
      color.init();
      @_colorFilter.push(color);
      i++;
    
    # ノイズ生成オブジェクト
    @_noise = new BgNoise(@_gl);
    @_noise.init();
    @_noiseGlitch = new BgNoise(@_gl);
    @_noiseGlitch.init();
    
    # グリッチフィルタ
    @_glitch = new GlitchFilter(@_gl);
    @_glitch.init();
    
    # キャプチャー管理オブジェクト
    @_capture = new FrameBuffer(@_gl);
    @_capture.init();
    
    # 部分描画
    @_partial = new PartialDraw(@_gl);
    @_partial.init();
    
    i = 0;
    while i < 9
      @_colors.push({
        key:MY.u.range(1000) * 0.001,
        val:0
      });
      i++;
    
    MY.resize.add(@_resize, true);
    MY.update.add(@_update);
    
    # パラメータのドット数変えたら
    MY.param.addCallBack("dotNum", =>
      @_resize(MY.resize.sw(), MY.resize.sh());
    );
  
  
  
  # -----------------------------------
  # リサイズ
  # -----------------------------------
  _resize: (w, h) =>
    
    if window.devicePixelRatio? && window.devicePixelRatio >= 2
      scale1 = 2;
      scale2 = 1;
    else
      scale1 = 1;
      scale2 = 1;
      
    @_c.width = w * scale1;
    @_c.height = h * scale1;
    $("#" + @_id).css({
      width:w * scale2, 
      height:h * scale2
    });
    @_gl.viewport(0, 0, @_c.width, @_c.height);
    
    # ピクセル等倍にする
    @_camera.pixel(@_c.height);
    
    
    w = @_c.width;
    h = @_c.height;
    
    # 輪っかのサイズ
    @_lines.canvasSize(w, h);
    
    # ドットの位置サイズ
    @_dots.createDots(w, h);
    
    # キャプチャーエリアのサイズ設定
    @_capture.canvasSize(w, h);
    
    # フィルタの描画サイズ設定
    for val,i in @_colorFilter
      val.canvasSize(w, h);
    
    @_glitch.canvasSize(w, h);
    
    # ノイズ作成
    @_noise.create(w, h);
    @_noiseGlitch.create(@_c.width, @_c.height);
  
  
  
  
  # -----------------------------------
  # 色変更
  # -----------------------------------
  _updateColor: =>
    
    for val,i in @_colors
      val.val = MY.u.map(Math.sin(MY.u.radian(i * val.key + MY.update.cnt * val.key)), 0, 50, -1, 1);
    
    MY.param.r0 = @_colors[0].val;
    MY.param.g0 = @_colors[1].val;
    MY.param.b0 = @_colors[2].val;
    MY.param.r1 = @_colors[3].val;
    MY.param.g1 = @_colors[4].val;
    MY.param.b1 = @_colors[5].val;
    MY.param.r2 = @_colors[6].val;
    MY.param.g2 = @_colors[7].val;
    MY.param.b2 = @_colors[8].val;
  
  
  
  # -----------------------------------
  # update
  # -----------------------------------
  _update: =>
    
    # 色変更
    @_updateColor();
    
    
    
    
    # カメラの設定
    @_camera.updateMatrix(@_c.width, @_c.height);
    
    
#     @_gl.bindFramebuffer(@_gl.FRAMEBUFFER, null);
#     @_gl.clearColor(0,0,0,1);
#     @_gl.clear(@_gl.COLOR_BUFFER_BIT | @_gl.DEPTH_BUFFER_BIT);
    #@_mountain.attachNoiseTexture(@_noise.texture());
    #@_mountain.draw(@_camera.pvMatrix());
    
    
    
    
    # キャプチャ開始
    @_capture.startCapture();
    
    # 輪っか描画
    @_lines.draw(@_camera.pvMatrix());
    
    # ドットの描画
    if MY.param.dot
      @_dots.draw(@_camera.pvMatrix());
    
    # キャプチャ終了
    @_capture.stopCapture();
    
    # 色の調整 1
    @_colorFilter[0].attachTexture(@_capture.texture());
    @_colorFilter[0].mulRGB(MY.param.r0 * 0.1, MY.param.g0 * 0.1, MY.param.b0 * 0.1);
    @_colorFilter[0].draw(MY.gu.orthoMatrix());
    
    # 色の調整 2
    @_colorFilter[1].attachTexture(@_capture.texture());
    @_colorFilter[1].mulRGB(MY.param.r1 * 0.1, MY.param.g1 * 0.1, MY.param.b1 * 0.1);
    @_colorFilter[1].draw(MY.gu.orthoMatrix());
    
    # 色の調整 3
    @_colorFilter[2].attachTexture(@_capture.texture());
    @_colorFilter[2].mulRGB(MY.param.r2 * 0.1, MY.param.g2 * 0.1, MY.param.b2 * 0.1);
    @_colorFilter[2].draw(MY.gu.orthoMatrix());
    
    # 部分描画の結果をメインバッファに描画
    
    # 結果をキャプチャ
    @_capture.startCapture();
    
    #@_gl.bindFramebuffer(@_gl.FRAMEBUFFER, null);
    @_partial.attachTexture(
      @_colorFilter[0].texture(),
      @_colorFilter[1].texture(),
      @_colorFilter[2].texture(),
      @_noise.texture()
    );
    @_partial.draw(MY.gu.orthoMatrix());
    
    @_capture.stopCapture();
    
    # グリッチフィルタ
    # メインバッファに描画
    @_glitch.attachNoiseTexture(@_noiseGlitch.texture());
    @_glitch.attachTexture(@_capture.texture());
    @_glitch.draw(MY.gu.orthoMatrix(), true);
    
    # コンテキストの再描画
    @_gl.flush();





























module.exports = Bg;