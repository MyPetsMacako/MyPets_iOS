//
//  BGSetter.swift
//  MyPets
//
//  Created by alumnos on 10/02/2020.
//  Copyright © 2020 alumnos. All rights reserved.
//


import Foundation
import UIKit

class BGSet{
    
    //Esta clase sirve para colocar el mismo fondo en todas las pantallas llamando a la función de "setBackground()", he usado esta clase para no repetir el mismo código en las tres pantallas
    public func setBackground(view: UIView)  {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "MYPETS_background")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
    }
}
