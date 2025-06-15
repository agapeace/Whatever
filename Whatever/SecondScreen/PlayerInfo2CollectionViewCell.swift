//
//  PlayerInfo2CollectionViewCell.swift
//  Whatever
//
//  Created by Damir Agadilov  on 12.06.2025.
//

import UIKit
import Kingfisher

class PlayerInfo2CollectionViewCell: UICollectionViewCell {
    
    private var playerInfo: PlayerResponse?
    private var player: EntityResponse?
    
    static let identifier = "PlayerInfo2CollectionViewCell"
    private let circleSize = 50
    private lazy var clubImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = CGFloat(circleSize / 2)
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "ron")
        return imageView
    }()
    
    private var contractStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 3
        return stackView
    }()
    
    private let clubNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Default Club"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let contractInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Contract until 30 Jun 2025"
        label.textColor = #colorLiteral(red: 0.5873699188, green: 0.594819963, blue: 0.5993233323, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let detailInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let secondDetailInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var nationalityLabel = createCustomLabel(text: "Nationality")
    private lazy var birthDateLabel = createCustomLabel(text: "Age")
    private lazy var heightLabel = createCustomLabel(text: "Height")
    private lazy var footLabel = createCustomLabel(text: "Foot")
    private lazy var positionLabel = createCustomLabel(text: "Position")
    private lazy var shirtNumberLabel = createCustomLabel(text: "Shirt Number")
    
    func configureElements(playerInfo: PlayerResponse, player: EntityResponse) {
        self.player = player

        let flag = flagEmoji(for: player.country?.alpha2 ?? "PT")
        let countryName = countryFirstLetters(text: player.country?.name ?? "Portugal")
        let age = convertTimestampAndCalculateYears(from: TimeInterval(playerInfo.dateOfBirthTimestamp))
        createLabelAttributes(label: nationalityLabel, text: flag + countryName)
        createLabelAttributes(label: birthDateLabel, text: String(age.fullYears) + " yrs")
        createLabelAttributes(label: heightLabel, text: String(playerInfo.height) + " cm")
        createLabelAttributes(label: footLabel, text: playerInfo.preferredFoot.uppercased())
        let modifier = NetworkManager2.shared.createRequest()
        let clubUrl = URL(string: "https://sofascore.p.rapidapi.com/teams/get-logo?teamId=\(player.team?.id ?? 750)")
        clubImageView.kf.setImage(with: clubUrl, options: [.requestModifier(modifier)])
        clubNameLabel.text = player.team?.name ?? "No Name"
        let contract = convertTimestampAndCalculateYears(from: TimeInterval(playerInfo.contractUntilTimestamp ?? 1000000000000))
        contractInfoLabel.text = playerInfo.contractUntilTimestamp == nil ? "" : "Contract until " + formatDate(contract.date)
        
        createLabelAttributes(label: positionLabel, text: playerInfo.position)
        createLabelAttributes(label: shirtNumberLabel, text: playerInfo.jerseyNumber ?? "")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = #colorLiteral(red: 0.1526213586, green: 0.1714697778, blue: 0.1979335845, alpha: 1)
        contentView.layer.cornerRadius = 15
        
        setUpClubImageView()
        setUpContractStackView()
        setUpDetailInfoStackView()
        setUpSecondDetailInfoStackView()
        
    }
    
    func setUpClubImageView() {
        contentView.addSubview(clubImageView)
        
        clubImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(10)
            make.height.width.equalTo(circleSize)
        }
    }
    
    func setUpContractStackView() {
        contentView.addSubview(contractStackView)
        
        contractStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalTo(clubImageView.snp.trailing).offset(15)
            make.height.equalTo(50)
            make.trailing.equalToSuperview().inset(10)
        }
        
        contractStackView.addArrangedSubview(clubNameLabel)
        contractStackView.addArrangedSubview(contractInfoLabel)
    }
    
    func setUpDetailInfoStackView() {
        contentView.addSubview(detailInfoStackView)
        
        detailInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(contractStackView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(50)
        }
        detailInfoStackView.addArrangedSubview(nationalityLabel)
        detailInfoStackView.addArrangedSubview(birthDateLabel)
        detailInfoStackView.addArrangedSubview(heightLabel)
        detailInfoStackView.addArrangedSubview(footLabel)
    }
    
    func setUpSecondDetailInfoStackView() {
        contentView.addSubview(secondDetailInfoStackView)
        
        secondDetailInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(detailInfoStackView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(50)
        }
        
        secondDetailInfoStackView.addArrangedSubview(positionLabel)
        secondDetailInfoStackView.addArrangedSubview(shirtNumberLabel)
    }
    
    private func createCustomLabel(text: String) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: #colorLiteral(red: 0.5873699188, green: 0.594819963, blue: 0.5993233323, alpha: 1),
            .font: UIFont.systemFont(ofSize: 14)
        ]
        label.attributedText = NSAttributedString(string: text + "\n", attributes: textAttributes)
        label.numberOfLines = 2
        return label
    }
    
    private func createLabelAttributes(label: UILabel, text: String) {
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 16)
        ]
        
        let dynamicAttr = NSAttributedString(string: text, attributes: textAttributes)
        guard let defaultAttr = label.attributedText else { return }
        
        let mutableString = NSMutableAttributedString(attributedString: defaultAttr)
        mutableString.append(dynamicAttr)
        label.attributedText = mutableString
    }
    
    private func flagEmoji(for countryCode: String) -> String {
        let base: UInt32 = 127397
        var emoji = ""
        countryCode.uppercased().unicodeScalars.forEach {
            if let scalar = UnicodeScalar(base + $0.value) {
                emoji.unicodeScalars.append(scalar)
            }
        }
        return emoji
    }
    
    func convertTimestampAndCalculateYears(from timestamp: TimeInterval) -> (date: Date, fullYears: Int) {
        let date = Date(timeIntervalSince1970: timestamp)
        
        let calendar = Calendar.current
        let now = Date()
        
        let components = calendar.dateComponents([.year], from: date, to: now)
        let fullYears = components.year ?? 0
        
        return (date, fullYears)
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
    
    private func countryFirstLetters(text: String) -> String{
        return String(text.prefix(3)).uppercased()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
