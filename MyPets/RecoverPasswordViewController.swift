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
    
    @IBOutlet weak var button_recover: UIButton!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    override func viewDidLoad() {
        loader.isHidden = true
        let bgSetter: BGSet = BGSet()
        bgSetter.setBackground(view: self.view)
        super.viewDidLoad()
    }
    
    @IBAction func recover_password_button(_ sender: Any) {
        if !email_recover_text.text!.isEmpty{
            if isValidEmail(string: email_recover_text.text!){
                RestorePasswords(email: email_recover_text.text!)
            }else{
                let alert = UIAlertController(title: "Error", message: "Introduzca un email válido", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
                self.present(alert,animated: true, completion: nil)
            }
        }else{
            let alert = UIAlertController(title: "Error", message: "Rellene el email para mandar la nueva contraseña", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
            self.present(alert,animated: true, completion: nil)
        }
    }
    
    func RestorePasswords(email: String){
        let url = URL(string: "http://localhost:8888/MyPets_API/public/index.php/api/passrestore")!
        let json = ["email": email]
        loader.isHidden = false
        Alamofire.request(url, method: .post, parameters: json, encoding: JSONEncoding.default, headers: nil).responseJSON {
            (response) in
            self.button_recover.isEnabled = false
            switch(response.response?.statusCode){
            case 200:
                let alert = UIAlertController(title: "Correcto", message: "Nueva contraseña enviada con éxito", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
                self.present(alert,animated: true, completion: nil)
                self.performSegue(withIdentifier: "password_restore_segue", sender: nil)
            case 401:
                self.loader.isHidden = true
                self.button_recover.isEnabled = true
                let alert = UIAlertController(title: "Error", message: "El email no existe", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
                self.present(alert,animated: true, completion: nil)
            default:
                self.button_recover.isEnabled = true
                print("Default")
                
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
}
