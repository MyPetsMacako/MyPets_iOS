//
//  PetsDetail.swift
//  MyPets
//
//  Created by alumnos on 05/02/2020.
//  Copyright © 2020 alumnos. All rights reserved.
//
import UIKit

import Alamofire

import AlamofireImage

class PetDetail: UIViewController {
    
    @IBOutlet weak var pet_name: UITextField!
    @IBOutlet weak var pet_breed: UITextField!
    @IBOutlet weak var pet_weight: UITextField!
    @IBOutlet weak var pet_color: UITextField!
    @IBOutlet weak var pet_birth_date: UITextField!
    @IBOutlet weak var pet_image: UIImageView!
    @IBOutlet weak var button_image_picker: UIButton!
    @IBOutlet weak var qr_image: UIImageView!
    
    @IBOutlet weak var button_qr: UIButton!
    var image_picker: ImagePicker!
    
    @IBOutlet weak var see_documents_outlet: UIButton!
    @IBOutlet weak var save_changes_outlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        see_documents_outlet.layer.cornerRadius = 5
        show_pet_data()
        
        print("documento", document)
        pet_name.isUserInteractionEnabled = false
        pet_breed.isUserInteractionEnabled = false
        pet_weight.isUserInteractionEnabled = false
        pet_color.isUserInteractionEnabled = false
        pet_birth_date.isUserInteractionEnabled = false
        pet_name.borderStyle = .none
        pet_breed.borderStyle = .none
        pet_weight.borderStyle = .none
        pet_color.borderStyle = .none
        pet_birth_date.borderStyle = .none
      
        button_image_picker.isHidden = true
        see_documents_outlet.isHidden = false
        save_changes_outlet.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let bgSetter: BGSet = BGSet()
        bgSetter.setBackground(view: self.view)
        
        self.image_picker = ImagePicker(presentationController: self, delegate: self)
           pet_image.image = pet_image.image?.af_imageRoundedIntoCircle()
          button_image_picker.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func edit_button(_ sender: Any) {
        if !pet_name.isUserInteractionEnabled{
            pet_name.isUserInteractionEnabled = true
            pet_breed.isUserInteractionEnabled = true
            pet_weight.isUserInteractionEnabled = true
            pet_color.isUserInteractionEnabled = true
            pet_birth_date.isUserInteractionEnabled = true
            button_image_picker.isEnabled = true
            pet_name.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.9529411765, blue: 0.9764705882, alpha: 1)
            pet_breed.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.9529411765, blue: 0.9764705882, alpha: 1)
            pet_weight.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.9529411765, blue: 0.9764705882, alpha: 1)
            pet_color.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.9529411765, blue: 0.9764705882, alpha: 1)
            pet_birth_date.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.9529411765, blue: 0.9764705882, alpha: 1)
            see_documents_outlet.isHidden = true
            save_changes_outlet.isHidden = false
              button_image_picker.isHidden = false
        }else{
            pet_name.isUserInteractionEnabled = false
            pet_breed.isUserInteractionEnabled = false
            pet_weight.isUserInteractionEnabled = false
            pet_color.isUserInteractionEnabled = false
            pet_birth_date.isUserInteractionEnabled = false
            button_image_picker.isEnabled = false
            pet_name.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            pet_breed.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            pet_weight.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            pet_color.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            pet_birth_date.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            see_documents_outlet.isHidden = false
            save_changes_outlet.isHidden = true
              button_image_picker.isHidden = true
        }
    }
    
    @IBAction func save_button(_ sender: Any) {
        change_pet_data()
        pet_name.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        pet_breed.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        pet_weight.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        pet_color.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        pet_birth_date.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        see_documents_outlet.isHidden = false
        save_changes_outlet.isHidden = true
        
        let alert = UIAlertController(title: "CORRECTO", message: "Los datos de su mascota se han modificado", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (accion) in}))
        self.present(alert,animated: true, completion: nil)
    }
    
    
    func change_pet_data()
    {
        let id_send = String(id!)
        let url = URL(string: url_base + "/updatePet/" + id_send)
        
        let token = UserDefaults.standard.string(forKey: "token")
        let json_update = ["name": pet_name.text, "birth_date": pet_birth_date.text, "breed": pet_breed.text, "weight": pet_weight.text, "color": pet_color.text]
        let header = ["Authorization": token]
        print(json_update)
        
        let image_data = pet_image.image!.jpegData(compressionQuality: 0.5)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in json_update {
                multipartFormData.append(value!.data(using: .utf8)!, withName: key)
            }
            //multipartFormData.append(image_data!, withName: "image", fileName: "image.png", mimeType: "image/jpeg")
            multipartFormData.append(image_data!, withName: "photo", fileName: "image.png", mimeType: "image/jpeg")
        }, to:url!, method: .post, headers: (header as! HTTPHeaders)) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response.response?.statusCode)
                    print(response)
                }
            case .failure(let encodingError):
                print("ERROR ", encodingError)
            }
            
        }
    }
    
    func show_pet_data(){
        print(name)
        pet_name.text = name
        pet_breed.text = breed
        pet_weight.text = weight
        pet_color.text = color
        pet_birth_date.text = birth_date
        pet_image.image = pet_image.image?.af_imageRoundedIntoCircle()
        let url_qr = URL(string: qr!)
        qr_image.af_setImage(withURL: url_qr!)
        if image != "."
        {
            let url = URL(string: image!)!
            pet_image.af_setImage(withURL: url)
            print("documento", document)
        }
       
    }
    
    
    @IBAction func image_picker(_ sender: UIButton)
    {
         self.image_picker.present(from: sender)
    }
}

extension PetDetail: ImagePickerDelegate{
    public func didSelect(image: UIImage?) {
        if image != nil{
            self.pet_image.image = image
            pet_image.image = pet_image.image!.af_imageRoundedIntoCircle()
        }
    }
}
