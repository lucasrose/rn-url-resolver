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
        AsyncFunction("resolveUrl") { (encodedURL: String, token: String?, allowReturnFromFailedUrl: Bool?, directlyReturnResponseUrl: Bool?, disableCache: Bool?, redirectUntil: String?, locationHeaderMatch: String?, promise: Promise) in
            resolveUrl(encodedUrl: encodedURL, token: token, allowReturnFromFailedUrl: allowReturnFromFailedUrl, directlyReturnResponseUrl: directlyReturnResponseUrl, disableCache: disableCache, redirectUntil: redirectUntil, locationHeaderMatch: locationHeaderMatch, promise: promise)
        }
    }
}

func resolveUrl(encodedUrl: String, token: String? = nil, allowReturnFromFailedUrl: Bool? = false, directlyReturnResponseUrl: Bool? = false, disableCache: Bool? = false, redirectUntil: String? = "none", locationHeaderMatch: String?, promise: Promise) {
    if encodedUrl.isEmpty {
        promise.reject("0", "Unable to handle URL: No URL provided")
        return
    }
    
    guard let url = URL(string: encodedUrl) else {
        promise.reject("0", "Unable to handle URL: Invalid URL format")
        return
    }

    let redirectManager = RedirectManager()
    let redirectBehavior = RedirectBehavior.from(string: redirectUntil)
    
    redirectManager.getFinalURL(fromURL: url, withToken: token, allowReturnFromFailedUrl: allowReturnFromFailedUrl, directlyReturnResponseUrl: directlyReturnResponseUrl, disableCache: disableCache, redirectBehavior: redirectBehavior, locationHeaderMatch: locationHeaderMatch) { finalURL in
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
    private var locationHeaderMatch: String?
    private var redirectBehavior: RedirectBehavior = RedirectBehavior.none
    
    func getFinalURL(fromURL initialURL: URL, withToken token: String? = nil, allowReturnFromFailedUrl: Bool?, directlyReturnResponseUrl: Bool?, disableCache: Bool?, redirectBehavior: RedirectBehavior?, locationHeaderMatch: String?, completion: @escaping (URL?) -> Void) {
        
        self.completion = completion
        self.redirectBehavior = redirectBehavior ?? RedirectBehavior.none
        self.locationHeaderMatch = locationHeaderMatch
        self.locationHeaderMatch = locationHeaderMatch
        
        let sessionConfiguration = URLSessionConfiguration.default

        if (disableCache ?? false) {
            sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalCacheData
            sessionConfiguration.urlCache = nil
        }

        let session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)

        var request = URLRequest(url: initialURL)
        
        if let authToken = token {
            request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if ((directlyReturnResponseUrl ?? false) && ((response?.url) != nil)) {
                completion(response?.url)
                return
            }
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
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        guard let newURL = request.url else {
            completionHandler(nil)
            return
        }
                
        print("Redirected to: \(newURL)")
        switch redirectBehavior {
            case .none:
            self.finalURL = newURL
            completionHandler(nil)
        case .end:
            self.finalURL = newURL
            completionHandler(request)
            print("Redirected to: \(newURL)")

        case .locationMatch:
            if let locationHeaderMatch = self.locationHeaderMatch {
                if let locationHeader = response.allHeaderFields["Location"] as? String,
                   locationHeader.contains(locationHeaderMatch) {
                    print("Stopping at matching Location header: \(locationHeader)")
                    self.finalURL = URL(string: locationHeader)
                    completionHandler(nil)
                } else {
                    completionHandler(request)
                    print("Redirected to: \(newURL)")
                }
            }
        }
    }
}

enum RedirectBehavior: String {
    case none
    case end
    case locationMatch
    
    // Default value
    static let defaultBehavior: RedirectBehavior = .none
}
extension RedirectBehavior {
    static func from(string: String?) -> RedirectBehavior {
        guard let string = string?.lowercased(), let behavior = RedirectBehavior(rawValue: string) else {
            return .defaultBehavior
        }
        return behavior
    }
}
