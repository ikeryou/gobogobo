Rect       = require('./libs/object/Rect');
BaseFilter = require('./BaseFilter');


# ---------------------------------------------------
# グリッチフィルタ
# ---------------------------------------------------
class GlitchFilter extends BaseFilter
  
  
  constructor: (gl) ->
    
    super(gl, {v:"vGlitch", f:"fGlitch"});
    
    @_noiseTexture;
    @_distortion = [0, 0, 0];
  
  
  # -----------------------------------------------
  # uniform変数の設定
  # -----------------------------------------------
  _attachUniform: =>
    
    # ゆがみ
    if MY.u.isSmt()
      range = MY.u.map(Math.cos(MY.update.cnt * 0.02), 50, 200, -1, 1);
    else
      dx = MY.resize.sw();
      dy = MY.resize.sh();
      range = MY.u.map(MY.mouse.dist(0, 0), 0, 300, 0, Math.sqrt(dx * dx + dy * dy));
    
    #range = MY.u.map(Math.cos(MY.update.cnt * 0.02), 50, 200, -1, 1);
    #range = 100;
    #@_distortion[0] = Math.sin(MY.update.cnt * 0.1) * 100 * 0.001;
    for val,i in @_distortion
      @_distortion[i] = Math.sin((i * 2 + MY.update.cnt) * 0.05) * range * 0.001;
        
      #t = if MY.u.hit(20) then MY.u.range(500) * 0.001 else 0;
      #@_distortion[i] += (t - @_distortion[i]) * 0.1;
    
    MY.gu.attachUniform(@_gl, @_prg, "mvpMatrix", "mat4", @_mvpMtx);
    MY.gu.attachUniform(@_gl, @_prg, "resolution", "vec2", [@_drawSize.w, @_drawSize.h]);
    MY.gu.attachUniform(@_gl, @_prg, "distortion", "vec3", @_distortion);
    
    # ノイズテクスチャ渡す
    @_gl.activeTexture(@_gl.TEXTURE1);
    @_gl.bindTexture(@_gl.TEXTURE_2D, @_noiseTexture);
    MY.gu.attachUniform(@_gl, @_prg, "noiseTexture", "int", 1);
  
  
  
  # -----------------------------------------------
  # 
  # -----------------------------------------------
  attachNoiseTexture: (noiseTexture) =>
    
    @_noiseTexture = noiseTexture;



















module.exports = GlitchFilter;