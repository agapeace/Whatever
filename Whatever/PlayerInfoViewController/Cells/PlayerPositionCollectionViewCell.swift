import UIKit

class PlayerPositionCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PlayerPositionCollectionViewCell"
    ///Array that contains players position
    private var playerPositions: [String] = []
    ///ImageVIew for displaying players position on the pitch
    private let playerPositionImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = #colorLiteral(red: 0.1526213586, green: 0.1714697778, blue: 0.1979335845, alpha: 1)
        contentView.layer.cornerRadius = 15
        setUpPlayerPositionImageView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI Element Configuration

extension PlayerPositionCollectionViewCell {
    func configurePositions(positions: [String]) {
        self.playerPositions = positions
        layoutIfNeeded()
        renderMarkers()
    }
}

//MARK: - UI Elements SetUp
private extension PlayerPositionCollectionViewCell {
    ///Method for setting up playerPositionImageView
    func setUpPlayerPositionImageView() {
        contentView.addSubview(playerPositionImageView)
        playerPositionImageView.contentMode = .scaleToFill
        playerPositionImageView.image = UIImage(named: "pitch")
        playerPositionImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview().inset(85)
            make.height.equalTo(300)
        }
    }
    
    func renderMarkers() {
        playerPositionImageView.subviews.forEach { $0.removeFromSuperview() }

        guard playerPositionImageView.bounds != .zero else { return }

        for position in playerPositions {
            addPlayerMarker(position: position)
        }
    }
}

//MARK: - Adding Player Position
private extension PlayerPositionCollectionViewCell {
    ///Method for adding marker on the pitch based on player position
    func addPlayerMarker(position: String) {
        guard playerPositionImageView.bounds != .zero else { return }

        let markerSize: CGFloat = 40
        let (point, color) = coordinates(for: position, in: playerPositionImageView)

        let markerView = UIView(frame: CGRect(x: 0, y: 0, width: markerSize, height: markerSize))
        markerView.center = point
        markerView.backgroundColor = UIColor(red: 0.09, green: 0.11, blue: 0.12, alpha: 1)
        markerView.layer.cornerRadius = markerSize / 2
        markerView.clipsToBounds = true

        let label = UILabel(frame: markerView.bounds)
        label.text = position
        label.textColor = color
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center

        markerView.addSubview(label)
        playerPositionImageView.addSubview(markerView)
    }
}
