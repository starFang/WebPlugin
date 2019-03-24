//
//  ViewController.swift
//  HelloLife
//
//  Created by Star童话 on 2019/3/21.
//  Copyright © 2019 STAR. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    var webview = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webview.navigationDelegate = self
        webview.uiDelegate = self;
        // Do any additional setup after loading the view, typically from a nib.
        //创建网址
        let url = URL(string: "https://www.jianshu.com/p/2bad53a2a180")
        //创建请求
        let request = URLRequest(url: url!)

        //加载请求
        webview.load(request)
        //添加wkwebview
        self.view.addSubview(webview)
        
        webview.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(self.view)
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.navigationController?.title = webview.title
    }


}

