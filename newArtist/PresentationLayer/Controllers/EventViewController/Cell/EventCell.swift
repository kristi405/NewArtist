import UIKit

class EventCell: UITableViewCell {
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var mapButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(event: Event) {
        dataLabel.text = event.datetime
        cityLabel.text = event.venue?.city
        countryLabel.text = event.venue?.country
    }
}
