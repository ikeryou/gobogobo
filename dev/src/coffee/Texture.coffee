

# ---------------------------------------------------
# WebGLテクスチャデータ管理クラス
# ---------------------------------------------------
class Texture
  
  
  # -----------------------------------------------
  # コンストラクタ
  # -----------------------------------------------
  constructor: (gl, src, id, param)->
    
    # WebGLコンテキスト
    @_gl = gl;
    
    # テクスチャユニットID
    @id = id;
    
    # テクスチャユニット
    @texId = @_gl["TEXTURE" + String(@id)];
    
    # 画像src
    @_src = src;
    
    # 画像オブジェクト
    @_img;
    
    # WebGLテクスチャオブジェクト
    @t = null;
    
    # テクスチャパラメータ
    # TEXTURE_MAG_FILTER(拡大時の補間方法、下ほど品質高)
    #   : NEAREST
    #   : LINEAR
    #
    # TEXTURE_MIN_FILTER(縮小時の補間方法、下ほど品質高)
    #   : NEAREST
    #   : LINEAR
    #   : NEAREST_MIPMAP_NEAREST
    #   : NEAREST_MIPMAP_LINEAR
    #   : LINEAR_MIPMAP_NEAREST
    #   : LINEAR_MIPMAP_LINEAR
    #
    # TEXTURE_WRAP_S,TEXTURE_WRAP_T(範囲外のテクスチャ座標の扱い、横縦)
    #   : REPEAT          (範囲外の値に対し繰り返し処理	1.25 = 0.25 : -0.25 = 0.75)
    #   : MIRRORED_REPEAT (範囲外の値を対照的に繰り返し処理	1.25 = 0.75 : -0.25 = 0.25)
    #   : CLAMP_TO_EDGE   (値を 0 ～ 1 の範囲内に収まるようクランプ	1.25 = 1.00 : -0.25 = 0.00)
    @_param = param || {};
    
    @_init();
  
  
  # -----------------------------------------------
  # 初期化
  # -----------------------------------------------
  _init: =>
    
    # 画像の読み込み
    @_img = new Image();
    @_img.onload = @_eLoad;
    @_img.src = @_src;
  
  
  
  # -----------------------------------------------
  # イベント 画像読み込み完了
  # -----------------------------------------------
  _eLoad: =>
    
    @t = @_gl.createTexture();
    
    # テクスチャをバインドする
    @_gl.bindTexture(@_gl.TEXTURE_2D, @t);
    
    # テクスチャへイメージを適用
    @_gl.texImage2D(@_gl.TEXTURE_2D, 0, @_gl.RGBA, @_gl.RGBA, @_gl.UNSIGNED_BYTE, @_img);
    
    # パラメータ指定
    for key,val of @_param
      @_gl.texParameteri(@_gl.TEXTURE_2D, @_gl[key], @_gl[val]);
    
    # ミップマップを生成
    @_gl.generateMipmap(@_gl.TEXTURE_2D);
    
    # テクスチャのバインドを無効化
    @_gl.bindTexture(@_gl.TEXTURE_2D, null);




















module.exports = Texture;