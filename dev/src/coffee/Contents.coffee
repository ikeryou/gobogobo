DisplayTransform = require('./libs/display/DisplayTransform');
Bg = require('./Bg');


# ---------------------------------------------------
# コンテンツ
# ---------------------------------------------------
class Contents
  
  
  # -----------------------------------------------
  # コンストラクタ
  # -----------------------------------------------
  constructor: ->
    
    # 背景ダミー
    @_test;
    
    
    @_bg;
  
  
  
  # -----------------------------------------------
  # 初期化
  # -----------------------------------------------
  init: =>
    
    @_start();
  
  
  
  # -----------------------------------------------
  # コンテンツスタート
  # -----------------------------------------------
  _start: =>
    
    # 背景ダミー
#     @_test = new DisplayTransform({
#       id:"xTest";
#     });
#     @_test.init();
#     @_test.pivot("0px 0px");
    
    
    @_bg = new Bg("xBg");
    @_bg.init();
    
    $("#xBg").css({
      position:"absolute",
      top:0,
      left:0
    });
    
    #MY.resize.add(@_resize, true);
  
  
  
  # -----------------------------------
  # リサイズ
  # -----------------------------------
  _resize: (w, h) =>
    
    # 大きさをブラウザにFIXさせる
    scale = w / @_test.width();
    if @_test.height() * scale < h
      scale = h / @_test.height();
    @_test.scale(scale, scale);
    #@_test.visible(false);
    @_test.render();








module.exports = Contents;