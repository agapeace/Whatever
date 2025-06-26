//
//  PlayerPositionCollectionViewCell.swift
//  Whatever
//
//  Created by Damir Agadilov  on 18.06.2025.
//

import UIKit

class PlayerPositionCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PlayerPositionCollectionViewCell"
    
    private var playerPositions: [String] = []
    
    private let playerPositionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "pitch")
        return imageView
    }()
    
    func configurePositions(positions: [String]) {
        self.playerPositions = positions
        layoutIfNeeded()
        renderMarkers()
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpPlayerPositionImageView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    func setUpPlayerPositionImageView() {
        contentView.addSubview(playerPositionImageView)
        contentView.backgroundColor = #colorLiteral(red: 0.1526213586, green: 0.1714697778, blue: 0.1979335845, alpha: 1)
        contentView.layer.cornerRadius = 15
        playerPositionImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview().inset(85)
            make.height.equalTo(300)
        }
    }
    
    private func renderMarkers() {
        playerPositionImageView.subviews.forEach { $0.removeFromSuperview() }

        guard playerPositionImageView.bounds != .zero else { return }

        for position in playerPositions {
            addPlayerMarker(position: position)
        }
    }
    
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
