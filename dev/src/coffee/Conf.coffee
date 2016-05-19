

# ------------------------------------
# 定数
# ------------------------------------
class Conf
  
  # ------------------------------------
  # コンストラクタ
  # ------------------------------------
  constructor: ->
    
    # 本番フラグ
    # -------------------------------
    @RELEASE = false;
    # -------------------------------
    
    # フラグ関連
    @FLG = {
      LOG:true,  # ログ出力
      PARAM:true, # パラメータチェック SPは強制false
      STATS:true  # Stats表示
    };
    
    # 本番フラグがtrueの場合、フラグ関連は全てfalseに
    if @RELEASE
      for key,val of @FLG
        @FLG[key] = false;
    
    
    # 画像パス
    @PATH_IMG = "./assets/img";
    
    # 基本カラー
    @BASE_COLOR = [92/255, 89/255, 112/255];










module.exports = Conf;
