# ==============================
# node v0.12.3
# gulp v3.8.11
# ==============================

# 開発ディレクトリ
SRC_DIR = "./src";

# 公開ディレクトリ
PUBLISH_DIR = "../htdocs";

# jsライブラリディレクトリ
JS_LIBS_DIR = SRC_DIR + "/_libs";


gulp       = require("gulp");
$          = require("gulp-load-plugins")();
browserify = require("browserify");
source     = require("vinyl-source-stream");

# ライブラリ系は全部結合
concatLibsJs = [
  JS_LIBS_DIR + "/jquery-2.2.2.min.js",
  JS_LIBS_DIR + "/Stats.js",
  JS_LIBS_DIR + "/dat.gui.min.js",
  JS_LIBS_DIR + "/three.js",
  JS_LIBS_DIR + "/minMatrixb.js"
];


# -------------------------------------------------------------------
# coffee
# -------------------------------------------------------------------
gulp.task "js.coffee", ->
  browserify({
    entries: [SRC_DIR + "/coffee/Main.coffee"]
    extensions: [".coffee", ".js"]})
      .bundle()
      .pipe(source("main.js"))
      .pipe(gulp.dest(PUBLISH_DIR + "/assets/js/"))



# -------------------------------------------------------------------
# connect
# -------------------------------------------------------------------
gulp.task "connect", ->
  $.connect.server({
    root: PUBLISH_DIR
    port:50000})



# -------------------------------------------------------------------
# js結合 ライブラリは結合して使用
# -------------------------------------------------------------------
gulp.task "js.concatlibs", ->
  gulp.src(concatLibsJs)
    .pipe($.concat("libs.js"))
    .pipe(gulp.dest(PUBLISH_DIR + "/assets/js"));



# -------------------------------------------------------------------
# watch
# -------------------------------------------------------------------
gulp.task "watch", ->
  gulp.watch([SRC_DIR + "/**/*.coffee"], ["js.coffee"])



# -------------------------------------------------------------------
# task設定
# -------------------------------------------------------------------
gulp.task("default", ["js.coffee", "js.concatlibs", "watch", "connect"]);



