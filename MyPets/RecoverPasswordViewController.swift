//
//  RecoverPasswordViewController.swift
//  MyPets
//
//  Created by alumnos on 22/01/2020.
//  Copyright © 2020 alumnos. All rights reserved.
//

import UIKit
import Alamofire

class RecoverPasswordViewController: UIViewController {
    
    @IBOutlet weak var email_recover_text: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func recover_password_button(_ sender: Any) {
        
    }
    
    func RestorePasswords(email: String){
        
        let url = URL(string: "")!
        let json = ["_method": "PUT", "email": email]
        
        Alamofire.request(url, method: .post, parameters: json, encoding: JSONEncoding.default, headers: nil).responseJSON {
            (response) in
            
            switch(response.response?.statusCode){
            case 200:
                self.performSegue(withIdentifier: "password_restore_segue", sender: nil)
            case 401:
                if let json = response.result.value as? [String: Any] {
                    let message = json["message"] as! String
                    print(message)
                }
            default:
                print("Default")
                
            }
        }
    }
    
}
