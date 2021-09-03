import UIKit

class FavoriteCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(artist: FavoriteArtists) {
        
        label.text = artist.name

        guard let dataUrl = URL(string: artist.image ?? "name") else {return}
        guard let imageData = try? Data(contentsOf: dataUrl) else {return}

        image.image = UIImage(data: imageData)
    }
}
