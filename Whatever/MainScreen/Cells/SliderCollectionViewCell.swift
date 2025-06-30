import UIKit

class SliderCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SliderCollectionViewCell"
    
    private let tournamentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ron")
        return imageView
    }()
    
    func configureElements(image: UIImage) {
        self.tournamentImageView.image = image
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTournamentImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpTournamentImageView() {
        contentView.addSubview(tournamentImageView)
        
        tournamentImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
