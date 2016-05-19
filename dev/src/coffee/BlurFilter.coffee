Rect       = require('./libs/object/Rect');
BaseFilter = require('./BaseFilter');


# ---------------------------------------------------
# ぼかしフィルタ
# ---------------------------------------------------
class BlurFilter extends BaseFilter
  
  
  constructor: (gl) ->
    
    super(gl, {v:"vBlur", f:"fBlur"});










module.exports = BlurFilter;