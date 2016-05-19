Rect       = require('./libs/object/Rect');
BaseFilter = require('./BaseFilter');


# ---------------------------------------------------
# カラー調整フィルタ
# ---------------------------------------------------
class ColorCorrectionFilter extends BaseFilter
  
  
  constructor: (gl) ->
    
    super(gl, {v:"vColorCorrection", f:"fColorCorrection"});
    
    @_powRGB = [1, 1, 1];
    @_mulRGB = [1, 1, 1];
  
  
  
  # -----------------------------------------------
  # uniform変数の設定
  # -----------------------------------------------
  _attachUniform: =>
    
    MY.gu.attachUniform(@_gl, @_prg, "mvpMatrix", "mat4", @_mvpMtx);
    MY.gu.attachUniform(@_gl, @_prg, "resolution", "vec2", [@_drawSize.w, @_drawSize.h]);
    MY.gu.attachUniform(@_gl, @_prg, "powRGB", "vec3", @_powRGB);
    MY.gu.attachUniform(@_gl, @_prg, "mulRGB", "vec3", @_mulRGB);
  
  
  
  # -----------------------------------------------
  # 
  # -----------------------------------------------
  posRGB: (r, g, b) =>
    
    @_powRGB = [r, g, b];
  
  
  
  # -----------------------------------------------
  # 
  # -----------------------------------------------
  mulRGB: (r, g, b) =>
    
    @_mulRGB = [r, g, b];









module.exports = ColorCorrectionFilter;