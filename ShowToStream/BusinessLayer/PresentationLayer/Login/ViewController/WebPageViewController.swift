//
//  WebPageViewController.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 06/01/21.
//

import UIKit
import WebKit
class WebPageViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.login
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.webPage
    }
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false, title: String, url:String, iscomeFrom:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! WebPageViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.titleName = title
        controller.viewModel.iscomeFrom = iscomeFrom
        controller.viewModel.url = url
        controller.show(from: viewController, forcePresent: forcePresent)
    }

    lazy var viewModel: WebPageViewModel = WebPageViewModel(hostViewController: self)

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name.stopPlayingTrailer, object: nil)
        
        self.titleLabel.text = self.viewModel.titleName
        // Do any additional setup after loading the view.
        webView.navigationDelegate = self
        if self.viewModel.url != ""{
            let url = URL(string: self.viewModel.url)
            webView.load(URLRequest(url: url!))
            webView.allowsBackForwardNavigationGestures = true
        }
    }
    
    @IBAction func backButtonDidTapped(_ sender: Any) {
        if let navVC = self.navigationController,
           navVC.viewControllers.count > 1 {
            var isShowDetailExist = false
            if let stack = self.navigationController?.viewControllers {
                for vc in stack where vc.isKind(of: ShowDetailViewController.self) {
                    if let showDetailVC = vc as? ShowDetailViewController {
                        isShowDetailExist = true
                        self.viewModel.completionHandler!(true)
                        navVC.popToViewController(showDetailVC, animated: true)
                        break
                    }
                }
                if !isShowDetailExist {
                    navVC.popViewController(animated: true)
                }
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func backToPreviousController() {
        if let navVC = self.navigationController,
           navVC.viewControllers.count > 1 {
            var isShowDetailExist = false
            if let stack = self.navigationController?.viewControllers {
                for vc in stack where vc.isKind(of: ShowDetailViewController.self) {
                    if let showDetailVC = vc as? ShowDetailViewController {
                        isShowDetailExist = true
                        self.viewModel.completionHandler!(true)
                        navVC.popToViewController(showDetailVC, animated: true)
                        
                    }
                }
                if !isShowDetailExist {
                    navVC.popViewController(animated: true)
                }
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

}

//MARK :
//MARK : Webview delegate ..
extension WebPageViewController : WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoader()
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showLoader()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideLoader()
 }

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        // if the request is a non-http(s) schema, then have the UIApplication handle
        // opening the request

        if let url = navigationAction.request.url,
            url.scheme == "showtostreamios",
            url.host == "payment_callBack"{
            self.backToPreviousController()

            // cancel the request (handled by UIApplication)
            decisionHandler(.cancel)
            
            self.viewModel.completionHandler!(true)

        }
        else {
            if let urlStr = navigationAction.request.url?.absoluteString as? String {
                if urlStr.contains("user/terms") {
                    self.titleLabel.text = StringConstants.termsOfServices
                }
            }
            
            // allow the request
            decisionHandler(.allow)
        }
    }
}
