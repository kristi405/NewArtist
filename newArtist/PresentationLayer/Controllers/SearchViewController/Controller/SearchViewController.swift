import UIKit
import RealmSwift
import Rswift
import Moya

class SearchViewController: UIViewController {
    // MARK: IBOutlet

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var webButton: UIButton!
    
    // MARK: Private properties
    
    private var artists = try? Realm().objects(FavoriteArtists.self).sorted(byKeyPath: SearchVCString.name.rawValue, ascending: true)
    private var currentArtistFavorite: CurrentArtist?
    private var onComplition: ((CurrentArtist) -> Void)?
    private var favoriteVC = FavoriteArtist(nib: R.nib.favoriteArtist)
    private var text: String?
    private lazy var timer = AutosearchTimer {
        self.performSearch()
    }
    private var searchController = UISearchController()
    private let artistService = ArtistService()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = R.color.color()
        navigationController?.navigationBar.barTintColor = R.color.color()
        tabBarController?.tabBar.barTintColor = R.color.backgroundColor()
        tabBarController?.tabBar.tintColor = .black
        self.image.contentMode = .scaleAspectFit
        customBatton()
        setupSearchController()
        searchArtist()
    }

    // MARK: IBActions

    @IBAction func ButtonPushed(_ sender: UIButton) {
        if !isContains() {
            favoriteVC.saveArtist()
            sender.setImage(image: R.image.redHeart(), leadingAnchor: Constants.leadingAnchorOfImage, heightAnchor: Constants.heightAnchorOfImage)
            sender.setTitle(SearchVCString.removeFromFavorites.rawValue.stringValue, for: .normal)
        } else {
            favoriteVC.deleteArtistFromButton()
            sender.setImage(image: R.image.whHeart(), leadingAnchor: Constants.leadingAnchorOfImage, heightAnchor: Constants.heightAnchorOfImage)
            sender.setTitle(SearchVCString.addToFavorites.rawValue.stringValue, for: .normal)
        }
    }
    
    @IBAction func showWeb(_ sender: UIButton) {
        let webVC = WebViewController(nib: R.nib.webViewController)
        guard let currentArtist = currentArtistFavorite else {return}
        guard let url = currentArtist.url else {return}
        webVC.eventURL = url
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    // MARK: BusinessLogic

    // Send a request to find an artist
    private func searchArtist() {
        self.onComplition = { currentArtist in
            self.favoriteVC.currentArtist = currentArtist
            self.configureView(artist: currentArtist)
        }
    }
    
    // Displaying artist data on the screen
    private func configureView(artist: CurrentArtist) {
        DispatchQueue.main.async {
            self.label.text = artist.name
        }
        //Get data from url
        DispatchQueue.global().async {
            guard let dataUrl = URL(string: artist.imageURL ?? SearchVCString.enterTheName.rawValue) else {return}
            guard let imageData = try? Data(contentsOf: dataUrl) else {return}
            
            DispatchQueue.main.async {
                self.image.image = UIImage(data: imageData)
            }
        }
    }
    
    // Check if the artist has been added to favorites
    private func isContains() -> Bool {
        guard let artists = artists else {return true}
        for artist in artists {
            if currentArtistFavorite?.name == artist.name {
                return true
            }
        }
        return false
    }
    
    // Customizing the button
    private func customBatton() {
        favoriteButton.searchVCBattons(button: favoriteButton)
        webButton.searchVCBattons(button: webButton)
    }
    
    // MARK: Setup UISearchController
    
    // Install SearchController
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = SearchVCString.enterTheName.rawValue.stringValue
        searchController.searchBar.searchTextField.backgroundColor = .white
        self.searchController = searchController
        
        searchController.searchBar.delegate = self
    }
    
    // Hidden or not hidden labels
    private func labelIsHidden() {
        label.isHidden = true
        image.isHidden = true
        favoriteButton.isHidden = true
        webButton.isHidden = true
    }
    
    private func labelIsNotHidden() {
        label.isHidden = false
        image.isHidden = false
        favoriteButton.isHidden = false
        webButton.isHidden = false
    }
    
    // we check is the artist conteins in Realm
    private func checkArtistsConteins() {
        if !isContains() {
            favoriteButton.setTitle(SearchVCString.addToFavorites.rawValue.stringValue, for: .normal)
            favoriteButton.setImage(image: R.image.whHeart(), leadingAnchor: Constants.leadingAnchorOfImage, heightAnchor: Constants.heightAnchorOfImage)
        } else {
            favoriteButton.setTitle(SearchVCString.removeFromFavorites.rawValue.stringValue, for: .normal)
            favoriteButton.setImage(image: R.image.redHeart(), leadingAnchor: Constants.leadingAnchorOfImage, heightAnchor: Constants.heightAnchorOfImage)
        }
    }
}


// MARK: - Extension UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Checking the number of entered characters in the search string
        timer.activate()
        text = searchText
    }
    
    // logic of request artist and view of search screan
    private func performSearch() {
        timer.cancel()
        guard let text = self.text else {return}
        if text.count == .zero {
            labelIsHidden()
            searchController.searchBar.placeholder = SearchVCString.enterTheName.rawValue.stringValue
        } else if text.count <= Constants.searchTextCount {
            searchController.searchBar.searchTextField.text = SearchVCString.enterTheName.rawValue.stringValue
            labelIsHidden()
        } else {
            let name = GetArtistName(name: text)
            artistService.getArtist(artist: name) { currentArtist in
                self.onComplition?(currentArtist)
                self.currentArtistFavorite = currentArtist
                DispatchQueue.main.async {
                    self.labelIsNotHidden()
                    self.checkArtistsConteins()
                }
            } completionError: { alert in
                self.labelIsHidden()
                self.present(alert, animated: true, completion: nil)
                self.searchController.searchBar.text = ""
            }
        }
    }
}

// MARK: - Constants
extension SearchViewController {
    private enum Constants {
        static let searchTextCount = 2
        static let leadingAnchorOfImage: CGFloat = -4
        static let heightAnchorOfImage: CGFloat = 28
    }
}

