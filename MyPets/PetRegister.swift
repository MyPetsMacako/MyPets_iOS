//
//  PetRegister.swift
//  MyPets
//
//  Created by alumnos on 05/02/2020.
//  Copyright © 2020 alumnos. All rights reserved.
//
import UIKit

import Alamofire

import AlamofireImage

var selected_image: UIImageView?
class PetRegister: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var pet_image: UIImageView!
    @IBOutlet weak var pet_name: UITextField!
    @IBOutlet weak var species_picker: UIPickerView!
    @IBOutlet weak var pet_breed: UITextField!
    @IBOutlet weak var pet_color: UITextField!
    @IBOutlet weak var pet_weight: UITextField!
    @IBOutlet weak var birthday_picker: UIDatePicker!
    @IBOutlet weak var button_save: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var date_error: UILabel!
    
    let species = ["Perro", "Gato", "Reptil", "Roedor", "Ave"]
    var selected_specie = "Perro"
    var date_str: String?
    
    var name: String?
    var breed: String?
    var color: String?
    var weight: String?
    var image: UIImage?
    var image_picker: ImagePicker!
    
    override func viewWillAppear(_ animated: Bool) {
        pet_image.image = pet_image.image?.af_imageRoundedIntoCircle()
        self.image_picker = ImagePicker(presentationController: self, delegate: self as! ImagePickerDelegate)
        loader.isHidden = true
        let bgSetter: BGSet = BGSet()
        bgSetter.setBackground(view: self.view)
        species_picker.dataSource = self
        species_picker.delegate = self
    }
    
    func checkData() -> Bool {
        if !pet_name.text!.isEmpty && !pet_breed.text!.isEmpty && !pet_color.text!.isEmpty && !pet_weight.text!.isEmpty && pet_image.image != nil{
            name = pet_name.text
            breed = pet_breed.text
            color = pet_color.text
            weight =  pet_weight.text!
            image = pet_image.image
            print("Datos correctos")
            return true
        }else{
            let alert = UIAlertController(title: "Error", message: "Rellene todos los datos para registrar la mascota", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
            self.present(alert,animated: true, completion: nil)
            return false
        }
    }
    @IBAction func save_button(_ sender: UIButton) {
        if date_str != nil {
            if checkData(){
                postPet()
            }
        }else{
            let alert = UIAlertController(title: "Error", message: "La fecha es incorrecta", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
            self.present(alert,animated: true, completion: nil)
        }
    }
    
    func postPet(){
        let url = URL(string: "http://localhost:8888/MyPets_API/public/index.php/api/petsRegister")
        let token = UserDefaults.standard.string(forKey: "token")
        let header = ["Authorization": token]
        
        let json = ["name": name!, "species": selected_specie, "breed": breed!, "colour": color!, "weight": weight!, "birth_date": date_str!]
        loader.isHidden = false
        button_save.isEnabled = false
        /*
        Alamofire.request(url!, method: .post, parameters: json, encoding: JSONEncoding.default, headers: (header as! HTTPHeaders)).responseJSON { (response) in
           
            if response.response?.statusCode == 200{
                print("mascota registrada")
                _ = self.navigationController?.popViewController(animated: true)
            }else if response.response?.statusCode == 401{
                self.loader.isHidden = true
                self.button_save.isEnabled = true
                let alert = UIAlertController(title: "Error", message: "No ha sido posible registrar la mascota", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
                self.present(alert,animated: true, completion: nil)
            }else{
                self.button_save.isEnabled = true
                self.loader.isHidden = true
                print("Peticion incorrecta")
            }
        }
        */
        let image_data = pet_image.image?.pngData()
        print(image_data)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in json {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }
            multipartFormData.append(image_data!, withName: "image", fileName: "image.png", mimeType: "image/jpeg")
        }, to:url!,
           method: .post,
           headers: (header as! HTTPHeaders))
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response.response?.statusCode)
                    print(response.result.value)
                    self.loader.isHidden = true
                    self.button_save.isEnabled = true
                    _ = self.navigationController?.popViewController(animated: true)
                }
            case .failure(let encodingError):
                print("ERROR ", encodingError)
                self.loader.isHidden = true
                self.button_save.isEnabled = true
            }
        }
    }
    
    @IBAction func button_image(_ sender: UIButton) {
        self.image_picker.present(from: sender)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return species.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return species[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected_specie = species[row]
    }
    
    @IBAction func date_picker(_ sender: UIDatePicker) {
        let date_formatter = DateFormatter()
        date_formatter.dateStyle = DateFormatter.Style.short
        date_formatter.dateFormat = "yyyy-MM-dd"
        let today_date = Date()
        let today = date_formatter.string(from: today_date)
        let date_selected = date_formatter.string(from: sender.date)
        if today > date_selected{
            date_str = date_formatter.string(from: sender.date)
            date_error.isHidden = true
        }else{
            date_error.isHidden = false
        }
    }
}
var image_global: UIImage?
extension PetRegister: ImagePickerDelegate{
    public func didSelect(image: UIImage?) {
        if image != nil{
            image_global = image
            self.pet_image.image = image
            pet_image.image = pet_image.image!.af_imageRoundedIntoCircle()
            
        }
    }
}
