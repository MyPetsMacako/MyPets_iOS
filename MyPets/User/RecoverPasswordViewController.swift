//
//  RecoverPasswordViewController.swift
//  MyPets
//
//  Created by alumnos on 22/01/2020.
//  Copyright © 2020 alumnos. All rights reserved.
//

import UIKit
import Alamofire
import TextFieldEffects

class RecoverPasswordViewController: UIViewController {
    var empty_email = false
    var validation_error = false
    var valid_email = false
    
    @IBOutlet weak var email_recover_text: YoshikoTextField!
    @IBOutlet weak var email_warning_label: UILabel!
    @IBOutlet weak var server_warning_label: UILabel!
    
    @IBOutlet weak var button_recover: UIButton!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    override func viewDidLoad() {
        button_recover.layer.cornerRadius = 5
        loader.isHidden = true
        let bgSetter: BGSet = BGSet()
        bgSetter.setBackground(view: self.view)
        super.viewDidLoad()
        
        email_warning_label.isHidden = true
        server_warning_label.isHidden = true
    }
    
    @IBAction func recover_password_button(_ sender: Any) {
        if !email_recover_text.text!.isEmpty{
            if isValidEmail(string: email_recover_text.text!){
                RestorePasswords(email: email_recover_text.text!)
            }else{
                self.valid_email = false
                self.email_warning_label.isHidden = false
                self.email_warning_label.text = "Introduce un email válido"
                emailTextFieldError()
                
                /*let alert = UIAlertController(title: "Error", message: "Introduzca un email válido", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
                self.present(alert,animated: true, completion: nil)*/
            }
        }else{
            validation_error = false
            empty_email = true
            server_warning_label.isHidden = true
            emailTextFieldError()
            email_recover_text.isEnabled = true
            email_warning_label.text = "Debes introducir un email"
            
            /*let alert = UIAlertController(title: "Error", message: "Rellene el email para mandar la nueva contraseña", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
            self.present(alert,animated: true, completion: nil)*/
        }
    }
    
    func RestorePasswords(email: String){
        let url = URL(string: url_base + "/passrestore")!
        let json = ["email": email]
        loader.isHidden = false
        Alamofire.request(url, method: .post, parameters: json, encoding: JSONEncoding.default, headers: nil).responseJSON {
            (response) in
            self.button_recover.isEnabled = false
            switch(response.response?.statusCode){
            case 200:
                self.loader.isHidden = true
                self.button_recover.isEnabled = true
                /*let alert = UIAlertController(title: "Correcto", message: "Nueva contraseña enviada con éxito", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
                self.present(alert,animated: true, completion: nil)*/
                self.performSegue(withIdentifier: "password_restore_segue", sender: nil)
            case 401:
                self.loader.isHidden = true
                self.button_recover.isEnabled = true
                
                self.validation_error = false
                self.empty_email = true
                self.server_warning_label.isHidden = true
                self.emailTextFieldError()
                self.email_recover_text.isEnabled = true
                self.email_warning_label.text = "El email introducido no está registrado"
                
                /*let alert = UIAlertController(title: "Error", message: "El email no existe", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
                self.present(alert,animated: true, completion: nil)*/
            default:
                self.button_recover.isEnabled = true
                print("Default")
                self.server_warning_label.isHidden = false
                self.loader.isHidden = true
                self.server_warning_label.text = "Error de conexión con el servidor"
                
            }
        }
    }
    
    func isValidEmail(string: String) -> Bool {
        let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailReg)
        return emailTest.evaluate(with: string)
    }
    @IBAction func loginButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "passToLoginSegue", sender: nil)
    }
    
    func emailTextFieldError(){
        if (validation_error == true){
            email_warning_label.isHidden = true
        } else {
            email_warning_label.isHidden = false
        }
        email_recover_text.activeBorderColor = UIColor.red
    }
    
    func emailTextFieldCorrect(){
        email_recover_text.activeBorderColor = UIColor.blue
        email_warning_label.isHidden = true
    }
    @IBAction func emailFieldOnEdit(_ sender: YoshikoTextField) {
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
