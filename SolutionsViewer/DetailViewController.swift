//
//  DetailViewController.swift
//  SolutionsViewer
//
//  Created by Carlo Donzelli on 30/07/2015.
//  Copyright (c) 2015 Carlo Donzelli. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var model: DetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Web Preview"

        webView.delegate = self
        if let urlPath = model.getUrl() {
            let url = NSURL(string: urlPath)
            let request = NSURLRequest(URL: url!)
            webView.loadRequest(request)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}

// MARK: - UIWebViewDelegate
extension DetailViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == .LinkClicked {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        return true
    }
}
