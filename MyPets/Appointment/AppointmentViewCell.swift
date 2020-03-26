import UIKit

class AppointmentViewCell: UITableViewCell {
    
    @IBOutlet weak var appointment_title: UILabel!
    @IBOutlet weak var appointment_date: UILabel!
    @IBOutlet weak var appointment_pet: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
