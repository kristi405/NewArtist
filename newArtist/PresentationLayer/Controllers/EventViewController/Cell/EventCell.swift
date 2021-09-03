import UIKit

class EventCell: UITableViewCell {
    // MARK: IBOutlets
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var mapButton: UIButton!
    
    // MARK: Configure Cell

    func configureCell(event: Event) {
        dataLabel.text = event.datetime
        cityLabel.text = event.venue?.city
        countryLabel.text = event.venue?.country
    }
}
