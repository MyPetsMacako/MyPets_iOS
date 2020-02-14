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
    
    @IBOutlet weak var pet_name: UILabel!
    @IBOutlet weak var pet_breed: UILabel!
    @IBOutlet weak var pet_weight: UILabel!
    @IBOutlet weak var pet_color: UILabel!
    @IBOutlet weak var pet_birth_date: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bgSetter: BGSet = BGSet()
        bgSetter.setBackground(view: self.view)
        pet_name.text = name
        pet_breed.text = breed
        pet_weight.text = weight
        pet_color.text = color
        pet_birth_date.text = birth_date
    }
}
