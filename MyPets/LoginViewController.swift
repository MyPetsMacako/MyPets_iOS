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
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.isHidden = true
        
        email_login_text.text = "ivanobejo@hotmail.es"
        password_login_text.text = "12345678"
        
    }

    @IBAction func login_button(_ sender: Any) {
        
        if !email_login_text.text!.isEmpty && !password_login_text.text!.isEmpty
        {
            LoginUser(email: email_login_text.text!, password: password_login_text.text!)
        } else {
            let alert = UIAlertController(title: "Error", message: "Rellene los campos para iniciar sesión", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
            self.present(alert,animated: true, completion: nil)
        }
    }
    
    func LoginUser(email: String, password: String) {
        
        let url = URL(string: "http://localhost:8888/laravel-ivanodp/MyPets_API/public/index.php/api/login")!
        let json = ["email": email, "password": password]
        
        loader.isHidden = false
        Alamofire.request(url, method: .post, parameters: json, encoding: JSONEncoding.default, headers: nil).responseJSON {
            (response) in
            switch(response.response?.statusCode){
            case 200:
                if let json = response.result.value as? [String: Any] {
                    
                    let token = json["token"] as! String
                    UserDefaults.standard.set(token, forKey: "token")
                    print("llega")
                    self.performSegue(withIdentifier: "login_user_good", sender: nil)
                }
            case 401:
                self.loader.isHidden = true
                let alert = UIAlertController(title: "Error", message: "Los datos introducidos no son correctos", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
                self.present(alert,animated: true, completion: nil)
            default:
                print("Respuesta erronea")
            }
        }
    }
    
    @IBAction func see_pass(_ sender: UIButton) {
        if password_login_text.isSecureTextEntry{
            password_login_text.isSecureTextEntry = false
        }else{
            password_login_text.isSecureTextEntry = true
        }
    }
    @IBAction func registerButton(_ sender: Any) {
        performSegue(withIdentifier: "registerSegue", sender: nil)
    }
    
    @IBAction func editPassButton(_ sender: Any) {
        performSegue(withIdentifier: "editPassSegue", sender: nil)
    }
}

