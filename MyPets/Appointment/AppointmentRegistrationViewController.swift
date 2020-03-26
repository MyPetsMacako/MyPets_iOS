import UIKit
import Alamofire

class AppointmentRegistrationViewController: UIViewController {
    
    @IBOutlet weak var appointment_title_text: UITextField!
    @IBOutlet weak var appointment_date_text: UITextField!
    @IBOutlet weak var appointment_pet_text: UITextField!
    
    private var date_picker: UIDatePicker?
    private var pet_picker: UIPickerView?
    var id_pet = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bgSetter: BGSet = BGSet()
        bgSetter.setBackground(view: self.view)
        
        if idsArray != nil{
            var id_pet = idsArray[0]
        }
        date_picker = UIDatePicker()
        date_picker?.datePickerMode = .dateAndTime
        date_picker?.backgroundColor = UIColor.white
        date_picker?.addTarget(self, action: #selector(AppointmentRegistrationViewController.dateChanged(date_picker:)), for: .valueChanged)
        date_picker?.locale = NSLocale.init(localeIdentifier: "es_ES") as Locale
        
        pet_picker = UIPickerView()
        pet_picker?.delegate = self
        pet_picker?.dataSource = self
        pet_picker?.backgroundColor = UIColor.white
        
        let tap_gesture = UITapGestureRecognizer(target: self, action: #selector(AppointmentRegistrationViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tap_gesture)
        
        appointment_date_text.inputView = date_picker
        appointment_pet_text.inputView = pet_picker
        
        if !namesArray.isEmpty {
            appointment_pet_text.text = namesArray[0]
            id_pet = idsArray[0]
        }

    }
    
    @objc func viewTapped (gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged (date_picker: UIDatePicker) {
        let date_formatter = DateFormatter()
        date_formatter.dateFormat = "yyyy-MM-dd HH:mm"
        appointment_date_text.text = date_formatter.string(from: date_picker.date)
    }

    @IBAction func registerAppointmentButton(_ sender: Any) {
        if appointment_title_text.text!.isEmpty || appointment_date_text.text!.isEmpty || appointment_pet_text.text!.isEmpty   {
            let alert = UIAlertController(title: "Aviso", message: "Debe rellenar todos los campos", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (accion) in}))
            self.present(alert,animated: true, completion: nil)
        } else {
            createAppointment(title: appointment_title_text.text!, date: appointment_date_text.text!, pet_id: appointment_pet_text.text!)
        }
    }
   
    
    func createAppointment(title: String, date: String, pet_id: String){

        let url = URL(string: url_base + "/createAppointment")!
        let token = UserDefaults.standard.string(forKey: "token")
        let header = ["Authorization": token]
        let json = ["title": title, "date": date, "pet_id": id_pet] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: json, encoding: JSONEncoding.default, headers: (header as! HTTPHeaders)).responseJSON {
            (response) in
            switch(response.response?.statusCode){
            case 200:
                print("CREATE_APOINTMENT_200")
                let alert = UIAlertController(title: "Aviso", message: "Cita creada", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { action in self.navigationController?.popToRootViewController(animated: true)}))
                self.present(alert,animated: true, completion: nil)
                
            case 401:
                print("CREATE_APOINTMENT_401")
                let alert = UIAlertController(title: "Error", message: "No ha sido posible registrar la cita", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (accion) in}))
                self.present(alert,animated: true, completion: nil)
            default:
                print("CREATE_APOINTMENT_DEFAULT")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

extension AppointmentRegistrationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         return namesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        appointment_pet_text.text = namesArray[row]
        id_pet = idsArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return namesArray[row]
    }
    
}
