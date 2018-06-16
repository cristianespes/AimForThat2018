//
//  AboutUsViewController.swift
//  AimForThat2018
//
//  Created by CRISTIAN ESPES on 4/4/18.
//  Copyright © 2018 CRISTIAN ESPES. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = Bundle.main.url(forResource: "AimForThat", withExtension: "html") {
            if let htmlData = try? Data(contentsOf: url){
                
                let baseURL = URL(fileURLWithPath: Bundle.main.bundlePath)
                
                self.webView.load(htmlData, mimeType: "text/html", textEncodingName: "UTF-8", baseURL: baseURL)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backPressed() {
        dismiss(animated: true, completion: nil)
    }

}
