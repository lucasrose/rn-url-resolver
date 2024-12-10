import ExpoModulesCore

public class RnUrlResolverModule: Module {
    
    // Each module class must implement the definition function. The definition consists of components
    // that describes the module's functionality and behavior.
    // See https://docs.expo.dev/modules/module-api for more details about available components.
    public func definition() -> ModuleDefinition {
        // Sets the name of the module that JavaScript code will use to refer to the module. Takes a string as an argument.
        // Can be inferred from module's class name, but it's recommended to set it explicitly for clarity.
        // The module will be accessible from `requireNativeModule('RnUrlResolver')` in JavaScript.
        Name("RnUrlResolver")
        
        // Defines a JavaScript function that always returns a Promise and whose native code
        // is by default dispatched on the different thread than the JavaScript runtime runs on.
        AsyncFunction("resolveUrl") { (encodedURL: String, token: String?, promise: Promise) in
            resolveUrl(encodedUrl: encodedURL, token: token, promise: promise)
        }
    }
}

func resolveUrl(encodedUrl: String, token: String? = nil, promise: Promise) {
    if encodedUrl.isEmpty {
        promise.reject("0", "Unable to handle URL: No URL provided")
        return
    }
    
    guard let url = URL(string: encodedUrl) else {
        promise.reject("0", "Unable to handle URL: Invalid URL format")
        return
    }
    
    var request = URLRequest(url: url)
    
    // Add session token if provided
    if let authToken = token {
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    }
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            DispatchQueue.main.async {
                promise.reject("0", "Error during request: \(error.localizedDescription)")
            }
            return
        }
        
        DispatchQueue.main.async {
            guard let resolvedURL = response?.url else {
                promise.reject("0", "Unable to handle URL: Not a valid URL")
                return
            }
            promise.resolve(resolvedURL.absoluteString)
        }
    }
    task.resume()
}

