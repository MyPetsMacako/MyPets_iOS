import UIKit
import JTAppleCalendar
import Alamofire

var appointments: [Appointment] = []
var date_appointments: [Appointment] = []
var day_selected: Bool = false

//var is_cell_selected = false

class AppointmentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var calendarView: JTAppleCalendarView!
    @IBOutlet weak var table_view: UITableView!
    @IBOutlet weak var show_appointments_button_outlet: UIButton!
    
    
    var filteredAppointments: [Appointment] = []
    let searchController = UISearchController(searchResultsController: nil)
    var calendarDataSource: [String:String] = [:]
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        show_appointments_button_outlet.layer.cornerRadius = 5
        let bgSetter: BGSet = BGSet()
        bgSetter.setBackground(view: self.view)
        table_view.backgroundColor = UIColor(white: 1, alpha: 0)
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
//        view.addGestureRecognizer(tap)
    }
    
//    @objc func handleTap(sender: UITapGestureRecognizer){
//        guard sender.view != nil else { return }
//        if sender.state == .ended {
//            if is_cell_selected == true {
//               calendarView.deselectAllDates()
//            }
//        }    // Move the view down and to the right when tapped.
//    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        calendarView.scrollDirection = .horizontal
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.showsHorizontalScrollIndicator = false
        
        calendarView.deselectAllDates()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Nombre de tu mascota"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        show_appointments_by_date_order()
        
        show_appointments_button_outlet.isHidden = true
        table_view.isHidden = false
    }
 
    @IBAction func new_appointment_button(_ sender: Any) {
        if namesArray.isEmpty {
            let alert = UIAlertController(title: "Aviso", message: "Debes tener mascotas registradas", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { action in self.performSegue(withIdentifier: "CalendarToPetRegistration", sender: nil)}))
            self.present(alert,animated: true, completion: nil)
        }
    }
    @IBAction func show_appointments_button(_ sender: Any) {
        table_view.isHidden = false
    }
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredAppointments = date_appointments.filter({ (date_appointment) -> Bool in
            return date_appointment.name_pet.lowercased().contains(searchText.lowercased())
        })
        table_view.reloadData()
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }

    func populateDataSource() {
        // You can get the data from a server.
        // Then convert that data into a form that can be used by the calendar.
        calendarDataSource.removeAll()
        for appointment in appointments {

            let date_string: String = appointment.date
            let date_formatter = DateFormatter()
            date_formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let formated_date: Date? = date_formatter.date(from: date_string)
            date_formatter.dateFormat = "yyyy-MM-dd"
            let selected_date_string = date_formatter.string(from: formated_date!)

            calendarDataSource[selected_date_string] = appointment.title

        }

        // update the calendar
        calendarView.reloadData()
    }

    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
        handleCellEvents(cell: cell, cellState: cellState)
        
    }
    
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.black
        } else {
            cell.dateLabel.textColor = UIColor.lightGray
        }
    }
    
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
            cell.selectedView.layer.cornerRadius =  5
            cell.selectedView.isHidden = false
            let selected_date = calendarView.selectedDates.first
            let date_formater = DateFormatter()
            date_formater.dateFormat = "yyyy-MM-dd"
            let selected_date_string = date_formater.string(from: selected_date!)
            date_finder(date: selected_date_string)
        } else {
            cell.selectedView.isHidden = true
        }
    }
    
    func handleCellEvents(cell: DateCell, cellState: CellState) {
        let dateString = formatter.string(from: cellState.date)
        if calendarDataSource[dateString] == nil {
            cell.dotView.isHidden = true
        } else {
            cell.dotView.isHidden = false
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if isFiltering {
            return filteredAppointments.count
        }
        
        return date_appointments.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCell", for: indexPath) as! AppointmentViewCell
        
        cell.backgroundColor = UIColor(white: 1, alpha: 0)
        
        let appointment: Appointment
        
        if isFiltering{
            appointment = filteredAppointments[indexPath.row]
        } else {
            appointment = date_appointments[indexPath.row]
        }

//        cell.appointment_title.text = date_appointments[indexPath.row].title
//        cell.appointment_date.text = date_appointments[indexPath.row].date
//        cell.appointment_pet.text = date_appointments[indexPath.row].name_pet
        
        cell.appointment_title.text = appointment.title
        cell.appointment_date.text = dateFormatter(appointment: appointment.date)
        cell.appointment_pet.text = appointment.name_pet
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delete_local_appointment(id: date_appointments[indexPath.row].id)
            delete_appointment(appointment_id: date_appointments[indexPath.row].id)
            date_appointments.remove(at: indexPath.row)
            table_view.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func delete_local_appointment(id: Int){
        for (i, appointment) in appointments.enumerated() {
            if id == appointment.id {
                appointments.remove(at: i)
                break
            }
        }
    }
    
    func show_appointments_by_date_order(){
        let url = URL(string: url_base + "/showAppointmentsByDateOrder")
        
        let token = UserDefaults.standard.string(forKey: "token")
        
        let header = ["Authorization": token]
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header as? HTTPHeaders).responseJSON { (response) in
            switch response.response?.statusCode {
            case 200:
                print("SHOW_APPOINTMENTS_BY_DATE_ORDER_200")
                appointments.removeAll()
                if let json = response.result.value as? [[String: Any]] {
                    for appointment in json {
                        appointments.append(Appointment(json: appointment))
                    }
                    self.populateDataSource()
                    date_appointments = appointments
                    self.table_view.reloadData()
                }
            case 401:
                print("SHOW_APPOINTMENTS_BY_DATE_ORDER_401")
            default:
                print("SHOW_APPOINTMENTS_BY_DATE_ORDER_DEFAULT")
            }
        }
    }
    
    func delete_appointment(appointment_id: Int){
        
        let appointment_id_string = String(appointment_id)
        
        let url = URL(string: url_base + "/deleteAppointment/" + appointment_id_string)
        
        let token = UserDefaults.standard.string(forKey: "token")
        
        let header = ["Authorization": token]
        Alamofire.request(url!, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: header as? HTTPHeaders).responseJSON { (response) in
            
            switch response.response?.statusCode {
            case 200:
                print("DELETE_APPOINTMENTS_200")
                self.populateDataSource()
            case 401:
                print("DELETE_APPOINTMENTS_401")
            default:
                print("DELETE_APPOINTMENTS_ORDER_DEFAULT")
            }
        }
    }
    
    func date_finder(date: String){
        
        date_appointments.removeAll()
        day_selected = false
        for appointment in appointments {
            
            let date_string: String = appointment.date
            let date_formatter = DateFormatter()
            date_formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let formated_date: Date? = date_formatter.date(from: date_string)
            date_formatter.dateFormat = "yyyy-MM-dd"
            let selected_date_string = date_formatter.string(from: formated_date!)

            if selected_date_string == date {
                date_appointments.append(appointment)
                day_selected = true
            }
        }
        
        if date_appointments.isEmpty {
            date_appointments = appointments
        }
        self.table_view.reloadData()
        if day_selected == false {
            show_appointments_button_outlet.isHidden = false
            table_view.isHidden = true
        } else {
            show_appointments_button_outlet.isHidden = true
            table_view.isHidden = false
        }
    }
    
    func dateFormatter(appointment: String) -> String{
        var date = appointment
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // convert your string to date
        let yourDate = formatter.date(from: date)
        formatter.locale =  NSLocale.init(localeIdentifier: "es_ES") as Locale
        formatter.dateFormat = "dd*MMMM % HH:mm"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        
        let dateFormat = myStringafd.replacingOccurrences(of: "%", with: "a las", options: .literal, range: nil)
        let dateFormatter = dateFormat.replacingOccurrences(of: "*", with: " de ", options: .literal, range: nil)
        
        return dateFormatter
    }
    
}

extension AppointmentsViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        //let startDate = formatter.date(from: "2020-01-01")!
        let startDate = Date()
        let endDate = formatter.date(from: "2025-01-01")!
        return ConfigurationParameters(startDate: startDate,
                                       endDate: endDate,
                                       numberOfRows: 6,
                                       generateInDates: .forAllMonths,
                                       generateOutDates: .tillEndOfGrid)
    }
}

extension AppointmentsViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let formatter = DateFormatter()  // Declare this outside, to avoid instancing this heavy class multiple times.
        formatter.locale =  NSLocale.init(localeIdentifier: "es_ES") as Locale
        formatter.dateFormat = "MMMM"
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
        let month_name = formatter.string(from: range.start)
        header.monthTitle.text = month_name.capitalized
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 75)
    }

}

extension AppointmentsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

