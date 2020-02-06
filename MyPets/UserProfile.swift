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
    
    @IBOutlet weak var profile_nick: UILabel!
    @IBOutlet weak var profile_name: UILabel!

    @IBOutlet weak var profile_email: UILabel!
    
    @IBOutlet weak var changePassButton: UIButton!
    @IBOutlet weak var profile_phone_number: UITextField!
    
    var name: String?
    var nick: String?
    var email: String?
    
    override func viewWillAppear(_ animated: Bool) {
        get_user_data()
    }
    func get_user_data()  {
        let url = URL(string: "http://localhost:8888/laravel-ivanodp/MyPets_API/public/index.php/api/showUserData")
        
        let token = UserDefaults.standard.string(forKey: "token")
        
        let header = ["Authorization": token]
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header as! HTTPHeaders).responseJSON { (response) in
            
            print(response.response?.statusCode)
            let json = response.result.value as! [String:Any]
            print(json)
            if response.response?.statusCode == 200{
                self.name = (json["name"] as! String)
                self.nick = (json["nickname"] as! String)
                self.email = (json["email"] as! String)
                self.set_data()
            }
        }
    }
    
    func set_data()  {
        profile_name.text = name
        profile_nick.text = nick
        profile_email.text = email
    }
    @IBAction func changePass(_ sender: Any) {
        performSegue(withIdentifier: "editPassSegue", sender: nil)
    }
}
