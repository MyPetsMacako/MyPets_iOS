//
//  UserRegistrationViewController.swift
//  MyPets
//
//  Created by alumnos on 22/01/2020.
//  Copyright © 2020 alumnos. All rights reserved.
//

import UIKit
import Alamofire

class UserRegistrationViewController: UIViewController {
    
    @IBOutlet weak var name_register_text: UITextField!
    @IBOutlet weak var surname_register_text: UITextField!
    @IBOutlet weak var email_register_text: UITextField!
    @IBOutlet weak var password_register_text: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    @IBAction func user_registration_button(_ sender: Any) {
        
        if name_register_text.text?.isEmpty ?? true || surname_register_text.text?.isEmpty ?? true || email_register_text.text?.isEmpty ?? true || password_register_text.text?.isEmpty ?? true
        {
            
        } else {
            registerUser(name: name_register_text.text!, surname: surname_register_text.text!, email: email_register_text.text!, password: password_register_text.text!)
        }
    }
    
    func registerUser(name: String, surname: String, email: String, password: String) {
        
        let url = URL(string: "")!
        let json = ["name": name,"surname": surname, "email": email, "password": password]
        
        Alamofire.request(url, method: .post, parameters: json, encoding: JSONEncoding.default, headers: nil).responseJSON {
            (response) in
            
            switch(response.response?.statusCode){
            case 200:
                if let json = response.result.value as? [String: Any] {
                    let token = json["token"] as! String
                    UserDefaults.standard.set(token, forKey: "token")
                    
                    self.performSegue(withIdentifier: "register_enter_segue" , sender: nil)
                    print(token)
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
