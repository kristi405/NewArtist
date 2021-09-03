import UIKit

class FavoriteCell: UICollectionViewCell {
    // MARK: IBOutlets
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!

    // MARK: Configure Cell
    
    func configureCell(artist: FavoriteArtists) {
        label.text = artist.name

        guard let dataUrl = URL(string: artist.image ?? SearchVCString.name.localizedString) else {return}
        guard let imageData = try? Data(contentsOf: dataUrl) else {return}
        image.image = UIImage(data: imageData)
    }
}
