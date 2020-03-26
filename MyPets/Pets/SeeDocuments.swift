//
//  SeeDocuments.swift
//  MyPets
//
//  Created by alumnos on 04/03/2020.
//  Copyright © 2020 alumnos. All rights reserved.
//

import UIKit
import PDFKit
import WebKit

class SeeDocuments: UIViewController, WKUIDelegate  {
    
    @IBOutlet weak var error: UILabel!
    @IBOutlet weak var web_view: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let webConfiguration = WKWebViewConfiguration()
        web_view = WKWebView(frame: .zero, configuration: webConfiguration)
        web_view.uiDelegate = self
        if document == "http://mypetsapp.es/storage/"{
            web_view.isHidden = true
            print("entra")
            error.isHidden = false
        }else{
            web_view.isHidden = false
            view = web_view
            error.isHidden = true
            let url = URL(string: document!)
            let url_request = URLRequest(url: url!)
            web_view.load(url_request)
        }
    }
}
