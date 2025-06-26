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
    private let circleSize = 60
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
    
    private let thirdInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
//        stackView.spacing = 10
        stackView.backgroundColor = #colorLiteral(red: 0.03465448692, green: 0.04089608043, blue: 0.04450451583, alpha: 1)
        stackView.layer.cornerRadius = 15
        return stackView
    }()
    
    private let valueStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var priceView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let color: UIColor = #colorLiteral(red: 0.09227979928, green: 0.1076720729, blue: 0.119504787, alpha: 1)
    
    private lazy var higherButton = createCustomButton()
    private lazy var lowerButton = createCustomButton(arrowColor: .systemRed, isArrowDown: true)
    
    private lazy var nationalityLabel = createCustomLabel(text: "Nationality")
    private lazy var birthDateLabel = createCustomLabel(text: "Age")
    private lazy var heightLabel = createCustomLabel(text: "Height")
    private lazy var footLabel = createCustomLabel(text: "Foot")
    private lazy var positionLabel = createCustomLabel(text: "Position")
    private lazy var shirtNumberLabel = createCustomLabel(text: "Shirt Number")
    
    private lazy var valueLabel = createCustomLabel(text: "Market Value")
    private lazy var questionLabel = createCustomLabel(text: "Is market value higher or lower?", textColor: .white, numberOfLines: 1)
    
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
        playerInfo.jerseyNumber == nil ? shirtNumberLabel.isHidden = true : createLabelAttributes(label: shirtNumberLabel, text: playerInfo.jerseyNumber!)
        playerInfo.proposedMarketValue == nil ? thirdInfoStackView.isHidden = true : createLabelAttributes(label: valueLabel, text: formatMarketValue(playerInfo.proposedMarketValue!), textColor: #colorLiteral(red: 0.9098039216, green: 0.7003651261, blue: 0.2686780095, alpha: 1))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = #colorLiteral(red: 0.1526213586, green: 0.1714697778, blue: 0.1979335845, alpha: 1)
        contentView.layer.cornerRadius = 15
        
        setUpClubImageView()
        setUpContractStackView()
        setUpDetailInfoStackView()
        setUpSecondDetailInfoStackView()
        setUpThirdStackView()
        setUpValueStackView()
        setUpPriceStackView()
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
    
    func setUpThirdStackView() {
        contentView.addSubview(thirdInfoStackView)
        
        thirdInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(secondDetailInfoStackView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(150)
        }
        thirdInfoStackView.addArrangedSubview(valueStackView)

        thirdInfoStackView.addArrangedSubview(priceView)
    }
    
    func setUpValueStackView() {
    
        valueStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(50)
        }
        
        valueStackView.addArrangedSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
        }
        valueStackView.addArrangedSubview(questionLabel)
    }
    
    func setUpPriceStackView() {
        
        priceView.snp.makeConstraints { make in
            make.height.equalTo(70)
        }
        
        priceView.addSubview(higherButton)
        
        higherButton.snp.makeConstraints { make in
            make.height.width.equalTo(circleSize)
            make.leading.equalToSuperview().offset(100)
            make.centerY.equalToSuperview()
        }
        
        priceView.addSubview(lowerButton)
        
        lowerButton.snp.makeConstraints { make in
            make.height.width.equalTo(circleSize)
            make.trailing.equalToSuperview().inset(100)
            make.centerY.equalToSuperview()
        }
    }
    
    private func createCustomLabel(text: String, textColor: UIColor = #colorLiteral(red: 0.5873699188, green: 0.594819963, blue: 0.5993233323, alpha: 1), numberOfLines: Int = 2) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: textColor,
            .font: UIFont.systemFont(ofSize: 14)
        ]
        label.attributedText = NSAttributedString(string: text + "\n", attributes: textAttributes)
        label.numberOfLines = numberOfLines
        return label
    }
    
    private func createLabelAttributes(label: UILabel, text: String, textColor: UIColor = .white) {
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: textColor,
            .font: UIFont.boldSystemFont(ofSize: 16)
        ]
        
        let dynamicAttr = NSAttributedString(string: text, attributes: textAttributes)
        guard let defaultAttr = label.attributedText else { return }
        
        let mutableString = NSMutableAttributedString(attributedString: defaultAttr)
        mutableString.append(dynamicAttr)
        label.attributedText = mutableString
    }
    
    private func createCustomButton(arrowColor: UIColor = .systemGreen, isArrowDown: Bool = false) -> UIButton {
        let button = UIButton(type: .system)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .medium)
        let euroSonfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium)
        
        let arrowImage = UIImage(systemName: isArrowDown ? "arrowtriangle.down.fill" : "arrowtriangle.up.fill", withConfiguration: symbolConfig)?.withTintColor(arrowColor, renderingMode: .alwaysOriginal)
        let arrowAttachment = NSTextAttachment()
        arrowAttachment.image = arrowImage
        
        let euroImage = UIImage(systemName: "eurosign.circle.fill", withConfiguration: euroSonfig)?.withTintColor(#colorLiteral(red: 0.6431311965, green: 0.6609790325, blue: 0.7016974092, alpha: 1), renderingMode: .alwaysOriginal)
        let euroAttachment = NSTextAttachment()
        euroAttachment.image = euroImage
        
        let attributedtitle = NSMutableAttributedString()
        attributedtitle.append(isArrowDown ? NSAttributedString(attachment: euroAttachment) : NSAttributedString(attachment: arrowAttachment))
        attributedtitle.append(NSAttributedString(string: "\n"))
        attributedtitle.append(isArrowDown ? NSAttributedString(attachment: arrowAttachment) : NSAttributedString(attachment: euroAttachment))
        
        button.setAttributedTitle(attributedtitle, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.09227979928, green: 0.1076720729, blue: 0.119504787, alpha: 1)
        button.layer.cornerRadius = CGFloat(circleSize / 2)
        return button
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
    
    private func formatMarketValue(_ value: Int) -> String {
        let million = 1_000_000
        let thousand = 1_000
        
        if value >= million {
            let formatted = Double(value) / Double(million)
            return String(format: formatted >= 10 ? "%.0fM" : "%.1fM", formatted) + " €"
        } else if value >= thousand {
            let formatted = Double(value) / Double(thousand)
            return String(format: formatted >= 10 ? "%.0fK" : "%.1fK", formatted) + " €"
        } else {
            return "\(value) €"
        }
    }

    
    private func countryFirstLetters(text: String) -> String{
        return String(text.prefix(3)).uppercased()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
