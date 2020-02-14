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
var image = ""
class PetsList: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table_view: UITableView!
    var jsonArray: [String:Any] = [:]
    var namesArray: Array<String> = []
    var breedsArray: Array<String> = []
    var colorsArray: Array<String> = []
    var weightsArray: Array<String> = []
    var birthsArray: Array<String> = []
    var imagesArray: Array<String> = []
    var detailsTableViewController : UIViewController?
    
    override func viewWillAppear(_ animated: Bool) {
        get_pets_data()
        guard let tabBar = self.tabBarController?.tabBar else { return }
        
        tabBar.tintColor = UIColor(red: 94/255, green: 125/255, blue: 143/255, alpha: 1)
        tabBar.unselectedItemTintColor = UIColor(red: 85/255, green: 100/255, blue: 53/255, alpha: 1)
        
        
        guard let tabBarItem = self.tabBarItem else { return }
    }
    
    func get_pets_data(){
        let url = URL(string:"http://localhost:8888/MyPets_API/public/index.php/api/showPets")!
        
        let token = UserDefaults.standard.string(forKey: "token")
        
        let header = ["Authorization": token]
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: (header as! HTTPHeaders)).responseJSON { (response) in
            if response.response?.statusCode == 200{
                if let JSON = response.result.value{
                    self.jsonArray = JSON as! [String:Any]
                    print(self.jsonArray)
                    self.namesArray = self.jsonArray["names"] as! [String]
                    self.breedsArray = self.jsonArray["breeds"] as! [String]
                    self.weightsArray = self.jsonArray["weights"] as! [String]
                    self.colorsArray = self.jsonArray["colours"] as! [String]
                    self.birthsArray = self.jsonArray["birth_dates"] as! [String]
                    //self.imagesArray = self.jsonArray["images"] as! [String]
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PetCell
        
        cell.pet_name.text = self.namesArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        name = self.namesArray[indexPath.row]
        breed = self.breedsArray[indexPath.row]
        weight = self.weightsArray[indexPath.row]
        color = self.colorsArray[indexPath.row]
        birth_date = self.birthsArray[indexPath.row]

    }
}
