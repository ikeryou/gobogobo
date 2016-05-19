

# ---------------------------------------------------
# 共通関数
# ---------------------------------------------------
class Func
  
  
  # -----------------------------------------------
  # コンストラクタ
  # -----------------------------------------------
  constructor: ->
  
  
  
  
  
  
  
  
  
  # ------------------------------------
  # ログ
  # ------------------------------------
  log: (params...) =>
    
    if MY.conf.FLG.LOG
      if console? && console.log? then console.log(params...);
  
  
  
  # -----------------------------------
  # ページビューのトラッキング GA
  # -----------------------------------
  trackPageView: (url) =>
    
    if ga?
      @log("##################### trackPageView::", url);
      ga('send', 'pageview', url);
  
  
  
  # -----------------------------------------------
  # 画面のスクロールのON/OFF
  # -----------------------------------------------
  setScroll: (bool) =>
    
    if bool == false
      $(window).on('touchmove.noScroll', (e) =>
        e.preventDefault();
      );
    else
      $(window).off('touchmove.noScroll');
  
  
  
  # ------------------------------------
  # ポストエフェクト用geometry取得
  # ------------------------------------
  getPEGeo: (w, h) =>
    
    geo = new THREE.BufferGeometry();
    geo.addAttribute('index', new THREE.BufferAttribute(new Uint16Array(3 * 2), 1));    
    geo.addAttribute('position', new THREE.BufferAttribute(new Float32Array(3 * 4), 3));
    geo.addAttribute('uv', new THREE.BufferAttribute(new Float32Array(2 * 4), 2));
    
    # 位置
    pos = geo.attributes.position.array;
    pos[0]  = -w * 0.5;
    pos[1]  = -h * 0.5;
    pos[2]  = 0;
    pos[3]  = w * 0.5;
    pos[4]  = -h * 0.5;
    pos[5]  = 0;
    pos[6]  = w * 0.5;
    pos[7]  = h * 0.5;
    pos[8]  = 0;
    pos[9]  = -w * 0.5;
    pos[10] = h * 0.5;
    pos[11] = 0;
    
    # 頂点インデックス
    index = geo.attributes.index.array;
    index[0] = 0;
    index[1] = 1;
    index[2] = 2;
    index[3] = 0;
    index[4] = 2;
    index[5] = 3;
    
    # UV
    uv = geo.attributes.uv.array;
    uv[0] = 0;
    uv[1] = 0;
    uv[2] = 1;
    uv[3] = 0;
    uv[4] = 1;
    uv[5] = 1;
    uv[6] = 0;
    uv[7] = 1;
    
    return geo;









module.exports = Func;