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

class PetRegister: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pet_image: UIImageView!
    @IBOutlet weak var pet_name: UITextField!
    @IBOutlet weak var species_picker: UIPickerView!
    @IBOutlet weak var pet_breed: UITextField!
    @IBOutlet weak var pet_color: UITextField!
    @IBOutlet weak var pet_weight: UITextField!
    @IBOutlet weak var birthday_picker: UIDatePicker!
    
    let species = ["Perro", "Gato", "Reptil", "Roedor", "Ave"]
    var selected_specie = "Gato"
    var date_str: String?
    
    var name: String?
    var breed: String?
    var color: String?
    var weight: String?
    
    override func viewWillAppear(_ animated: Bool) {
        species_picker.dataSource = self
        species_picker.delegate = self
    }
    
    func setData() -> Bool {
        if !pet_name.text!.isEmpty && !pet_breed.text!.isEmpty && !pet_color.text!.isEmpty && !pet_weight.text!.isEmpty{
            name = pet_name.text
            breed = pet_breed.text
            color = pet_color.text
            weight =  pet_weight.text!
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
            if setData(){
                postPet()
            }else{
                let alert = UIAlertController(title: "Error", message: "Los datos no son correctos", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
                self.present(alert,animated: true, completion: nil)
            }
        }else{
            let alert = UIAlertController(title: "Error", message: "La fecha es incorrecta", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
            self.present(alert,animated: true, completion: nil)
        }
    }
    
    func postPet(){
        let url = URL(string: "http://localhost:8888/laravel-ivanodp/MyPets_API/public/index.php/api/petsRegister")
        let token = UserDefaults.standard.string(forKey: "token")
        let header = ["Authorization": token]
        
        let json = ["name": name!, "species": selected_specie, "breed": breed!, "colour": color!, "weight": weight!, "birth_date": date_str!] as [String : Any]
        print(header)
        print(json)
        Alamofire.request(url!, method: .post, parameters: json, encoding: JSONEncoding.default, headers: (header as! HTTPHeaders)).responseJSON { (response) in
           
            if response.response?.statusCode == 200{
                print("mascota registrada")
                _ = self.navigationController?.popViewController(animated: true)
            }else if response.response?.statusCode == 401{
                let alert = UIAlertController(title: "Error", message: "No ha sido posible registrar la mascota", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
                self.present(alert,animated: true, completion: nil)
            }else{
                print("Peticion incorrecta")
            }
        }
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
        print(sender.date)
        date_formatter.dateStyle = DateFormatter.Style.short
        date_formatter.dateFormat = "yyyy-MM-dd"
        date_str = date_formatter.string(from: sender.date)
        print(date_str!)
    }
}
