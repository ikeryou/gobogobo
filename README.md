# シェーダノイズを使った着色とグリッチエフェクト

## 作ったもの
![GOBOGOBO](http://ikeryou.jp/works/gobo/assets/img/readme/0.png)
<http://ikeryou.jp/works/gobo/>
<br>
<br>
<br>
## やったこと
<br>
<br>
<br>
## ベースとなるノイズの作成
![ノイズ](http://ikeryou.jp/works/gobo/assets/img/readme/1.jpg)
フラグメントシェーダでベースとなるノイズを作成します<br>
GLSLで描画することで高速でノイズを作成できます<br>
https://wgld.org/d/glsl/g007.html<br>
ちなみにこの処理は最初の一回だけで、以降は毎フレームやってます
<br>
<br>
<br>
## ベースとなる画面の描画
![ベース](http://ikeryou.jp/works/gobo/assets/img/readme/9.jpg)
<br>
<br>
<br>
## 着色
<br>
<br>
<br>
## 1.色を変えて３回オフスクリーンレンダリング
![赤](http://ikeryou.jp/works/gobo/assets/img/readme/2.jpg)
![青](http://ikeryou.jp/works/gobo/assets/img/readme/3.jpg)
![緑](http://ikeryou.jp/works/gobo/assets/img/readme/4.jpg)

####オフスクリーンレンダリング<br>
ブラウザ上には描画されないけど、裏側で描画してプログラム上に保存できる<br>
その描画したものに対して様々な効果を適応させる事が可能<br>
今回は素WebGLだけど、three.jsでいうWebGLRenderTargetとかが該当する
<br>
<br>
<br>
## 2.ノイズでマスクをかけて合成
![赤](http://ikeryou.jp/works/gobo/assets/img/readme/5.jpg)
![青](http://ikeryou.jp/works/gobo/assets/img/readme/6.jpg)
![緑](http://ikeryou.jp/works/gobo/assets/img/readme/7.jpg)
<br>
<br>
####うまい具合に合成します<br>
![合成](http://ikeryou.jp/works/gobo/assets/img/readme/8.jpg)

これもオフスクリーンレンダリングですが、<br>
1度の処理で3つの画像にマスクをかけられるので<br>
描画回数は1回

<br>
<br>
<br>
## グリッチ
![グリッチ](http://ikeryou.jp/works/gobo/assets/img/readme/10.jpg)
http://ikeryou.jp/works/gobo2/

ノイズの白いところほど多くずれる<br>
RGB別々にずらす<br>
その際に、ずれの強さと方向をRGB別々に設定する<br>
描画回数は1回

<br>
<br>
<br>
## まとめ
この感じで計6回レンダリングして絵を作ってます<br>
レンダリング回数が多くなると高負荷になるのでやりすぎ注意ですが、<br>
色々な絵を重ねることで面白い絵を作ることができます
<br>
<br>
<br>
## 応用
今回は一個のノイズデータを使いましたが、<br>
違うノイズデータを使用することで、また違う見え方も期待できます<br>

![テクスチャ作成](http://ikeryou.jp/works/gobo/assets/img/readme/11.jpg)
https://github.com/mrdoob/texgen.js/<br>
このようにパラメータを変えることでノイズっぽいテクスチャを生成できるライブラリも存在します<br>

一度使ったことがありますが、<br>
パラメータいじるとなかなか尖った絵が作れます<br>
http://ikeryou.jp/works/tex/
