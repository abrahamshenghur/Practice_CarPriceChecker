//
//  VehicleWebsiteVC.swift
//  PracticeCarPriceChecker
//
//  Created by Abraham on 1/25/22.
//  Copyright © 2022 Abraham Shenghur. All rights reserved.
//

import UIKit
import WebKit

protocol VehicleListVCTapGestureDelegate: class {
    func didUseGestureRecognizer(on vehicleWebsiteVC: VehicleWebsiteVC)
}

class VehicleWebsiteVC: UIViewController {

    var vehicleWebsite: WKWebView!
    
    var websiteName: String!
    var autotraderWebView = PCPCWebView()
    var carsDotComWebView = PCPCWebView()
    var carGurusWebView = PCPCWebView()
    var craigslistWebView = PCPCWebView()
    var trueCarWebView = PCPCWebView()
    
    let activityIndicator = UIActivityIndicatorView()
    let loadingView = UIView()
    
    weak var gestureRecognizerDelegate: VehicleListVCTapGestureDelegate?
    
    
    init(websiteName: String) {
        super.init(nibName: nil, bundle: nil)
        self.websiteName = websiteName
        
        addTapGesture()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        loadWebView()
    }
    
    
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapVC))
        tap.delegate = self
        
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func tapVC(_ recognizer: VehicleWebsiteVC) {
        gestureRecognizerDelegate?.didUseGestureRecognizer(on: self)
    }
    
    
    func loadWebView() {
        vehicleWebsite = WKWebView()
        view = vehicleWebsite

        guard let url = URL(string: "https://www.\(websiteName!).com") else {
            print("Something happened. \(String(describing: websiteName)) is not a valid url address")
            return
        }
        
        vehicleWebsite.load(URLRequest(url: url))
        vehicleWebsite.navigationDelegate = self
        
        let request = URLRequest(url: url)
        vehicleWebsite.load(request)
    }


    func buildURLFrom(make: String, model: String, for websiteName: String) {
        switch websiteName {
        case WebsiteName.autotrader:
            let autoTraderURL = autotraderWebView.buildAutotraderURL(make, model)
            loadWebsite(url: autoTraderURL!)
        case WebsiteName.cars:
            let carsDotComURL = carsDotComWebView.buildCarsDotComURL(make, model)
            loadWebsite(url: carsDotComURL!)
        case WebsiteName.carGurus:
            let carGurusURL = carGurusWebView.buildCarGurusURL(make, model)
            loadWebsite(url: carGurusURL!)
        case WebsiteName.craigslist:
            let craigslistURL = craigslistWebView.buildCraigslistURL(make, model)
            loadWebsite(url: craigslistURL!)
        case WebsiteName.trueCar:
            let trueCarURL = trueCarWebView.buildTrueCarURL(make, model)
            loadWebsite(url: trueCarURL!)
        default:
            print("Error: Could not build url for \(websiteName)")
        }
    }
    
    
    func loadWebsite(url: URL) {
        vehicleWebsite.load(URLRequest(url: url))
    }

    
    func showActivityIndicator(show: Bool) {
        if show {
            vehicleWebsite.addSubview(loadingView)
            loadingView.frame = view.frame
            loadingView.backgroundColor = .systemBackground
            loadingView.alpha = 0.8

            loadingView.addSubview(activityIndicator)
            activityIndicator.startAnimating()

            loadingView.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                loadingView.topAnchor.constraint(equalTo: view.topAnchor),
                loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
            ])
            
        } else {
            loadingView.backgroundColor = .systemBackground
            loadingView.alpha = 0
            activityIndicator.stopAnimating()
        }
    }
}


extension VehicleWebsiteVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showActivityIndicator(show: false)
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator(show: true)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
    }
}


extension VehicleWebsiteVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
