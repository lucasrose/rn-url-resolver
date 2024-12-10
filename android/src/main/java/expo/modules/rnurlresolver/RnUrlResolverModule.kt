package expo.modules.rnurlresolver

import expo.modules.kotlin.Promise
import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition
import java.net.HttpURLConnection
import java.net.URL
import android.util.Log

class RnUrlResolverModule : Module() {
  // Each module class must implement the definition function. The definition consists of components
  // that describes the module's functionality and behavior.
  // See https://docs.expo.dev/modules/module-api for more details about available components.
  override fun definition() = ModuleDefinition {
    // Sets the name of the module that JavaScript code will use to refer to the module. Takes a string as an argument.
    // Can be inferred from module's class name, but it's recommended to set it explicitly for clarity.
    // The module will be accessible from `requireNativeModule('RnUrlResolver')` in JavaScript.
    Name("RnUrlResolver")

    // Defines a JavaScript function that always returns a Promise and whose native code
    // is by default dispatched on the different thread than the JavaScript runtime runs on.
    AsyncFunction("resolveUrl") { encodedUrl: String, token: String?, promise: Promise ->
      resolveUrl(encodedUrl, token, promise)
    }
  }
}

fun resolveUrl(encodedUrl: String, token: String? = null, promise: Promise ) {
  if (encodedUrl.isEmpty()) {
    promise.reject("0", "Unable to handle URL: No url provided", null)
  }
  Thread {
    try {
      val originalURL = URL(encodedUrl)
      val connection = originalURL.openConnection() as HttpURLConnection
      connection.instanceFollowRedirects = false

      if (token != null) {
        connection.setRequestProperty("Authorization", "Bearer ${token}")
      }

      val resolvedURL = URL(connection.getHeaderField("Location"))
      promise.resolve(resolvedURL.toString())
    } catch (e: Exception) {
        Log.e("App Link", "Error resolving URL", e)
        promise.reject("Cannot resolve URL ${e.message}", null, e)
    }
  }.start()
}

