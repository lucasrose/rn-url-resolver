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
        AsyncFunction("resolveUrl") { (encodedURL: String, token: String?, allowReturnFromFailedUrl: Bool?, promise: Promise) in
            resolveUrl(encodedUrl: encodedURL, token: token, allowReturnFromFailedUrl: allowReturnFromFailedUrl, promise: promise)
        }
    }
}

func resolveUrl(encodedUrl: String, token: String? = nil, allowReturnFromFailedUrl: Bool? = false, promise: Promise) {
    if encodedUrl.isEmpty {
        promise.reject("0", "Unable to handle URL: No URL provided")
        return
    }
    
    guard let url = URL(string: encodedUrl) else {
        promise.reject("0", "Unable to handle URL: Invalid URL format")
        return
    }

    let redirectManager = RedirectManager()
    redirectManager.getFinalURL(fromURL: url, withToken: token, allowReturnFromFailedUrl: allowReturnFromFailedUrl) { finalURL in
        if let finalURL = finalURL {
            promise.resolve(finalURL.absoluteString)
        } else {
            promise.reject("0", "Failed to resolve final URL")
        }
    }
}

class RedirectManager: NSObject, URLSessionTaskDelegate {
    private var finalURL: URL?
    private var completion: ((URL?) -> Void)?
    func getFinalURL(fromURL initialURL: URL, withToken token: String? = nil, allowReturnFromFailedUrl: Bool?, completion: @escaping (URL?) -> Void) {
        self.completion = completion

        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)

        var request = URLRequest(url: initialURL)
        
        // Add session token if provided
        if let authToken = token {
            request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        
        let task = session.dataTask(with: request) { _, _, error in
            if let error = error {

                if allowReturnFromFailedUrl ?? false {
                    if let nsError = error as NSError? {
                        if let redirectURLString = nsError.userInfo["NSErrorFailingURLStringKey"] as? String {
                            completion(URL(string: redirectURLString)!)
                            return
                        }
                    }
                }
                print("Error resolving URL: \(error)")
                completion(nil)
            } else {
                completion(self.finalURL ?? initialURL)
            }
        }
        task.resume()
    }
    
    // URLSessionTaskDelegate method to handle redirection
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        
        // Here, 'request.url' is the new URL the task is being redirected to.
        // We call the completion handler with nil to prevent the redirection from happening
        // because we just want to capture the URL.
        completionHandler(nil)
        
        // We assume the delegate method will be called for the final redirection.
        // This may need refinement to handle multiple redirections if necessary.
        if let finalURL = request.url {
            self.finalURL = request.url
            // Do something with the final URL
            print("Final URL is: \(finalURL)")
        }
    }
}
