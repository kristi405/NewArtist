import UIKit

class EventVC: UITableViewController {
    // MARK:  Public Properties
    
    var events = [Event]()
    
    // MARK: Private Properties
    
    private var currentEvent: Event?
    private var indexPath: Int?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Events"
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "eventCell")
        tableView.backgroundColor = R.color.backgroundColor()
    }
    
    // MARK: IBActions
    
    @IBAction func showMap(_ sender: UIButton) {
        let mapVC = MapEvents(nibName: "MapEventViewController", bundle: nil)
        mapVC.event = self.events[sender.tag]
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @IBAction func showWeb(_ sender: UIButton) {
        let webVC = WebViewController(nibName: "WebViewController", bundle: nil)
        guard let event = events.first else {return}
        webVC.eventURL = event.url
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    // MARK:  Private Methods
    
    private func castomCell(cell: EventCell) {
        cell.layer.borderWidth = Constants.borderWidthOfCell
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowRadius = Constants.shadowRadius
    }

    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventCell
        var eventsCell = EventCell()
        
        if let eventCell = cell {
            let event = events[indexPath.row]
            eventCell.configureCell(event: event)
            castomCell(cell: eventCell)
            eventCell.backgroundColor = R.color.color()
            eventsCell = eventCell
            eventsCell.mapButton.addTarget(self, action: #selector(showMap), for: .touchUpInside)
            eventsCell.mapButton.tag = indexPath.row
        }
        return eventsCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.heightForRow
    }
}

extension EventVC {
    // MARK: Constants
    
    private enum Constants {
        static let borderWidthOfCell: CGFloat = 0.153
        static let shadowRadius: CGFloat = 10
        static let heightForRow: CGFloat = 100
    }
}
