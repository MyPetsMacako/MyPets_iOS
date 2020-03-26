import Foundation

class Appointment {
    
    var id: Int
    var title: String
    var date: String
    var name_pet: String
    
    init(json: [String: Any]) {
        
        id = json["id"] as? Int ?? 0
        title = json["title"] as? String ?? ""
        date = json["date"] as? String ?? ""
        name_pet = json["name"] as? String ?? ""
        
    }
}

