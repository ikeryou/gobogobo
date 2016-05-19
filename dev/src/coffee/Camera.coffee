

# ---------------------------------------------------
# カメラ
# ビュー座標変換、プロジェクション座標変換の管理
# ---------------------------------------------------
class Camera
  
  
  constructor: (fov) ->
    
    # カメラ位置
    @_cameraPosition = {x:0, y:0, z:0};
    
    @_fov = fov || 45;
    
    @_vMtx;
    @_pMtx;
    @_pvMtx;
  
  
  
  # -----------------------------------------------
  # 初期化
  # -----------------------------------------------
  init: =>
    
    @_vMtx  = MY.gu.createMatrix();
    @_pMtx  = MY.gu.createMatrix();
    @_pvMtx = MY.gu.createMatrix();
  
  
  
  # -----------------------------------------------
  # 座標変換適応
  # -----------------------------------------------
  updateMatrix: (canvasWidth, canvasHeight) =>
    
    m = MY.gu.m();
    m.lookAt([@_cameraPosition.x, @_cameraPosition.y, @_cameraPosition.z], [0,0,0], [0,1,0], @_vMtx);
    m.perspective(@_fov, canvasWidth / canvasHeight, 0.1, 10000, @_pMtx);
    m.multiply(@_pMtx, @_vMtx, @_pvMtx);
  
  
  
  # -----------------------------------------------
  # ビューとプロジェクションを掛け合わせたマトリクスオブジェクトを取得
  # -----------------------------------------------
  pvMatrix: =>
    
    return @_pvMtx;
  
  
  
  # -----------------------------------------------
  # カメラ位置
  # -----------------------------------------------
  cameraPosition: (x, y, z) =>
    
    if x? || y? || z?
      @_cameraPosition.x = x;
      @_cameraPosition.y = y;
      @_cameraPosition.z = z;
    else
      return @_cameraPosition;
  
  
  
  # -----------------------------------------------
  # カメラ位置をピクセル等倍に
  # -----------------------------------------------
  pixel: (canvasHeight) =>
    
    @_cameraPosition.z = (canvasHeight / 2) / Math.tan((@_fov * Math.PI / 180) / 2);
  
  
  
  # -----------------------------------------------
  # fov取得、設定
  # -----------------------------------------------
  fov: (val) =>
    
    if val?
      @_fov = val;
    else
      return @_fov;





module.exports = Camera;