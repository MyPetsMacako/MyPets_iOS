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

class PetsList: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table_view: UITableView!
    var jsonArray: NSArray?
    var nameArray: Array<String> = []
    var pets: [[String: Any]]?
    
    var detailsTableViewController : UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        get_pets_data()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        table_view.dataSource = self
        table_view.delegate = self
        
        guard let tabBar = self.tabBarController?.tabBar else { return }
        
        tabBar.tintColor = UIColor(red: 94/255, green: 125/255, blue: 143/255, alpha: 1)
        tabBar.unselectedItemTintColor = UIColor(red: 85/255, green: 100/255, blue: 53/255, alpha: 1)
        
        
        guard let tabBarItem = self.tabBarItem else { return }
    }
    
    func get_pets_data(){
        let url = URL(string: "http://localhost:8888/laravel-ivanodp/MyPets_API/public/index.php/api/showPets")
        
        let token = UserDefaults.standard.string(forKey: "token")
        
        let header = ["Authorization": token]
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: (header as! HTTPHeaders)).responseJSON { (response) in
            if let JSON = response.result.value{
                self.jsonArray = JSON as? NSArray
                for item in self.jsonArray! as! [NSDictionary]{
                    let name = item["name"] as? String
                    self.nameArray.append((name)!)
                }
                self.table_view.reloadData()
                
            }
            if response.response?.statusCode == 200{
                let json = response.result.value as! [[String:Any]]
                self.pets = json
                print(json)
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
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PetCell
        
        cell.pet_name.text = self.nameArray[indexPath.row]
        
        return cell
    }
    
    
}
