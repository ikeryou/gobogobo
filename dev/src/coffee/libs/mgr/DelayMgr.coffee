BaseMgr = require('./BaseMgr')


# ---------------------------------------------------
# 遅延実行関数管理クラス
# ---------------------------------------------------
class DelayMgr extends BaseMgr
  
  
  # -----------------------------------------------
  # コンストラクタ
  # -----------------------------------------------
  constructor: ->
    
    super();
    
    @_registFunc = [];
    
    # 初期化
    @_init();
  
  
  
  # -----------------------------------------------
  # 初期化
  # -----------------------------------------------
  _init: =>
    
    super();
  
  
  
  # -----------------------------------------------
  # 破棄
  # -----------------------------------------------
  dispose: ->
    
    @_registFunc = null;
  
  
  
  # -----------------------------------------------
  # リセット
  # -----------------------------------------------
  reset: ->
  
    @_registFunc = [];
  
  
  
  # -----------------------------------------------
  # 実行したい関数を登録
  # @func  : 関数
  # @delay : このフレーム後に実行
  # -----------------------------------------------
  add: (func, delay) ->
    
    #@_registFunc = @_sliceNull(@_registFunc);
    @_registFunc.push({
      f:func,
      d:Number(delay),
      d2:Number(delay),
      flg:true
    });
  
  
  
  # -----------------------------------------------
  # 実行したい関数を削除
  # @func : 関数
  # -----------------------------------------------
  remove: (func) ->
  
    arr = [];
    for val, i in @_registFunc
      if val.f != func
        arr.push(val);
    @_registFunc = arr;
  
  
  
  # -----------------------------------------------
  # 更新
  # -----------------------------------------------
  update: =>
    
    for val,i in @_registFunc
      if val? && val.flg && --val.d <= 0
        val.f();
        val.flg = false;
        #@_registFunc[i] = null;
        #console.log("call", val.d2);
  
  
  
  # nullを削除した配列を返す
  # -----------------------------------
  # @arr : 配列(Array)
  # return : null削除した配列(Array)
  # -----------------------------------
  _sliceNull: (arr) ->
  
    newArr = [];
    for val,i in arr
      if val != null
        newArr.push(val);
        
    return newArr;













module.exports = DelayMgr;