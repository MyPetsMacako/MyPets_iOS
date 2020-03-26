//
//  PetsList.swift
//  MyPets
//
//  Created by alumnos on 05/02/2020.
//  Copyright © 2020 alumnos. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

var name: String?
var breed: String?
var weight: String?
var color: String?
var birth_date: String?
var image: String?
var document: String?
var qr: String?
var id: Int?

var cellsNum = 0
var reloadedTimes = 0

var namesArray: Array<String> = []
var idsArray: Array<Int> = []

class PetsList: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table_view: UITableView!
    var jsonArray: [String:Any] = [:]
    //var namesArray: Array<String> = []
    var breedsArray: Array<String> = []
    var colorsArray: Array<String> = []
    var weightsArray: Array<String> = []
    var birthsArray: Array<String> = []
    var imagesArray: Array<String> = []
    var documentsArray: Array<String> = []
    var qrsArray: Array<String> = []
    var detailsTableViewController : UIViewController?
    
    @IBOutlet weak var alert: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //get_pets_data()
    }
    override func viewWillAppear(_ animated: Bool) {
        let bgSetter: BGSet = BGSet()
        bgSetter.setBackground(view: self.view)
        table_view.backgroundColor = UIColor(white: 1, alpha: 0)
        guard let tabBar = self.tabBarController?.tabBar else { return }
        table_view.dataSource = self
        table_view.delegate = self
        tabBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tabBar.unselectedItemTintColor = UIColor(red: 85/255, green: 100/255, blue: 53/255, alpha: 1)
        get_pets_data()
        
        guard let tabBarItem = self.tabBarItem else { return }
        print(imagesArray)
        //self.table_view.reloadData()
    }
    
    func get_pets_data(){
        let url = URL(string: url_base + "/showPets")!
        
        let token = UserDefaults.standard.string(forKey: "token")
        
        let header = ["Authorization": token]
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: (header as! HTTPHeaders)).responseJSON { (response) in
            if response.response?.statusCode == 200{
                if let JSON = response.result.value{
                    self.jsonArray = JSON as! [String:Any]
                    idsArray = self.jsonArray["ids"] as! [Int]
                    self.imagesArray = self.jsonArray["images"] as! [String]
                    namesArray = self.jsonArray["names"] as! [String]
                    self.breedsArray = self.jsonArray["breeds"] as! [String]
                    self.weightsArray = self.jsonArray["weights"] as! [String]
                    self.colorsArray = self.jsonArray["colors"] as! [String]
                    self.birthsArray = self.jsonArray["birth_dates"] as! [String]
                    self.documentsArray = self.jsonArray["documents"] as! [String]
                    self.qrsArray = self.jsonArray["qrs"] as! [String]
                    if namesArray.count != 0{
                        self.alert.isHidden = true
                    }else{
                        self.alert.isHidden = false
                    }
                    //self.table_view.reloadData()
                    print("images:")
                    print("images:",self.imagesArray)
                    self.table_view.reloadData()
                }
            }else if response.response?.statusCode == 401{
                let alert = UIAlertController(title: "Error", message: "No ha sido posible cargar los datos de las mascotas", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
                self.present(alert,animated: true, completion: nil)
            }else{
                print("Petición incorrecta")
                print(response.response?.statusCode)
            }
        }
        print("fin petición")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PetCell
        cell.backgroundColor = UIColor(white: 1, alpha: 0)
        
        if qrsArray.count > 0{
            cell.pet_image.image?.af_imageRoundedIntoCircle()
            cell.pet_name.text = namesArray[indexPath.row]
            let url_qr = URL(string: self.qrsArray[indexPath.row])!
            cell.pet_qr.af_setImage(withURL: url_qr)
            
            if self.imagesArray[indexPath.row] == "http://www.mypetsapp.es/storage/"{
                cell.pet_image.image = #imageLiteral(resourceName: "avatar")
            }else{
                DataRequest.addAcceptableImageContentTypes(["image/jpg","image/png","binary/octet-stream"])
                let url = URL(string: self.imagesArray[indexPath.row])!
                cell.pet_image.af_setImage(withURL: url)
                print(namesArray[indexPath.row])
                print(imagesArray[indexPath.row])
                cellsNum = imagesArray.count
            }
        }
        if cellsNum == imagesArray.count{
            print ("fin código")
            reloadView()
        }
        cell.pet_image.image = cell.pet_image.image?.af_imageRoundedIntoCircle()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            image = self.imagesArray[indexPath.row]
            name = namesArray[indexPath.row]
            breed = self.breedsArray[indexPath.row]
            weight = self.weightsArray[indexPath.row]
            color = self.colorsArray[indexPath.row]
            birth_date = self.birthsArray[indexPath.row]
            document = self.documentsArray[indexPath.row]
            qr = self.qrsArray[indexPath.row]
            id = idsArray[indexPath.row]
    }
    
    func reloadView(){
        if reloadedTimes == 0{
            reloadedTimes+=1
            self.viewWillAppear(true)
        }
        
    }
    
}
