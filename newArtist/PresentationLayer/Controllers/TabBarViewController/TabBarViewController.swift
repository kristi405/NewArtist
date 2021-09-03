import UIKit

class TabBarViewController: UITabBarController {

    let searchVC = UINavigationController(rootViewController: SearchViewController(nib: R.nib.searchViewController))
    let favoriteVC = UINavigationController(rootViewController: FavoriteArtist(nib: R.nib.favoriteArtist))
    let mapVC = MapViewController(nib: R.nib.mapViewController)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTitle()
        setIcon()
        tabBar.backgroundColor = R.color.color()
        self.setViewControllers([searchVC, favoriteVC, mapVC], animated: true)
        self.modalPresentationStyle = .fullScreen
    }
    
    private func setTitle() {
        searchVC.tabBarItem.title = "Search"
        favoriteVC.tabBarItem.title = "Favorits"
        mapVC.tabBarItem.title = "Map"
    }
    
    private func setIcon() {
        searchVC.tabBarItem.image = R.image.search()
        favoriteVC.tabBarItem.image = R.image.heart()
        mapVC.tabBarItem.image = R.image.pinMap1()
    }
}
