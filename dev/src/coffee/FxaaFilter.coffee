BaseFilter = require('./BaseFilter');


# ---------------------------------------------------
# アンチエイリアス
# ---------------------------------------------------
class FxaaFilter extends BaseFilter
  
  
  constructor: (gl) ->
    
    super(gl, {v:"vFXAA", f:"fFXAA"});
    
    @_powRGB = [1, 1, 1];
    @_mulRGB = [1, 1, 1];
  
  
  
  # -----------------------------------------------
  # uniform変数の設定
  # -----------------------------------------------
  _attachUniform: =>
    
    MY.gu.attachUniform(@_gl, @_prg, "mvpMatrix", "mat4", @_mvpMtx);
    MY.gu.attachUniform(@_gl, @_prg, "resolution", "vec2", [1/@_drawSize.w, 1/@_drawSize.h]);
    MY.gu.attachUniform(@_gl, @_prg, "reduceMin", "float", 1/128);
    MY.gu.attachUniform(@_gl, @_prg, "reduceMul", "float", 1/8);
    MY.gu.attachUniform(@_gl, @_prg, "spanMax", "float", 8);







module.exports = FxaaFilter;