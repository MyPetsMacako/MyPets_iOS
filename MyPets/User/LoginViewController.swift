//
//  ViewController.swift
//  MyPets
//
//  Created by alumnos on 22/01/2020.
//  Copyright © 2020 alumnos. All rights reserved.
//

import UIKit
import Alamofire
import TextFieldEffects

//var url_base = "http://www.mypetsapp.es/api"
var url_base = "http://localhost:8888/MyPets_API/public/index.php/api"

class LoginViewController: UIViewController {
var empty_email = false
var empty_pass = false
var validation_error = false
var valid_email = false
    
    @IBOutlet weak var email_login_text: YoshikoTextField!
    @IBOutlet weak var password_login_text: YoshikoTextField!
    @IBOutlet weak var show_pass_button: UIButton!
    @IBOutlet weak var button_login: UIButton!
    @IBOutlet weak var emailWarningLabel: UILabel!
    @IBOutlet weak var passWarningLabel: UILabel!
    @IBOutlet weak var validationWarningLabel: UILabel!
    
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        button_login.layer.cornerRadius = 5
        loader.isHidden = true
        let bgSetter: BGSet = BGSet()
        bgSetter.setBackground(view: self.view)
        email_login_text.text = "ivanobejo@hotmail.es"
        password_login_text.text = "12345678"
        
        show_pass_button.titleLabel?.font = UIFont(name: "Font Awesome 5 Free", size: 20)
        show_pass_button.setTitle("\u{f06e}", for: .normal)
        emailWarningLabel.isHidden = true
        passWarningLabel.isHidden = true
        validationWarningLabel.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "loggedIn") == true {
            //self.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "autoLoginSegue", sender: nil)
        }
    }

    @IBAction func login_button(_ sender: Any) {
        
        if !email_login_text.text!.isEmpty && !password_login_text.text!.isEmpty
        {
            if (self.isValidEmail(string: self.email_login_text.text!)){
                self.valid_email = true
                LoginUser(email: email_login_text.text!, password: password_login_text.text!)
            } else {
                self.valid_email = false
                self.emailWarningLabel.isHidden = false
                self.emailWarningLabel.text = "Introduce un email válido"
            }
        } else {
            validation_error = false
            if (email_login_text.text!.isEmpty){
                empty_email = true
                validationWarningLabel.isHidden = true
                emailTextFieldError()
                email_login_text.isEnabled = true
                emailWarningLabel.text = "Debes introducir un email"
            }
            
            if (password_login_text.text!.isEmpty){
                empty_pass = true
                validationWarningLabel.isHidden = true
                passTextFieldError()
                password_login_text.isEnabled = true
                passWarningLabel.text = "Debes introducir una contraseña"
            }
        }
    }
    
    func LoginUser(email: String, password: String) {
        
        let url = URL(string: url_base + "/login")!
        let json = ["email": email, "password": password]
        
        button_login.isEnabled = false
        loader.isHidden = false
        
        if valid_email == true {
            Alamofire.request(url, method: .post, parameters: json, encoding: JSONEncoding.default, headers: nil).responseJSON {
                (response) in
                switch(response.response?.statusCode){
                case 200:
                    if let json = response.result.value as? [String: Any] {
                        let token = json["token"] as! String
                        UserDefaults.standard.set(token, forKey: "token")
                        UserDefaults.standard.set(true, forKey: "loggedIn")
                        self.button_login.isEnabled = true
                        self.loader.isHidden = true
                        print("llega")
                        self.performSegue(withIdentifier: "login_user_good", sender: nil)
                        //self.dismiss(animated: true, completion: nil)
                    }
                case 401:
                    self.loader.isHidden = true
                    self.button_login.isEnabled = true
                    
                    self.validationWarningLabel.isHidden = false
                    self.validationWarningLabel.text = "Email o contraseña incorrectos"
                    self.validation_error = true
                    self.emailTextFieldError()
                    self.passTextFieldError()
                    
                default:
                    self.button_login.isEnabled = true
                    print("Respuesta erronea")
                    self.validationWarningLabel.isHidden = false
                    self.loader.isHidden = true
                    self.validationWarningLabel.text = "Error de conexión con el servidor"
                }
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
    
    func emailTextFieldError(){
        if (validation_error == true){
            emailWarningLabel.isHidden = true
        } else {
           emailWarningLabel.isHidden = false
        }
        email_login_text.activeBorderColor = UIColor.red
    }
    
    func emailTextFieldCorrect(){
        email_login_text.activeBorderColor = UIColor.blue
        emailWarningLabel.isHidden = true
    }
    
    func passTextFieldError(){
        if (validation_error == true){
            passWarningLabel.isHidden = true
        } else {
            passWarningLabel.isHidden = false
        }
        password_login_text.activeBorderColor = UIColor.red
    }
    
    func passTextFieldCorrect(){
        password_login_text.activeBorderColor = UIColor.blue
        passWarningLabel.isHidden = true
    }
    
    @IBAction func emailCorrectEmptyFiled(_ sender: YoshikoTextField) {
        if (validation_error == true){
            
        } else {
            if (empty_email == true){
                emailTextFieldCorrect()
            }
            if(empty_email == true && sender.text == ""){
                emailTextFieldError()
            }
        }
    }
    
    @IBAction func passCorrectEmptyFiled(_ sender: YoshikoTextField) {
        if (validation_error == true){
            
        } else {
            if (empty_pass == true){
                passTextFieldCorrect()
            }
            if(empty_pass == true && sender.text == ""){
                passTextFieldError()
            }
        }
    }
    
    func isValidEmail(string: String) -> Bool {
        let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailReg)
        return emailTest.evaluate(with: string)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

