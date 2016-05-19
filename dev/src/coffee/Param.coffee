

# ---------------------------------------------------
# パラメータ管理
# ---------------------------------------------------
class Param
  
  
  # -----------------------------------------------
  # コンストラクタ
  # -----------------------------------------------
  constructor: ->
    
    @_gui;
    
    @speed0 = 50;
    @speed1 = 75;
    @speed2 = 100;
    
    @offset0 = 10;
    @offset1 = 5;
    @offset2 = 15;
    
    @r0 = 16;
    @g0 = 9;
    @b0 = 12;
    
    @r1 = 18;
    @g1 = 22;
    @b1 = 33;
    
    @r2 = 12;
    @g2 = 21;
    @b2 = 60;
    
    @alpha = 100;
    @lineAlpha = 10;
    
    @speed = 250;
    @dotRange = 12;
    @dotSize = 100;
    @dotNum = 300;
    
    @line = true;
    @mountain = false;
    @dot = true;
    @lineMove = true;
    
    @distortionR = 0;
    @distortionG = 0;
    @distortionB = 0;
    
    @callBack = {};
    
    
    @_init();
  
  
  
  # -----------------------------------------------
  # 初期化
  # -----------------------------------------------
  _init:  =>
    
    # スマホは調整
    if MY.u.isSmt()
      @dotSize = 150;
      @dotNum  = 100;
    
    
    if MY.conf.FLG.PARAM && !MY.u.isSmt()
    
      @_gui = new dat.GUI();
      
#       @_setGuiNum("r0", 0, 100, 1);
#       @_setGuiNum("g0", 0, 100, 1);
#       @_setGuiNum("b0", 0, 100, 1);
#       
#       @_setGuiNum("r1", 0, 100, 1);
#       @_setGuiNum("g1", 0, 100, 1);
#       @_setGuiNum("b1", 0, 100, 1);
#       
#       @_setGuiNum("r2", 0, 100, 1);
#       @_setGuiNum("g2", 0, 100, 1);
#       @_setGuiNum("b2", 0, 100, 1);
      
#       @_setGuiNum("alpha", 0, 100, 1);
#       @_setGuiNum("lineAlpha", 0, 100, 1);
#       @_setGuiNum("speed", -500, 500, 1);
      
      @_setGuiBool("line");
      #@_setGuiBool("mountain");
      @_setGuiBool("dot");
      #@_setGuiBool("lineMove");
      
      @_setGuiNum("dotRange", 1, 20, 1);
      @_setGuiNum("dotSize", 1, 400, 1);
      #@_setGuiNum("dotNum", 50, 500, 1);
      
#       @_setGuiNum("distortionR", 0, 200, 1);
#       @_setGuiNum("distortionG", 0, 200, 1);
#       @_setGuiNum("distortionB", 0, 200, 1);
      
#       @_setGuiNum("speed0", 0, 100, 1);
#       @_setGuiNum("speed1", 0, 100, 1);
#       @_setGuiNum("speed2", 0, 100, 1);
#       
#       @_setGuiNum("offset0", 0, 20, 1);
#       @_setGuiNum("offset1", 0, 20, 1);
#       @_setGuiNum("offset2", 0, 20, 1);
  
  
  
  # -----------------------------------------------
  # 
  # -----------------------------------------------
  _setGuiNum: (name, min, max, step) =>
    
    @_gui.add(@, name, min, max).step(step).listen().onFinishChange((e) =>
      @[name] = e;
      @_callBack(name);
    );
  
  
  
  # -----------------------------------------------
  # 
  # -----------------------------------------------
  _setGuiNum2: (name, min, max, step) =>
    
    @_gui.add(@, name, min, max).step(step).onChange((e) =>
      @[name] = e;
      @_callBack(name);
    );
  
  
  
  # -----------------------------------------------
  # 
  # -----------------------------------------------
  _setGuiBool: (name) =>
    
    @_gui.add(@, name).onFinishChange((e) =>
      @[name] = e;
      @_callBack(name);
    );
  
  
  
  # -----------------------------------------------
  # 
  # -----------------------------------------------
  _setGuiListen: (name) =>
    
    @_gui.add(@, name).listen().onFinishChange((e) =>
      @[name] = e;
      @_callBack(name);
    );
  
  
  
  # -----------------------------------------------
  # コールバック実行
  # -----------------------------------------------
  _callBack: (name) =>
    
    if @callBack[name]?
      for val,i in @callBack[name]
        if val?
          val();
  
  
  
  # -----------------------------------------------
  # コールバック登録
  # -----------------------------------------------
  addCallBack: (name, func) =>
    
    if !@callBack[name]?
      @callBack[name] = [];
    
    @callBack[name].push(func);






module.exports = Param;