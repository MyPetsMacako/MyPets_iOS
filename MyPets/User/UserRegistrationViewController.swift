//SUYOOOOOOO
//  UserRegistrationViewController.swift
//  MyPets
//
//  Created by alumnos on 22/01/2020.
//  Copyright © 2020 alumnos. All rights reserved.
//

import UIKit
import Alamofire
import TextFieldEffects

class UserRegistrationViewController: UIViewController {
    var empty_email = false
    var empty_nickname = false
    var empty_name = false
    var empty_pass = false
    var empty_passConfirm = false
    var validation_error = false
    
    
    var valid_name = false
    var valid_nickname = false
    var valid_email = false
    var valid_pass = false
    var valid_passConfirm = false
    
    var areAllFieldsFilled = false
    
    let emptyFieldText = "Debes rellenar este campo"
    
    @IBOutlet weak var name_register_text: YoshikoTextField!
    @IBOutlet weak var nick_register_text: YoshikoTextField!
    @IBOutlet weak var email_register_text: YoshikoTextField!
    @IBOutlet weak var password_register_text: YoshikoTextField!
    @IBOutlet weak var password_registert_text_confirm: YoshikoTextField!
    
    
    @IBOutlet weak var button_register: UIButton!
    
    
    @IBOutlet weak var nameWarningLabel: UILabel!
    @IBOutlet weak var nicknameWarningLabel: UILabel!
    @IBOutlet weak var emailWarningLabel: UILabel!
    @IBOutlet weak var passWarningLabel: UILabel!
    @IBOutlet weak var serverWaningLabel: UILabel!
    @IBOutlet weak var pass_error: UILabel!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var show_pass_button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button_register.layer.cornerRadius = 5
        loader.isHidden = true
        let bgSetter: BGSet = BGSet()
        bgSetter.setBackground(view: self.view)
        
        show_pass_button.titleLabel?.font = UIFont(name: "Font Awesome 5 Free", size: 20)
        show_pass_button.setTitle("\u{f06e}", for: .normal)
        
        nameWarningLabel.isHidden = true
        nicknameWarningLabel.isHidden = true
        emailWarningLabel.isHidden = true
        passWarningLabel.isHidden = true
        serverWaningLabel.isHidden = true
        pass_error.isHidden = true
    }
    
    @IBAction func user_registration_button(_ sender: Any) {
        if (name_register_text.text!.isEmpty){
            areAllFieldsFilled = false
            self.nameWarningLabel.isHidden = false
            self.nameWarningLabel.text = emptyFieldText
            self.validation_error = true
            self.nameTextFieldError()
            valid_name = false
        } else {
            valid_name = true
        }
        
        if (nick_register_text.text!.isEmpty){
            areAllFieldsFilled = false
            self.nicknameWarningLabel.isHidden = false
            self.nicknameWarningLabel.text = emptyFieldText
            self.validation_error = true
            self.nicknameTextFieldError()
            valid_nickname = false
        } else {
            valid_nickname = true
        }
        
        if (email_register_text.text!.isEmpty){
            areAllFieldsFilled = false
            self.emailWarningLabel.isHidden = false
            self.emailWarningLabel.text = emptyFieldText
            self.validation_error = true
            self.emailTextFieldError()
        } else {
            if (isValidEmail(string: email_register_text.text!)){
                valid_email = true
            } else {
                self.emailWarningLabel.isHidden = false
                self.emailWarningLabel.text = "Introduce un email válido"
                self.validation_error = true
                self.emailTextFieldError()
                valid_email = false
            }
        }
        
        if (password_register_text.text!.isEmpty){
            areAllFieldsFilled = false
            self.passWarningLabel.isHidden = false
            self.passWarningLabel.text = emptyFieldText
            self.validation_error = true
            self.passTextFieldError()
        } else {
            if password_register_text.text!.count >= 8{
                passWarningLabel.isHidden = true
            } else {
                passWarningLabel.isHidden = false
                passTextFieldError()
            }
        }
        
        if (password_registert_text_confirm.text!.isEmpty){
            areAllFieldsFilled = false
            self.pass_error.isHidden = false
            self.pass_error.text = emptyFieldText
            self.validation_error = true
            self.passConfirmTextFieldError()
        } else {
            if password_registert_text_confirm.text!.count >= 8{
                pass_error.isHidden = true
                
            } else {
                pass_error.isHidden = false
                passConfirmTextFieldError()
                
            }
            
            if password_register_text.text == password_registert_text_confirm.text {
                print("Son iguales")
                pass_error.isHidden = true
                passWarningLabel.isHidden = true
                } else {
                pass_error.text = "Las contraseñas no coinciden"
                passWarningLabel.text = "Las contraseñas no coinciden"
                valid_pass = false
                valid_passConfirm = false
                passTextFieldError()
                passConfirmTextFieldError()
            }
        }
        
        if password_register_text.text == password_registert_text_confirm.text && password_register_text.text!.count < 8 && password_registert_text_confirm.text!.count < 8 {
            
            passWarningLabel.isHidden = false
            passWarningLabel.text = "Las contraseñas deben tener 8 caracteres"
            pass_error.isHidden = false
            pass_error.text = "Las contraseñas deben tener 8 caracteres"
            valid_pass = false
            valid_passConfirm = false
        }
        
        if password_register_text.text == password_registert_text_confirm.text && password_register_text.text!.count >= 8 && password_registert_text_confirm.text!.count >= 8 {
            
            valid_pass = true
            valid_passConfirm = true
        }
        
        if valid_name == true && valid_nickname == true && valid_email == true && valid_pass == true && valid_passConfirm == true {
            register_user(name: name_register_text.text!, nick: nick_register_text.text!, email: email_register_text.text!, password: password_register_text.text!)
        }
        
        
        /*if !name_register_text.text!.isEmpty && !nick_register_text.text!.isEmpty && !email_register_text.text!.isEmpty{
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
            }*/
    }
    
    func register_user(name: String, nick: String, email: String, password: String) {
        
        loader.isHidden = false
        
        let url = URL(string: url_base + "/register")!
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
                    
                    let alert = UIAlertController(title: "¡Bienvenido!", message: "Disfruta de tus mascotas", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "¡Gracias!", style: .cancel, handler: { action in self.performSegue(withIdentifier: "register_user_good", sender: nil)}))
                    self.present(alert,animated: true, completion: nil)
                }
            case 453:
                self.loader.isHidden = true
            
                self.emailWarningLabel.isHidden = false
                self.emailWarningLabel.text = "El email ya está registrado"
                self.validation_error = true
                self.emailTextFieldError()
            
            case 454:
                self.loader.isHidden = true
                
                self.nicknameWarningLabel.isHidden = false
                self.nicknameWarningLabel.text = "El nickname ya está registrado"
                self.validation_error = true
                self.nicknameTextFieldError()
            
            default:
                print("Respuesta erronea")
                self.serverWaningLabel.isHidden = false
                self.loader.isHidden = true
                self.serverWaningLabel.text = "Error de conexión con el servidor"
            }
        }
    }
    
    @IBAction func check_pass(_ sender: UITextField) {
        if sender.text!.count >= 8{
            passWarningLabel.isHidden = true
            pass_error.isHidden = true
        }else{
            passWarningLabel.text = "Las contraseñas deben tener 8 caracteres"
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
    
    func nameTextFieldError(){
        if (validation_error == false){
            nameWarningLabel.isHidden = true
        } else {
            nameWarningLabel.isHidden = false
        }
        name_register_text.activeBorderColor = UIColor.red
    }
    
    func nameTextFieldCorrect(){
        name_register_text.activeBorderColor = UIColor.blue
        nameWarningLabel.isHidden = true
    }
    
    func nicknameTextFieldError(){
        if (validation_error == false){
            nicknameWarningLabel.isHidden = true
        } else {
            nicknameWarningLabel.isHidden = false
        }
        nick_register_text.activeBorderColor = UIColor.red
    }
    
    func nicknameTextFieldCorrect(){
        nick_register_text.activeBorderColor = UIColor.blue
        nicknameWarningLabel.isHidden = true
    }
    
    func emailTextFieldError(){
        if (validation_error == false){
            emailWarningLabel.isHidden = true
        } else {
            emailWarningLabel.isHidden = false
        }
        email_register_text.activeBorderColor = UIColor.red
    }
    
    func emailTextFieldCorrect(){
        email_register_text.activeBorderColor = UIColor.blue
        emailWarningLabel.isHidden = true
    }
    
    func passTextFieldError(){
        if (validation_error == false){
            passWarningLabel.isHidden = true
        } else {
            passWarningLabel.isHidden = false
        }
        password_register_text.activeBorderColor = UIColor.red
    }
    
    func passTextFieldCorrect(){
        password_register_text.activeBorderColor = UIColor.blue
        passWarningLabel.isHidden = true
    }
    
    func passConfirmTextFieldError(){
        if (validation_error == false){
            pass_error.isHidden = true
        } else {
            pass_error.isHidden = false
        }
        password_registert_text_confirm.activeBorderColor = UIColor.red
    }
    
    func passConfirmTextFieldCorrect(){
        password_registert_text_confirm.activeBorderColor = UIColor.blue
        pass_error.isHidden = true
    }
    
    
    @IBAction func editedNameTF(_ sender: YoshikoTextField) {
        if (sender.text != ""){
            nameTextFieldCorrect()
        } else {
            nameTextFieldError()
        }
    }
    
    @IBAction func editedNickTF(_ sender: YoshikoTextField) {
        if (sender.text != ""){
            nicknameTextFieldCorrect()
        } else {
            nicknameTextFieldError()
        }
    }
    
    @IBAction func editedEmailTF(_ sender: YoshikoTextField) {
        if (sender.text != ""){
            emailTextFieldCorrect()
        } else {
            emailTextFieldError()
        }
    }
    @IBAction func editedPassTF(_ sender: YoshikoTextField) {
        if (sender.text != ""){
            passTextFieldCorrect()
        } else {
            passTextFieldError()
        }
    }
    @IBAction func editedPassConfirmTF(_ sender: YoshikoTextField) {
        if (sender.text != ""){
            passConfirmTextFieldCorrect()
        } else {
            passConfirmTextFieldError()
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
}

