package com.joinseeds.seedswallet

import android.util.Log
import android.webkit.WebStorage
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
  private val channel = "lw.web_view.clear"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler {
      // Note: this method is invoked on the main thread.
      call, result ->
      if (call.method == "clear") {
        clearWebViewCache()
        Log.d("kotlin - MainActivity", "Webview cache cleared")
        result.success(true)
      } else {
        result.notImplemented()
      }
    }
  }

  private fun clearWebViewCache() {
    WebStorage.getInstance().deleteAllData()
  }
}
