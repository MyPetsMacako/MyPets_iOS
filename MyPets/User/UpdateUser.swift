//
//  UpdateUser.swift
//  MyPets
//
//  Created by alumnos on 20/02/2020.
//  Copyright © 2020 alumnos. All rights reserved.
//

import Alamofire
import AlamofireImage
import UIKit

class UpdateUser: UIViewController {
    
    @IBOutlet weak var user_image: UIImageView!
    @IBOutlet weak var user_phone: UITextField!
    var image_picker: ImagePicker!
    var phone: String?
    var image_user: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       /* self.image_picker = ImagePicker(presentationController: self, delegate: self)*/
        user_image.image = user_image.image?.af_imageRoundedIntoCircle()
        let bgSetter: BGSet = BGSet()
        bgSetter.setBackground(view: self.view)
    }
    
    func updateUser()  {
        let url = URL(string: url_base + "/updateUser")
        let token = UserDefaults.standard.string(forKey: "token")
        let header = ["Authorization": token]
        
        let json = ["tel_number": phone]
        let image_data = user_image.image?.pngData()
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in json {
                multipartFormData.append(value!.data(using: .utf8)!, withName: key)
            }
            multipartFormData.append(image_data!, withName: "image", fileName: "image.png", mimeType: "image/jpeg")
        }, to:url!, method: .post, headers: (header as! HTTPHeaders)) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    _ = self.navigationController?.popViewController(animated: true)
                }
            case .failure(let encodingError):
                print("ERROR ", encodingError)
            }
        }
    }
    
    @IBAction func button_image(_ sender: UIButton) {
        self.image_picker.present(from: sender)
    }
    
    @IBAction func accept(_ sender: UIButton) {
        if !user_phone.text!.isEmpty{
            phone = user_phone.text
            if image_user != nil{
                updateUser()
            }else{
                
            }
        }else{
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

/*extension UpdateUser: ImagePickerDelegate{
    public func didSelect(image: UIImage?) {
        if image != nil{
            image_user = image
            self.user_image.image = image
            user_image.image = user_image.image!.af_imageRoundedIntoCircle()
        }
    }
}*/
