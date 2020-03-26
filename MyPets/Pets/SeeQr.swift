//
//  SeeQr.swift
//  MyPets
//
//  Created by Javier Buenache on 06/03/2020.
//  Copyright © 2020 alumnos. All rights reserved.
//

import UIKit

class SeeQr: UIViewController {
    @IBOutlet weak var qr_image: UIImageView!
    override func viewWillAppear(_ animated: Bool) {
        let url_qr = URL(string: qr!)
        qr_image.af_setImage(withURL: url_qr!)
    }
}
