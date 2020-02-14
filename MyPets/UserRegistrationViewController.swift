//SUYOOOOOOO
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
    @IBOutlet weak var nick_register_text: UITextField!
    @IBOutlet weak var email_register_text: UITextField!
    @IBOutlet weak var password_register_text: UITextField!
    @IBOutlet weak var password_registert_text_confirm: UITextField!
    @IBOutlet weak var button_register: UIButton!
    
    @IBOutlet weak var pass_error: UILabel!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        loader.isHidden = true
        let bgSetter: BGSet = BGSet()
        bgSetter.setBackground(view: self.view)
        super.viewDidLoad()
        
    }
    
    @IBAction func user_registration_button(_ sender: Any) {
            if !name_register_text.text!.isEmpty && !nick_register_text.text!.isEmpty && !email_register_text.text!.isEmpty{
                if isValidEmail(string: email_register_text.text!){
                    if password_register_text.text == password_registert_text_confirm.text{
                        register_user(name: name_register_text.text!, nick: nick_register_text.text!, email: email_register_text.text!, password: password_register_text.text!)
                    }else{
                        let alert = UIAlertController(title: "Error", message: "Las contraseñas no coinciden", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
                        self.present(alert,animated: true, completion: nil)
                    }
                }else{
                    let alert = UIAlertController(title: "Error", message: "El email no es válido", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
                    self.present(alert,animated: true, completion: nil)
                }
            }else{
                let alert = UIAlertController(title: "Error", message: "Rellene todos los campos para registrarse", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
                self.present(alert,animated: true, completion: nil)
            }
    }
    
    func register_user(name: String, nick: String, email: String, password: String) {
        
        button_register.isEnabled = false
        loader.isHidden = false
        
        let url = URL(string: "http://localhost:8888/MyPets_API/public/index.php/api/register")!
        let json = ["fullname": name, "nickname": nick, "email": email, "password": password]
        Alamofire.request(url, method: .post, parameters: json, encoding: JSONEncoding.default, headers: nil).responseJSON {
            (response) in
        switch(response.response?.statusCode){
            case 200:
                if let json = response.result.value as? [String: Any] {
                    let token = json["token"] as! String
                    UserDefaults.standard.set(token, forKey: "token")
                    self.loader.isHidden = true
                    print("llega")
                    self.performSegue(withIdentifier: "register_user_good", sender: nil)
                }
            case 401:
                self.button_register.isEnabled = true
                self.loader.isHidden = true
                let alert = UIAlertController(title: "Error", message: "No ha sido posible registrarse", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
                self.present(alert,animated: true, completion: nil)
            default:
                print("Respuesta erronea")
            }
        }
    }
    
    @IBAction func check_pass(_ sender: UITextField) {
        if sender.text!.count >= 8{
            button_register.isEnabled = true
            pass_error.isHidden = true
        }else{
            button_register.isEnabled = false
            pass_error.isHidden = false
        }
    }
    
    func isValidEmail(string: String) -> Bool {
        let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailReg)
        return emailTest.evaluate(with: string)
    }

    @IBAction func see_pass(_ sender: UIButton) {
        if password_register_text.isSecureTextEntry{
            password_register_text.isSecureTextEntry = false
            password_registert_text_confirm.isSecureTextEntry = false
        }else{
            password_register_text.isSecureTextEntry = true
            password_registert_text_confirm.isSecureTextEntry = true
        }
    }
    
    @IBAction func goToLogin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "registerToLoginSegue", sender: nil)
    }
    
}
