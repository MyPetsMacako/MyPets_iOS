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
    @IBOutlet weak var pet_breed: UITextField!
    @IBOutlet weak var pet_color: UITextField!
    @IBOutlet weak var pet_weight: UITextField!
    @IBOutlet weak var pet_specie: UITextField!
    @IBOutlet weak var pet_date: UITextField!
    

    @IBOutlet weak var button_save: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var date_error: UILabel!
    
    
    private var date_picker: UIDatePicker?
    private var species_picker: UIPickerView?
    
    let species_data = ["Perro", "Gato", "Reptil", "Roedor", "Ave"]
    var date_str: String?
    
    var name: String?
    var species: String?
    var breed: String?
    var color: String?
    var weight: String?
    var image: UIImage?
    var date: String?
    var image_picker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pet_image.image = pet_image_globale
        button_save.layer.cornerRadius = 5
        species_picker = UIPickerView()
        species_picker?.delegate = self
        species_picker?.dataSource = self
        pet_specie.text = pet_specie_global
        pet_breed.text = pet_breed_global
        species_picker?.backgroundColor = UIColor.white
        
        date_picker = UIDatePicker()
        date_picker?.datePickerMode = .date
        date_picker?.backgroundColor = UIColor.white
        
        date_picker?.addTarget(self, action: #selector(PetRegister.dateChanged(date_picker:)), for: .valueChanged)
        date_picker?.locale = NSLocale.init(localeIdentifier: "es_ES") as Locale
        
        
        let tap_gesture = UITapGestureRecognizer(target: self, action: #selector(PetRegister.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tap_gesture)
        
        pet_date.inputView = date_picker
        pet_specie.inputView = species_picker
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pet_image.image = pet_image.image?.af_imageRoundedIntoCircle()
        self.image_picker = ImagePicker(presentationController: self, delegate: self)
        loader.isHidden = true
        let bgSetter: BGSet = BGSet()
        bgSetter.setBackground(view: self.view)
    }
    
    @objc func viewTapped (gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged (date_picker: UIDatePicker) {
        let date_formatter = DateFormatter()
        date_formatter.dateFormat = "yyyy-MM-dd"
        pet_date.text = date_formatter.string(from: date_picker.date)
    }
    
    
    func checkData() -> Bool {
        if !pet_name.text!.isEmpty && !pet_specie.text!.isEmpty && !pet_breed.text!.isEmpty && !pet_color.text!.isEmpty && !pet_weight.text!.isEmpty &&  !pet_date.text!.isEmpty && pet_image.image != nil{
            name = pet_name.text
            species = pet_specie.text
            breed = pet_breed.text
            color = pet_color.text
            weight = pet_weight.text
            date = pet_date.text
            image = pet_image_globale
            return true
        }else{
            let alert = UIAlertController(title: "Error", message: "Rellene todos los datos para registrar la mascota", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
            self.present(alert,animated: true, completion: nil)
            return false
        }
    }
    @IBAction func save_button(_ sender: UIButton) {
        if check_date() {
            if checkData() {
                postPet()
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "La fecha es incorrecta", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in self.dismiss(animated: true, completion: nil )}))
            self.present(alert,animated: true, completion: nil)
        }
    }
    
    func postPet(){
        let url = URL(string: url_base + "/petsRegister")
        let token = UserDefaults.standard.string(forKey: "token")
        let header = ["Authorization": token]
        
        let json = ["name": name!, "species": species, "breed": breed!, "color": color!, "weight": weight!, "birth_date": date]
        loader.isHidden = false
        button_save.isEnabled = false
        print(json)
        let pdf_data = pet_documents_global.dataRepresentation()
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in json {
                multipartFormData.append((value?.data(using: .utf8)!)!, withName: key)
            }
            if pet_image_globale != nil{
                let image_data = pet_image_globale.jpegData(compressionQuality: 0)
                print("no null")
                multipartFormData.append(image_data!, withName: "image", fileName: "image.png", mimeType: "image/jpeg")
            }
            if pdf_data != nil{
                multipartFormData.append(pdf_data!, withName: "document", fileName: "document.pdf", mimeType: "application/pdf")
            }
        }, to:url!, method: .post, headers: (header as! HTTPHeaders)) { (result) in
            print(result)
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response.response?.statusCode)
                    print(response)
                    pet_image_globale = UIImage(named: "avatar")
                    self.loader.isHidden = true
                    self.button_save.isEnabled = true
                    self.navigationController?.popToRootViewController(animated: true)
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
        return species_data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return species_data[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pet_specie.text = species_data[row]
    }

    func check_date () -> Bool{
        let date_formatter = DateFormatter()
        date_formatter.dateStyle = DateFormatter.Style.short
        date_formatter.dateFormat = "dd-MM-yyyy"
        let today_date = Date()
        let today = date_formatter.string(from: today_date)
        
        if today != pet_date.text{
            date_error.isHidden = true
            return true
        }else{
            date_error.isHidden = false
            return false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
