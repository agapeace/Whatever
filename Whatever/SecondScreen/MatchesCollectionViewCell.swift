//
//  MatchesCollectionViewCell.swift
//  Whatever
//
//  Created by Damir Agadilov  on 24.06.2025.
//

import UIKit

class MatchesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MatchesCollectionViewCell"
    
    private lazy var startTimeLabel = createLabel(text: "16:00", textColor: #colorLiteral(red: 0.5873699188, green: 0.594819963, blue: 0.5993233323, alpha: 1), textAligment: .center)
    private lazy var currentPlayTimeLabel = createLabel(text: "45+", textColor: #colorLiteral(red: 0.9044718742, green: 0.2315939069, blue: 0.2334573567, alpha: 1), textAligment: .center)
    
    private lazy var timeStackView: UIStackView = createStackView()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2593512237, green: 0.2680180669, blue: 0.2780236602, alpha: 1)
        return view
    }()
    
    private lazy var homeClubImageView = createImageView()
    private lazy var awayClubImageView = createImageView()
    private lazy var clubsImageStackView: UIStackView = createStackView()
    
    private lazy var homeClubNameLabel = createLabel(text: "Zhetysu")
    private lazy var awayClubNameLabel = createLabel(text: "Qingdao")
    private lazy var clubsNameStackView = createStackView()
    
    private lazy var homeClubScoreLabel = createLabel(text: "3", textColor: #colorLiteral(red: 0.9044718742, green: 0.2315939069, blue: 0.2334573567, alpha: 1))
    private lazy var awayClubScoreLabel = createLabel(text: "2", textColor: #colorLiteral(red: 0.9044718742, green: 0.2315939069, blue: 0.2334573567, alpha: 1))
    private lazy var clubsScoreStackView = createStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = #colorLiteral(red: 0.1526213586, green: 0.1714697778, blue: 0.1979335845, alpha: 1)
        contentView.layer.cornerRadius = 15
        
        setUpTimeStackView()
        setUpSeparatorLine()
        setUpClubsImageStackView()
        setUpClubsNameStackView()
        setUpClubsScoreStackView()
    }
    
    private func setUpTimeStackView(){
        contentView.addSubview(timeStackView)
        timeStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(45)
        }
        timeStackView.addArrangedSubview(startTimeLabel)
        timeStackView.addArrangedSubview(currentPlayTimeLabel)
        
    }
    
    private func setUpSeparatorLine() {
        contentView.addSubview(separatorLine)
        
        separatorLine.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.equalTo(timeStackView.snp.trailing).offset(20)
            make.width.equalTo(1)
        }
    }
    
    private func setUpClubsImageStackView() {
        contentView.addSubview(clubsImageStackView)
        
        clubsImageStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(separatorLine.snp.trailing).offset(20)
            make.height.equalTo(55)
            make.width.equalTo(25)
        }
        clubsImageStackView.addArrangedSubview(homeClubImageView)
        clubsImageStackView.addArrangedSubview(awayClubImageView)
        
        homeClubImageView.snp.makeConstraints { make in
            make.width.height.equalTo(25)
        }
        
        awayClubImageView.snp.makeConstraints { make in
            make.width.height.equalTo(25)
        }
        
    }
    
    private func setUpClubsNameStackView() {
        contentView.addSubview(clubsNameStackView)
        
        clubsNameStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(clubsImageStackView.snp.trailing).offset(10)
            make.height.equalTo(45)
        }
        
        clubsNameStackView.addArrangedSubview(homeClubNameLabel)
        clubsNameStackView.addArrangedSubview(awayClubNameLabel)
    }
    
    private func setUpClubsScoreStackView() {
        contentView.addSubview(clubsScoreStackView)
        
        clubsScoreStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        
        clubsScoreStackView.addArrangedSubview(homeClubScoreLabel)
        clubsScoreStackView.addArrangedSubview(awayClubScoreLabel)
    }
    
    private func createStackView(backgroundColor: UIColor = .clear) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.backgroundColor = backgroundColor
        return stackView
    }
    
    private func createLabel(text: String, textColor: UIColor = UIColor.white, textAligment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.textAlignment = textAligment
        return label
    }
    
    private func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ron")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
