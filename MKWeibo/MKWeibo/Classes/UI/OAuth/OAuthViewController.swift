//
//  ViewController.swift
//  01-OAuth
//
//  Created by 穆康 on 15/3/1.
//  Copyright (c) 2015年 穆康. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let WB_API_URL_String = "https://api.weibo.com"
    let WB_Redirect_URL_String = "http://www.baidu.com"
    let WB_Client_ID = "2819746315"
    let WB_Client_Secret = "f0612920d4573dc5ba93664e06d8f615"
    let WB_Grant_Type = "authorization_code"

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadOAuthPage()
    }
    
    // 加载授权页面
    func loadOAuthPage() {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_Client_ID)&redirect_uri=\(WB_Redirect_URL_String)"
        
        let url = NSURL(string: urlString)
        
        webView.loadRequest(NSURLRequest(URL: url!))
    }
}

extension ViewController: UIWebViewDelegate {
    
    // 页面重定向
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let result = continueWithCode(request.URL!)
        
        if let code = result.code {
            // 参数
            let params = ["client_id": WB_Client_ID,
                          "client_secret": WB_Client_Secret,
                          "grant_type": WB_Grant_Type,
                          "redirect_uri": WB_Redirect_URL_String,
                          "code": code]
            
            let net = NetworkManager.sharedManager
            
            net.requestJSON(.POST, "https://api.weibo.com/oauth2/access_token", params, completion: { (result, error) -> () in
                println(result)
            })
            
            
        }
        if !result.load {
            println("不加载\(request.URL!)")
            
            // 点击取消的时候才需要重新加载页面
            if result.reloadPage {
              loadOAuthPage()
            }
        }
        
        return result.load
    }
    
    // 根据url判断是否继续加载页面，是否重新加载
    func continueWithCode(url: NSURL) -> (load: Bool, code: String?, reloadPage: Bool) {
        
        // 将url转换成字符串
        let urlStr = url.absoluteString!
        
        // 如果不是微博的API地址，都不加载
        if !urlStr.hasPrefix(WB_API_URL_String) {
            // 如果是回调地址，需要判断code
            if urlStr.hasPrefix(WB_Redirect_URL_String) {
                if let query = url.query {
                    let codeStr = "code="
                    if query.hasPrefix(codeStr) {
                        var queryNSStr = query as NSString
                        let codeNSStr = codeStr as NSString
                        return (false, queryNSStr.substringFromIndex(codeNSStr.length), false)
                    } else {
                        return (false, nil, true)
                    }
                }
            }
            return (false, nil, false)
        }
        return (true, nil, false)
    }
}

