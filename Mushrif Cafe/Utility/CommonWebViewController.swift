//
//  CommonWebViewController.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 15/10/24.
//

import UIKit
import WebKit

class CommonWebViewController: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .main
    
    @IBOutlet weak var titleText: UILabel! {
        didSet {
            titleText.font = UIFont.poppinsMediumFontWith(size: 18)
        }
    }
    
    @IBOutlet weak var webView: WKWebView!
    
    var titleString: String = ""
    var bodyText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        titleText.text = titleString
        
//        let url = URL(string: "http://www.example.com/")
//        let request = URLRequest(url: url! as URL)
//        
//        webView.navigationDelegate = self
//        webView.uiDelegate = self
//        webView.load(request as URLRequest)
        webView.loadHTMLString(bodyText, baseURL: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
extension CommonWebViewController: WKNavigationDelegate, WKUIDelegate {
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
    }
}
