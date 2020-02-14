//
//  EditPassword.swift
//  MyPets
//
//  Created by Iván Obejo on 06/02/2020.
//  Copyright © 2020 alumnos. All rights reserved.
//

import UIKit

import Alamofire

import AlamofireImage

class EditPassword: UIViewController {
    
    @IBOutlet weak var oldPass: UITextField!
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var confirmNewPass: UITextField!
    
    @IBOutlet weak var button_confirm: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var warningLabel: UILabel!
    @IBAction func saveChanges(_ sender: Any) {
        change_password()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bgSetter: BGSet = BGSet()
        bgSetter.setBackground(view: self.view)
        loader.isHidden = true
        warningLabel.isHidden = true
    }
    
    func change_password()  {
        let url = URL(string: "http://localhost:8888/MyPets_API/public/index.php/api/restorePassword")
        var new_password_Str = ""
        let token = UserDefaults.standard.string(forKey: "token")
        
        let header = ["Authorization": token]
        if (newPass.text == confirmNewPass.text){
            new_password_Str = newPass.text!
        }
        let json = ["new_password": new_password_Str, "old_password": oldPass.text!, "repeat_new_password": confirmNewPass.text!] as [String : Any]
        loader.isHidden = false
        button_confirm.isEnabled = false
        Alamofire.request(url!, method: .post, parameters: json, encoding: JSONEncoding.default, headers: (header as! HTTPHeaders)).responseJSON { (response) in
            
            if response.response?.statusCode == 200{
                print("Se ha cambiado")
                _ = self.navigationController?.popViewController(animated: true)
            }
            if response.response?.statusCode == 401{
                self.loader.isHidden = true
                self.button_confirm.isEnabled = true
                print("error")
                self.warningLabel.isHidden = false
            }
        }
    }
}

