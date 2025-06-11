//
//  ImageCollectionViewCell.swift
//  Whatever
//
//  Created by Damir Agadilov  on 10.06.2025.
//

import UIKit
import Kingfisher

class ImageCollectionViewCell: UICollectionViewCell {
    
    
    static let identifier = "ImageCollectionViewCell"
    private let circleSize = 100
    private let smallCircleSize = 25
    private lazy var playerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "ron")
        imageView.layer.cornerRadius = CGFloat(circleSize / 2)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let playerNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.backgroundColor = .clear
        label.textColor = .white
        label.text = "Default text"
        return label
    }()
    
    private let firstStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private let secondStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var clubImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "ron")
        imageView.layer.cornerRadius = CGFloat(smallCircleSize / 2)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let clubLabel: UILabel = {
        let label = UILabel()
        label.text = "Default club"
        label.textColor = .white
        label.sizeToFit()
        return label
    }()
    
    private let circleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "circle.fill")
        imageView.tintColor = #colorLiteral(red: 0.3028887808, green: 0.3154447377, blue: 0.3345597088, alpha: 1)
        return imageView
    }()
    
    private let footballIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "soccerball.inverse")
        imageView.tintColor = #colorLiteral(red: 0.3028887808, green: 0.3154447377, blue: 0.3345597088, alpha: 1)
        return imageView
    }()
    
    private let footballLabel: UILabel = {
        let label = UILabel()
        label.text = "Football"
        label.textColor = .white
        return label
    }()
    
    func configureElements(playerId: Int, playerName: String, clubId: Int, clubName: String) {
        
        self.playerNameLabel.text = playerName
        self.clubLabel.text = clubName
        let modifier = NetworkManager2.shared.createRequest()
        let playerUrl = URL(string: "https://sofascore.p.rapidapi.com/players/get-image?playerId=\(playerId)")
        let clubUrl = URL(string: "https://sofascore.p.rapidapi.com/teams/get-logo?teamId=\(clubId)")
        playerImageView.kf.setImage(with: playerUrl, options: [.requestModifier(modifier)])
        clubImageView.kf.setImage(with: clubUrl, options:[.requestModifier(modifier)])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = #colorLiteral(red: 0.1526213586, green: 0.1714697778, blue: 0.1979335845, alpha: 1)
        contentView.layer.cornerRadius = 15
        
        setUpPlayerImageView()
        setUpSecondStackView()
        setUpFirstStackView()
    }
    
    func setUpPlayerImageView() {
        contentView.addSubview(playerImageView)
        
        playerImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(circleSize)
            make.leading.equalToSuperview().offset(10)
        }
    }
    
    func setUpSecondStackView() {
        contentView.addSubview(secondStackView)
        
        secondStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(playerImageView.snp.trailing).offset(10)
            make.height.equalTo(70)
            make.trailing.equalToSuperview().inset(10)
        }
        
        secondStackView.addArrangedSubview(playerNameLabel)
        secondStackView.addArrangedSubview(firstStackView)
    }
    
    func setUpFirstStackView() {
        firstStackView.addArrangedSubview(clubImageView)
        firstStackView.addArrangedSubview(clubLabel)
        firstStackView.addArrangedSubview(circleImageView)
        firstStackView.addArrangedSubview(footballIconImageView)
        firstStackView.addArrangedSubview(footballLabel)
        
        clubLabel.setContentHuggingPriority(.required, for: .horizontal)
        clubLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        clubImageView.snp.makeConstraints { make in
            make.height.width.equalTo(smallCircleSize)
        }
        
        circleImageView.snp.makeConstraints { make in
            make.height.width.equalTo(smallCircleSize / 2)
        }
        
        footballIconImageView.snp.makeConstraints { make in
            make.height.width.equalTo(smallCircleSize)
        }
        
    }
    
    func setUpPlayerNameLabel() {
        contentView.addSubview(playerNameLabel)
        
        playerNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(playerImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(10)
            make.height.equalTo(50)
        }
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
