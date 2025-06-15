//
//  PlayerInfoCollectionViewCell.swift
//  Whatever
//
//  Created by Damir Agadilov  on 11.06.2025.
//

import UIKit

class PlayerInfoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PlayerInfoCollectionViewCell"
    
    private let circleSize = 100
    
    private lazy var personImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "ron")
        imageView.layer.cornerRadius = CGFloat(circleSize / 2)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let playerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Default text"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    func configureElements(playerId: Int, playerName: String, firstColor: UIColor) {
        playerNameLabel.text = playerName
        setGradientBackground(middleColor: firstColor)
        let modifier = NetworkManager2.shared.createRequest()
        let playerUrl = URL(string: "https://sofascore.p.rapidapi.com/players/get-image?playerId=\(playerId)")
        personImageView.kf.setImage(with: playerUrl, options: [.requestModifier(modifier)])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        
        setUpPersonImageView()
        setUpPlayerNameLabel()
    }
    
    func setUpPersonImageView() {
        contentView.addSubview(personImageView)
        
        personImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(circleSize)
            make.leading.equalToSuperview().offset(10)
        }
    }
    
    func setUpPlayerNameLabel() {
        contentView.addSubview(playerNameLabel)
        
        playerNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.leading.equalTo(personImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(10)
        }
    }
    
    private func setGradientBackground(middleColor: UIColor) {
        let gradient = CAGradientLayer()
        gradient.colors = [#colorLiteral(red: 0.1526213586, green: 0.1714697778, blue: 0.1979335845, alpha: 1).cgColor, middleColor.cgColor, #colorLiteral(red: 0.1529411765, green: 0.1725490196, blue: 0.1960784314, alpha: 1).cgColor]
        gradient.locations = [0.0, -0.8, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.frame = contentView.bounds
        
        contentView.layer.insertSublayer(gradient, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let first = contentView.layer.sublayers?.first as? CAGradientLayer {
            first.frame = contentView.bounds
        }
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
