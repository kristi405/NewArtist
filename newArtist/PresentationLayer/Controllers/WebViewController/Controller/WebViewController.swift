import UIKit
import WebKit

final class WebViewController: UIViewController {
    // MARK: IBOutlets
    
    @IBOutlet private weak var progressViewXIB: UIProgressView!
    @IBOutlet private weak var webViewXIB: WKWebView!
    
    // MARK: Public Properties
    
    var eventURL = ""
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchWebView()
        webViewXIB.addObserver(self,
                             forKeyPath: #keyPath(WKWebView.estimatedProgress),
                             options: .new,
                             context: nil)
        webViewXIB.navigationDelegate = self
        UIView.animate(withDuration: Constants.duration) {
            self.progressViewXIB.setProgress(Constants.progressView, animated: true)
        }
    }
    
    // MARK:  Override Methods
    
    // Installing the observer for loading webView
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        if keyPath == WebVCString.estimatedProgress.rawValue {
            progressViewXIB?.progress = Float(webViewXIB?.estimatedProgress ?? .zero)
        }
    }
    
    // MARK:  Private Methods
    
    // Send a request
    private func fetchWebView() {
        guard let url = URL(string: eventURL) else {return}
        let request = URLRequest(url: url)
        
        webViewXIB.load(request)
    }
    
    // Display progressView
    private func showProgressView() {
        UIView.animate(withDuration: TimeInterval(Constants.withDuration), delay: .zero, options: .curveEaseInOut, animations: {
            self.progressViewXIB?.alpha = Constants.alphaProgressView
        }, completion: nil)
    }
    
    // Hide progressView
    private func hideProgressView() {
        UIView.animate(withDuration: TimeInterval(Constants.withDuration), delay: .zero, options: .curveEaseInOut, animations: {
            self.progressViewXIB?.alpha = .zero
        }, completion: nil)
    }
}


// MARK: - Extensions WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showProgressView()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideProgressView()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideProgressView()
    }
}

extension WebViewController {
    // MARK: Constants
    
    private enum Constants {
        static let withDuration: CGFloat = 0.5
        static let alphaProgressView: CGFloat = 1
        static let progressView: Float = 1
        static let duration: TimeInterval = 3
    }
}
