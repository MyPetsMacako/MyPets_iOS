//
//  PetPhotoRegister.swift
//  MyPets
//
//  Created by alumnos on 03/03/2020.
//  Copyright © 2020 alumnos. All rights reserved.
//

import UIKit
import AlamofireImage
import Vision

var pet_image_globale: UIImage!
var pet_specie_global: String?
var pet_breed_global: String?

class PetPhotoRegister: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var error: UILabel!
    @IBOutlet weak var retrate: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var pet_image: UIImageView!
    @IBOutlet weak var button_image: UIButton!
    @IBOutlet weak var specie: UITextField!
    @IBOutlet weak var breed: UITextField!
    
    private var species_picker: UIPickerView?
    var model: VNCoreMLModel?
    var model_breed: VNCoreMLModel?
    
    let species_data = ["Perro", "Gato", "Reptil", "Roedor", "Ave"]
    
    override func viewDidLoad() {
        continueButton.layer.cornerRadius = 5
    }
    
    var image_picker: ImagePicker!
    override func viewWillAppear(_ animated: Bool) {
        let bgSetter: BGSet = BGSet()
        bgSetter.setBackground(view: self.view)
        species_picker = UIPickerView()
        species_picker?.delegate = self
        species_picker?.dataSource = self
        species_picker?.backgroundColor = UIColor.white
        
        pet_image.image = pet_image.image!.af_imageRoundedIntoCircle()
        self.image_picker = ImagePicker(presentationController: self, delegate: self)
        let tap_gesture = UITapGestureRecognizer(target: self, action: #selector(PetRegister.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tap_gesture)
        specie.inputView = species_picker
        model = loadModel()
        model_breed = loadModel_breed()
    }
    
    func loadModel() -> VNCoreMLModel? {
        var model: VNCoreMLModel?
        do {
            model = try VNCoreMLModel(for: EspeciesClassifier().model)
        } catch {
            print("Error al cargar el modelo")
        }
        
        return model
    }
    
    func loadModel_breed() -> VNCoreMLModel? {
        var model_breed: VNCoreMLModel?
        do {
            model_breed = try VNCoreMLModel(for: RazasClassifier().model)
        } catch {
            print("Error al cargar el modelo")
        }
        
        return model_breed
    }
    
    func classify(image: CGImage) {
        let request = VNCoreMLRequest(model: model!) { (request, error) in
            let results = request.results as? [VNClassificationObservation]
            let bestResult = results?.first
          
            DispatchQueue.main.async
                {
                self.button_image.isHidden = false
                let operacion : Float = 0.60
                if bestResult!.confidence > operacion
                {
                    self.specie.text = bestResult?.identifier
                    self.message.isHidden = false
                    switch (self.specie.text)
                        
                    {
                    case "Perro":
                        self.retrate.image = UIImage(named: "retrato_perros_cp")
                        
                    case "Gato":
                        self.retrate.image = UIImage(named: "retrato_gatos_cp")
                        
                    case "Ave":
                        self.retrate.image = UIImage(named: "retrato_aves_cp")
                        
                    case "Roedor":
                        self.retrate.image = UIImage(named: "retrato_roedores_cp")
                        
                    case "Reptil":
                        self.retrate.image = UIImage(named: "retrato_reptiles_cp")
                        
                    default:
                        print("chucky")
                    }
                    pet_specie_global = bestResult?.identifier
                    
                       self.button_image.isHidden = true
                } else
                {
                    self.error.isHidden = false
                    self.pet_image.image = UIImage(named: "chucky")
                    pet_image_globale = UIImage(named: "chucky")
                       self.button_image.isHidden = true
                }
            }
            print(bestResult?.identifier)
            print(bestResult?.confidence as Any)
        }
        request.imageCropAndScaleOption = .centerCrop
        
        let handler = VNImageRequestHandler(cgImage: image)
        DispatchQueue.global().async {
            do {
                try handler.perform([request])
            } catch {
                print("Error al clasificar la imagen")
            }
        }
    }
    
    func classify_breed(image: CGImage) {
        let request = VNCoreMLRequest(model: model_breed!) { (request, error) in
            let results = request.results as? [VNClassificationObservation]
            let bestResult = results?.first
            
            DispatchQueue.main.async {
                
                self.button_image.isHidden = false
                let operacion : Float = 0.60
                if bestResult!.confidence > operacion
                {
                self.message.isHidden = false
                self.breed.text = bestResult?.identifier
                 pet_breed_global = bestResult?.identifier
                    
                    self.button_image.isHidden = true
                } else
                {
                self.button_image.isHidden = true
                }
            
            }
            
            print(bestResult?.confidence as Any)
        }
        request.imageCropAndScaleOption = .centerCrop
        
        let handler = VNImageRequestHandler(cgImage: image)
        DispatchQueue.global().async {
            do {
                try handler.perform([request])
            } catch {
                print("Error al clasificar la imagen")
            }
        }
    }
    
    @objc func viewTapped (gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    @IBAction func button_touch(_ sender: UIButton) {
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
        specie.text = species_data[row]
    }
}

extension PetPhotoRegister: ImagePickerDelegate{
    public func didSelect(image: UIImage?) {
        if image != nil{
            classify(image: (image?.cgImage)!)
            classify_breed(image: (image?.cgImage)!)
            self.pet_image.image = image
            pet_image_globale = image
            pet_image.image = pet_image.image!.af_imageRoundedIntoCircle()
        }
    }
}
