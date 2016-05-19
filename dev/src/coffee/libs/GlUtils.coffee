

# ---------------------------------------------------
# WebGL Utilsクラス
# ---------------------------------------------------
class GlUtils
  
  constructor: ->
    
    # 行列計算オブジェクト
    @_m = new matIV();
  
  
  
  # -----------------------------------------------
  # 行列計算オブジェクト取得
  # -----------------------------------------------
  m: =>
    
    return @_m;
  
  
  
  # -----------------------------------------------
  # マトリクスオブジェクト作成
  # -----------------------------------------------
  createMatrix: =>
    
    return @_m.identity(@_m.create());
  
  
  
  # -----------------------------------------------
  # 正射影変換用行列オブジェクト取得
  # -----------------------------------------------
  orthoMatrix: =>
    
    v   = @createMatrix();
    p   = @createMatrix();
    tmp = @createMatrix();
    
    @_m.lookAt([0.0, 0.0, 0.5], [0.0, 0.0, 0.0], [0, 1, 0], v);
    @_m.ortho(-1.0, 1.0, 1.0, -1.0, 0.1, 1, p);
    @_m.multiply(p, v, tmp);
    
    return tmp;
  
  
  
  # -----------------------------------------------
  # WebGLコンテキスト取得
  # -----------------------------------------------
  getGlContext: (canvasId, param) =>
    
    c = document.getElementById(canvasId);
    return c.getContext('webgl', param) || c.getContext('experimental-webgl', param);
  
  
  
  # -----------------------------------
  # 使用するプログラムオブジェクトの設定
  # -----------------------------------
  attachProgram: (gl, usePrgObj) =>
    
    gl.useProgram(usePrgObj);
    return usePrgObj;
  
  
  
  # -----------------------------------------------
  # シェーダーの生成、コンパイル
  # -----------------------------------------------
  createShader: (gl, id) =>
    
    # HTMLからscriptタグへの参照を取得
    scriptElement = document.getElementById(id);
    
    # シェーダ作成
    shader = gl.createShader(if scriptElement.type == "x-shader/x-vertex" then gl.VERTEX_SHADER else gl.FRAGMENT_SHADER);
    
    # 生成されたシェーダにソースを割り当てる
    gl.shaderSource(shader, scriptElement.text);
    
    # シェーダをコンパイルする
    gl.compileShader(shader);
    
    # シェーダが正しくコンパイルされたかチェック
    if gl.getShaderParameter(shader, gl.COMPILE_STATUS)
      return shader;
    else
      console.log(gl.getShaderInfoLog(shader));
      return null;
  
  
  
  # -----------------------------------------------
  # プログラムオブジェクトの生成
  # -----------------------------------------------
  createProgram: (gl, vsObj, fsObj) =>
    
    # プログラムオブジェクトの生成
    program = gl.createProgram();
    
    # プログラムオブジェクトにシェーダを割り当てる
    gl.attachShader(program, vsObj);
    gl.attachShader(program, fsObj);
    
    # シェーダをリンク
    gl.linkProgram(program);
    
    # シェーダのリンクが正しく行なわれたかチェック
    if gl.getProgramParameter(program, gl.LINK_STATUS)
    
      # 成功していたらプログラムオブジェクトを有効にする
      #gl.useProgram(program);
      return program;
        
    else
      
      console.log(gl.getProgramInfoLog(program));
      return null;
  
  
  
  # -----------------------------------------------
  # VBOの作成
  # -----------------------------------------------
  createVBO: (gl, prg, name, attStride, data) =>
    
    vbo = gl.createBuffer();
    
    # バッファをバインドする
    gl.bindBuffer(gl.ARRAY_BUFFER, vbo);
    
    # バッファにデータをセット
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(data), gl.STATIC_DRAW);
    
    # バッファのバインドを無効化
    gl.bindBuffer(gl.ARRAY_BUFFER, null);
    
    
    
    
    return {
      obj:vbo,
      attLocation:gl.getAttribLocation(prg, name),
      attStride:attStride
    };
  
  
  
  # -----------------------------------------------
  # VBOの登録
  # -----------------------------------------------
  attachVBO: (gl, vbo) =>
    
    # VBOをバインドし登録
    gl.bindBuffer(gl.ARRAY_BUFFER, vbo.obj);
    gl.enableVertexAttribArray(vbo.attLocation);
    gl.vertexAttribPointer(vbo.attLocation, vbo.attStride, gl.FLOAT, false, 0, 0);
    
    gl.bindBuffer(gl.ARRAY_BUFFER, null);
  
  
  
  # -----------------------------------------------
  # IBOの作成
  # -----------------------------------------------
  createIBO: (gl, data) =>
    
    # バッファオブジェクトの生成
    ibo = gl.createBuffer();
    
    # バッファをバインドする
    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, ibo);
    
    # バッファにデータをセット
    gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new Int16Array(data), gl.STATIC_DRAW);
    
    # バッファのバインドを無効化
    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, null);
    
    return ibo;
  
  
  
  # -----------------------------------------------
  # Uniform変数の登録
  # -----------------------------------------------
  attachUniform: (gl, prg, name, type, data) =>
    
    uniLocation = gl.getUniformLocation(prg, name);
    
    switch type
      when "mat4"
        gl.uniformMatrix4fv(uniLocation, false, data);
      when "vec2"
        gl.uniform2fv(uniLocation, data);
      when "vec3"
        gl.uniform3fv(uniLocation, data);
      when "vec4"
        gl.uniform4fv(uniLocation, data);
      when "int"
        gl.uniform1i(uniLocation, data);
      when "float"
        gl.uniform1f(uniLocation, data);
      when "floatarray"
        gl.uniform1fv(uniLocation, data);
  
  
  
  # -----------------------------------------------
  # フレームバッファの作成
  # -----------------------------------------------
  createFramebuffer: (gl, width, height) =>
    
    frameBuffer = gl.createFramebuffer();
    
    # フレームバッファをWebGLにバインド
    gl.bindFramebuffer(gl.FRAMEBUFFER, frameBuffer);
    
    # 深度バッファ用レンダーバッファの生成とバインド
    depthRenderBuffer = gl.createRenderbuffer();
    gl.bindRenderbuffer(gl.RENDERBUFFER, depthRenderBuffer);
    
    # レンダーバッファを深度バッファとして設定
    gl.renderbufferStorage(gl.RENDERBUFFER, gl.DEPTH_COMPONENT16, width, height);
    
    # フレームバッファにレンダーバッファを関連付ける
    gl.framebufferRenderbuffer(gl.FRAMEBUFFER, gl.DEPTH_ATTACHMENT, gl.RENDERBUFFER, depthRenderBuffer);
    
    # フレームバッファ用テクスチャの生成
    fTexture = gl.createTexture();
    
    # フレームバッファ用のテクスチャをバインド
    gl.bindTexture(gl.TEXTURE_2D, fTexture);
    
    # フレームバッファ用のテクスチャにカラー用のメモリ領域を確保
    gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, width, height, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
    
    # テクスチャパラメータ
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
    #gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.REPEAT);
    #gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.REPEAT);
    
    # フレームバッファにテクスチャを関連付ける
    gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, fTexture, 0);
    
    # 各種オブジェクトのバインドを解除
    gl.bindTexture(gl.TEXTURE_2D, null);
    gl.bindRenderbuffer(gl.RENDERBUFFER, null);
    gl.bindFramebuffer(gl.FRAMEBUFFER, null);
    
    # オブジェクトを返して終了
    return {f : frameBuffer, d : depthRenderBuffer, t : fTexture};
  
  
  
  # -----------------------------------------------
  # フレームバッファの作成 キューブマップ仕様
  # -----------------------------------------------
  createFramebufferCubeMap: (gl, width, height, target) =>
    
    frameBuffer = gl.createFramebuffer();
    
    # フレームバッファをWebGLにバインド
    gl.bindFramebuffer(gl.FRAMEBUFFER, frameBuffer);
    
    # 深度バッファ用レンダーバッファの生成とバインド
    depthRenderBuffer = gl.createRenderbuffer();
    gl.bindRenderbuffer(gl.RENDERBUFFER, depthRenderBuffer);
    
    # レンダーバッファを深度バッファとして設定
    gl.renderbufferStorage(gl.RENDERBUFFER, gl.DEPTH_COMPONENT16, width, height);
    
    # フレームバッファにレンダーバッファを関連付ける
    gl.framebufferRenderbuffer(gl.FRAMEBUFFER, gl.DEPTH_ATTACHMENT, gl.RENDERBUFFER, depthRenderBuffer);
    
    # フレームバッファ用テクスチャの生成
    fTexture = gl.createTexture();
    
    # フレームバッファ用のテクスチャをバインド
    gl.bindTexture(gl.TEXTURE_CUBE_MAP, fTexture);
    
    # フレームバッファ用のテクスチャにカラー用のメモリ領域を 6 面分確保
    i = 0;
    while i < target.length
      gl.texImage2D(target[i], 0, gl.RGBA, width, height, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
      i++;
    
    # テクスチャパラメータ
    gl.texParameteri(gl.TEXTURE_CUBE_MAP, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
    gl.texParameteri(gl.TEXTURE_CUBE_MAP, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
    gl.texParameteri(gl.TEXTURE_CUBE_MAP, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
    gl.texParameteri(gl.TEXTURE_CUBE_MAP, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
    
    # 各種オブジェクトのバインドを解除
    gl.bindTexture(gl.TEXTURE_CUBE_MAP, null);
    gl.bindRenderbuffer(gl.RENDERBUFFER, null);
    gl.bindFramebuffer(gl.FRAMEBUFFER, null);
    
    # オブジェクトを返して終了
    return {f : frameBuffer, d : depthRenderBuffer, t : fTexture};
  
  
  
  # -----------------------------------------------
  # 2の累乗の最大値を取得
  # -----------------------------------------------
  getMaxTexSize: (w, h) =>
    
    test = Math.max(w, h);
    i = 2;
    while 1
      if i >= test
        return i;
      else
        i *= 2;
  
  
  
  # -----------------------------------------------
  # プログラムオブジェクトの破棄
  # -----------------------------------------------
  disposeProgram: (gl, prg, vsObj, fsObj) =>
    
    gl.useProgram(prg);
    
    gl.detachShader(prg, vsObj);
    gl.detachShader(prg, fsObj);
    
    gl.deleteProgram(prg);
  
  
  
  # -----------------------------------------------
  # シェーダーオブジェクトの破棄
  # -----------------------------------------------
  disposeShader: (gl, shaderObj) =>
    
    gl.deleteShader(shaderObj);
  
  
  
  # -----------------------------------------------
  # プレーンなモデルデータ
  # -----------------------------------------------
  planeModelData: (w, h) =>
    
    if !w? || !h?
      p = [
        -1.0,  1.0,  0.0,
         1.0,  1.0,  0.0,
        -1.0, -1.0,  0.0,
         1.0, -1.0,  0.0
      ];
    else
      p = [
        -w*0.5,  h*0.5,  0.0,
         w*0.5,  h*0.5,  0.0,
        -w*0.5, -h*0.5,  0.0,
         w*0.5, -h*0.5,  0.0
      ];
    
    return {
      p: p,
      c:[
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 1.0
      ],
      t:[
        0.0, 0.0,
        1.0, 0.0,
        0.0, 1.0,
        1.0, 1.0
      ],
      i:[
        0, 2, 1,
        2, 3, 1
      ]
    };















module.exports = GlUtils;