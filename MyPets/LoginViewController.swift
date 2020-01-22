//
//  ViewController.swift
//  MyPets
//
//  Created by alumnos on 22/01/2020.
//  Copyright © 2020 alumnos. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    
    @IBOutlet weak var email_login_text: UITextField!
    @IBOutlet weak var password_login_text: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func login_button(_ sender: Any) {
        
        if email_login_text.text?.isEmpty ?? true || password_login_text.text?.isEmpty ?? true
        {
            
        } else {
            LoginUser(email: email_login_text.text!, password: password_login_text.text!)
        }
    }
    
    func LoginUser(email: String, password: String) {
        
        let url = URL(string: "")!
        let json = ["email": email, "password": password]
        
        Alamofire.request(url, method: .post, parameters: json, encoding: JSONEncoding.default, headers: nil).responseJSON {
            (response) in
            
            switch(response.response?.statusCode){
            case 200:
                if let json = response.result.value as? [String: Any] {
                    
                    let token = json["token"] as! String
                    UserDefaults.standard.set(token, forKey: "token")
                    
                    self.performSegue(withIdentifier: "login_enter_segue" , sender: nil)
                }
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

