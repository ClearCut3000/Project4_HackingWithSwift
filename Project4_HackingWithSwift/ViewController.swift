//
//  ViewController.swift
//  Project4_HackingWithSwift
//
//  Created by Николай Никитин on 11.12.2021.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
  //MARK: - Properties
  var webView: WKWebView!
  var progressView: UIProgressView!
  var websites = [String]()
  var choosenWebsite = Int()

  //MARK: - WebView
  override func loadView(){
    webView = WKWebView()
    webView.navigationDelegate = self
    view = webView
  }

  //MARK: - UIViewController
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))

    let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
    let forward = UIBarButtonItem(barButtonSystemItem: .redo, target: webView, action: #selector(webView.goForward))
    let back = UIBarButtonItem(barButtonSystemItem: .undo, target: webView, action: #selector(webView.goBack))
    progressView = UIProgressView(progressViewStyle: .default)
    progressView.sizeToFit()
    let progressButton = UIBarButtonItem(customView: progressView)


    toolbarItems = [back,spacer, progressButton, spacer, refresh, forward]

    navigationController?.isToolbarHidden = false

    webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

    let url = URL(string: "https://" + websites[choosenWebsite])!
    webView.load(URLRequest(url: url))
    webView.allowsBackForwardNavigationGestures = true
  }

  //MARK: - Methods
  func openPage(action: UIAlertAction){
    guard let title = action.title else { return }
    guard let url = URL(string: "https://" + title) else { return }
    webView.load(URLRequest(url: url))
  }

  @objc func openTapped(){
    let alertController = UIAlertController(title: "Open page ...", message: nil, preferredStyle: .actionSheet)
    for website in websites {
    alertController.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
    }
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    alertController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    present(alertController, animated: true)
  }

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    title = webView.title
  }


  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "estimatedProgress" {
      progressView.progress = Float(webView.estimatedProgress)
    }
  }
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    let url = navigationAction.request.url
    if let host = url?.host{
      for website in websites {
        if host.contains(website){
          decisionHandler(.allow)
          return
        }
      }
    }
    let alert = UIAlertController(title: "In this application, you cannot visit other sites!", message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "I got it all =(", style: .cancel))
    present(alert, animated: true)
    decisionHandler(.cancel)
  }
}

