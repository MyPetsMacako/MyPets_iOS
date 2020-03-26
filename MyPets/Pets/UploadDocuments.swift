//
//  UploadDocuments.swift
//  MyPets
//
//  Created by alumnos on 27/02/2020.
//  Copyright © 2020 alumnos. All rights reserved.
//

import UIKit

import PDFKit
import WebKit

var pet_documents_global = PDFDocument()
class UploadDocuments: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var saveDocumentsButton: UIButton!
    @IBOutlet weak var web_view: WKWebView!
    var image_picker: ImagePicker!
    var images: [UIImage] = []
    let pdfDocument = PDFDocument()
    override func viewDidLoad() {
        super.viewDidLoad()
        saveDocumentsButton.layer.cornerRadius = 5
        let webConfiguration = WKWebViewConfiguration()
        web_view = WKWebView(frame: .zero, configuration: webConfiguration)
        web_view.uiDelegate = self
        
        self.image_picker = ImagePicker(presentationController: self, delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let bgSetter: BGSet = BGSet()
        bgSetter.setBackground(view: self.view)
    }
    
    @IBAction func press_button(_ sender: UIButton) {
        self.image_picker.present(from: sender)
    }
    @IBAction func save_button(_ sender: UIButton) {
        print(images)
        if images.count > 0{
            for i in 0...images.count - 1{
                let image = images[i].stretchableImage(withLeftCapWidth: 250, topCapHeight: 450)
                let pdfPage = PDFPage(image: image)!
                pdfDocument.insert(pdfPage, at: i)
                pet_documents_global = pdfDocument
            }
        }        
    }
}

extension UploadDocuments: ImagePickerDelegate{
    func didSelect(image: UIImage?) {
        if image != nil{
            images.append(image!)
            print(images)
        }
    }
}
