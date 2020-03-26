//
//  UserProfile.swift
//  MyPets
//
//  Created by alumnos on 31/01/2020.
//  Copyright © 2020 alumnos. All rights reserved.
//

import UIKit

import Alamofire

import AlamofireImage

class UserProfile: UIViewController {
    
    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var profile_name: UITextField!
    @IBOutlet weak var profile_nick: UITextField!
    @IBOutlet weak var profile_email: UITextField!
    @IBOutlet weak var changePassButton: UIButton!
    @IBOutlet weak var phone_number: UITextField!
    @IBOutlet weak var button_image_picker: UIButton!
    @IBOutlet weak var logOffButton: UIButton!
    
    var name: String?
    var nick: String?
    var email: String?
    var phone: String?
    var image: String?
    var image_picker: ImagePicker!
    
    var cellsNum = 0
    var reloadedTimes = 0
    
    @IBOutlet weak var save_button_outlet: UIButton!
    
    override func viewDidLoad() {
        get_user_data()
        save_button_outlet.layer.cornerRadius = 5
        profile_name.isUserInteractionEnabled = false
        profile_nick.isUserInteractionEnabled = false
        profile_email.isUserInteractionEnabled = false
        phone_number.isUserInteractionEnabled = false
        profile_name.borderStyle = .none
        profile_nick.borderStyle = .none
        profile_email.borderStyle = .none
        phone_number.borderStyle = .none
        profile_image.image = profile_image.image?.af_imageRoundedIntoCircle()
        
        save_button_outlet.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let bgSetter: BGSet = BGSet()
        bgSetter.setBackground(view: self.view)
        
        self.image_picker = ImagePicker(presentationController: self, delegate: self)
        get_user_data()
        profile_image.image = profile_image.image?.af_imageRoundedIntoCircle()
    }
    
    
    @IBAction func edit_buton(_ sender: Any)
    {
        if !profile_name.isUserInteractionEnabled{
            profile_name.isUserInteractionEnabled = true
            profile_nick.isUserInteractionEnabled = true
            profile_email.isUserInteractionEnabled = true
            phone_number.isUserInteractionEnabled = true
            button_image_picker.isEnabled = true
            profile_name.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.9529411765, blue: 0.9764705882, alpha: 1)
            profile_nick.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.9529411765, blue: 0.9764705882, alpha: 1)
            profile_email.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.9529411765, blue: 0.9764705882, alpha: 1)
            phone_number.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.9529411765, blue: 0.9764705882, alpha: 1)
            save_button_outlet.isHidden = false
        }else{
            profile_name.isUserInteractionEnabled = false
            profile_nick.isUserInteractionEnabled = false
            profile_email.isUserInteractionEnabled = false
            phone_number.isUserInteractionEnabled = false
            button_image_picker.isEnabled = false
            profile_name.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            profile_nick.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            profile_email.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            phone_number.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            save_button_outlet.isHidden = true
        }
    }
    
    
    @IBAction func save_data_user(_ sender: Any)
    {
        change_user_data()
        profile_name.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        profile_nick.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        profile_email.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        phone_number.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        save_button_outlet.isHidden = true
    }
    
    func change_user_data()
    {
        let url = URL(string: url_base + "/updateUser")
        
        let token = UserDefaults.standard.string(forKey: "token")
        //let name = profile_name.text
        //let email = profile_email.text
        let json_update = ["fullName": profile_name.text, "nickname": profile_nick.text, "email": profile_email.text, "tel_number": phone_number.text]
        let header = ["Authorization": token]
        print(json_update)
        
        let image_data = profile_image.image!.jpegData(compressionQuality: 0.5)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in json_update {
                multipartFormData.append(value!.data(using: .utf8)!, withName: key)
            }
            multipartFormData.append(image_data!, withName: "image", fileName: "image.png", mimeType: "image/jpeg")
        }, to:url!, method: .post, headers: (header as! HTTPHeaders)) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response.response?.statusCode)
                    print(response)
                    self.get_user_data()
                }
            case .failure(let encodingError):
                print("ERROR ", encodingError)
            }
    
        }
    }
    
    func get_user_data()  {
        let url = URL(string: url_base + "/showUserData")
        
        let token = UserDefaults.standard.string(forKey: "token")
        
        let header = ["Authorization": token]
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header as? HTTPHeaders).responseJSON { (response) in
            
            let json = response.result.value as! [String:Any]
            print(json)
            if response.response?.statusCode == 200{
                self.name = (json["name"] as! String)
                self.nick = (json["nickname"] as! String)
                self.email = (json["email"] as! String)
                
                self.phone = (json["telephone"] as! String)
                self.image = (json["photo"] as! String)
                self.set_data()
            }
        }
    }
    
    func set_data()  {
        profile_name.text = name
        profile_nick.text = nick
        profile_email.text = email
        if image != "."{
            phone_number.text = phone
            print(image)
            let url = URL(string: image!)!
            print(url)
            profile_image.af_setImage(withURL: url)
        }
        reloadView()
    }
    @IBAction func changePass(_ sender: Any) {
        performSegue(withIdentifier: "editPassSegue", sender: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func button_image(_ sender: UIButton)
    {
        self.image_picker.present(from: sender)
    }
    @IBAction func logOffAction(_ sender: Any) {
        let token = UserDefaults.standard
        token.removeObject(forKey: "token")
        UserDefaults.standard.set(false, forKey: "loggedIn")
        token.synchronize()
        self.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "singOffSegue", sender: nil)
    }
    func reloadView(){
        if reloadedTimes == 0{
            reloadedTimes+=1
            self.viewWillAppear(true)
        }
        
    }
}

extension UserProfile: ImagePickerDelegate{
    public func didSelect(image: UIImage?) {
        if image != nil{
            print(image)
            self.profile_image.image = image
            profile_image.image = profile_image.image!.af_imageRoundedIntoCircle()
        }
    }
}
