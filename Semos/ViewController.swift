//
//  ViewController.swift
//  Copy
//
//  Created by JaeHyeon on 2021/07/09.
//

import UIKit
import WebKit
import CoreLocation

import Firebase

class ViewController: UIViewController,WKUIDelegate,WKNavigationDelegate,CLLocationManagerDelegate {
    @IBOutlet var webView: WKWebView!
    var locationManager: CLLocationManager!
    
    var popupWebView: WKWebView?
    
    var backfoward = [
        URL(string: "https://semos.kr/"),
        URL(string: "https://semos.kr/location"),
        URL(string: "https://semos.kr/market"),
        URL(string: "https://semos.kr/my_page"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        self.webView.uiDelegate = self
        webView.navigationDelegate = self
        
        HTTPCookieStorage.shared.cookieAcceptPolicy = HTTPCookie.AcceptPolicy.always
        
        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)

        locationManager.requestWhenInUseAuthorization()
        let request = URLRequest(url: URL(string: "https://semos.kr")!)

        WKWebpagePreferences().allowsContentJavaScript = true
        self.webView.load(request)
        
        // set status bar white
        if #available(iOS 13.0, *) {
            let statusBarHeight: CGFloat = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor.white
            view.addSubview(statusbarView)
          
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.white
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if (navigationAction.request.url?.scheme == "tel" || navigationAction.request.url?.scheme == "kakaotalk") {
            UIApplication.shared.open(navigationAction.request.url!)
            decisionHandler(.cancel)
      } else {
            decisionHandler(.allow)
      }
    }
    
    // set status bar letter black
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // alert
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void){
        print("alert")
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in completionHandler() }))
        self.present(alertController, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            let tmp = navigationAction.request.url?.absoluteString
            if (tmp!.contains("chat")){
                UIApplication.shared.open(navigationAction.request.url!, options: [:])
                return nil
            }
        }
        popupWebView = WKWebView(frame: view.bounds, configuration: configuration)
        popupWebView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        popupWebView?.navigationDelegate = self
        popupWebView?.uiDelegate = self
        popupWebView?.scrollView.isScrollEnabled = false
        view.addSubview(popupWebView!)
        return popupWebView!
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        webView.removeFromSuperview()
        popupWebView = nil
    }

    // detact url change
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.webView?.allowsBackForwardNavigationGestures = backfoward.contains(webView.url!) ? false : true
        // if it is one of the main page, do not allow backward gesture
        let temp = webView.url?.absoluteString
        webView.scrollView.isScrollEnabled = (webView.url! == URL(string: "https://semos.kr/location") || temp!.contains("partner_page_img_all")) ? false : true
        // disable scroll at location page
    }
}
