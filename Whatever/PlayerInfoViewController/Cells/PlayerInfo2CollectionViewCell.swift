import UIKit
import Kingfisher

class PlayerInfo2CollectionViewCell: UICollectionViewCell {
    
    private var playerInfo: PlayerResponse?
    private var player: EntityResponse?
    
    static let identifier = "PlayerInfo2CollectionViewCell"
    ///Size of a circle
    private let circleSize = 60
    private let clubImageView = UIImageView()
    ///StackView that contains ContactInfoLabel + ClubNameLabel
    private lazy var contractStackView = createStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 3)
    ///Label for containing club name
    private lazy var clubNameLabel = createLabel(textColor: .white, font: UIFont.boldSystemFont(ofSize: 18))
    ///Label for containing contract info
    private lazy var contractInfoLabel = createLabel(textColor: #colorLiteral(red: 0.5873699188, green: 0.594819963, blue: 0.5993233323, alpha: 1), font: UIFont.systemFont(ofSize: 14))
    ///StackView that contains nationalityLabel + birthDateLabel + heightLabel + footLabel
    private lazy var detailInfoStackView = createStackView(axis: .horizontal, alignment: .fill, distribution: .equalSpacing)
    ///StackView that contains positionLabel + shirtNumberLabel
    private lazy var secondDetailInfoStackView = createStackView(axis: .horizontal, alignment: .fill, distribution: .fillEqually)
    ///StackView that contains valueStackView + priceView
    private lazy var thirdInfoStackView = createStackView(axis: .vertical, alignment: .fill, distribution: .fill, backgroundColor: #colorLiteral(red: 0.03465448692, green: 0.04089608043, blue: 0.04450451583, alpha: 1), cornerRadius: 15)
    ///StackView that contains questionLabel + valueLabel
    private lazy var valueStackView = createStackView(axis: .horizontal, alignment: .fill, distribution: .fill)
    ///view for containing info on price
    private let priceView = UIView()
    
    private let color: UIColor = #colorLiteral(red: 0.09227979928, green: 0.1076720729, blue: 0.119504787, alpha: 1)
    ///Higher or lower choose button
    private lazy var higherButton = createCustomButton()
    private lazy var lowerButton = createCustomButton(arrowColor: .systemRed, isArrowDown: true)
    ///Information Labels
    private lazy var nationalityLabel = createCustomLabel(text: "Nationality")
    private lazy var birthDateLabel = createCustomLabel(text: "Age")
    private lazy var heightLabel = createCustomLabel(text: "Height")
    private lazy var footLabel = createCustomLabel(text: "Foot")
    private lazy var positionLabel = createCustomLabel(text: "Position")
    private lazy var shirtNumberLabel = createCustomLabel(text: "Shirt Number")
    ///Information Labels pt.2
    private lazy var valueLabel = createCustomLabel(text: "Market Value")
    private lazy var questionLabel = createCustomLabel(text: "Is market value higher or lower?", textColor: .white, numberOfLines: 1)
    ///Instance of viewModel
    private let viewModel = PlayerInfoViewModel()
    
    func configureElements(playerInfo: PlayerResponse, player: EntityResponse) {
        self.player = player
        self.playerInfo = playerInfo
        
        configureFirstBlock()
        updateImageView(for: clubImageView, id: player.team?.id ?? 750, stringType: .teamsLogo)
        configureRestBlocks()
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
    
    private func countryFirstLetters(text: String) -> String{
        return String(text.prefix(3)).uppercased()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI Elements Content Configuration
private extension PlayerInfo2CollectionViewCell {
    ///Method for configuring first Block Information
    func configureFirstBlock() {
        let flag = viewModel.flagEmoji(for: player?.country?.alpha2 ?? "PT")
        let countryName = countryFirstLetters(text: player?.country?.name ?? "Portugal")
        let age = viewModel.convertTimestampAndCalculateYears(from: TimeInterval(playerInfo?.dateOfBirthTimestamp ?? 1000000000000))
        createLabelAttributes(label: nationalityLabel, text: flag + countryName)
        createLabelAttributes(label: birthDateLabel, text: String(age.fullYears) + " yrs")
        createLabelAttributes(label: heightLabel, text: String(playerInfo?.height ?? 180) + " cm")
        createLabelAttributes(label: footLabel, text: (playerInfo?.preferredFoot.uppercased())!)
    }
    
    ///Method for updating ImageView with KingFisher
    func updateImageView(for imageView: UIImageView, id: Int, stringType: URLStringTypes) {
        let (url, modifier) = viewModel.createKingFisherAttribute(id: id, stringType: stringType)
        imageView.kf.setImage(with: url, options: [.requestModifier(modifier)])
    }
    
    ///Method for Method for configuring second & third block Information
    func configureRestBlocks() {
        clubNameLabel.text = player?.team?.name ?? "No Name"
        let contract = viewModel.convertTimestampAndCalculateYears(from: TimeInterval(playerInfo?.contractUntilTimestamp ?? 1000000000000))
        contractInfoLabel.text = playerInfo?.contractUntilTimestamp == nil ? "" : "Contract until " + viewModel.formatDate(contract.date)
        
        createLabelAttributes(label: positionLabel, text: playerInfo?.position ?? "ST")
        playerInfo?.jerseyNumber == nil ? shirtNumberLabel.isHidden = true : createLabelAttributes(label: shirtNumberLabel, text: playerInfo?.jerseyNumber! ?? "9")
        playerInfo?.proposedMarketValue == nil ? thirdInfoStackView.isHidden = true : createLabelAttributes(label: valueLabel, text: viewModel.formatMarketValue(playerInfo?.proposedMarketValue! ?? 1200000), textColor: #colorLiteral(red: 0.9098039216, green: 0.7003651261, blue: 0.2686780095, alpha: 1))
    }
}

//MARK: - UI Elements Creation
private extension PlayerInfo2CollectionViewCell {
    ///Method for creating StackView
    func createStackView(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat = 0, backgroundColor: UIColor = .clear, cornerRadius: CGFloat = 0) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        stackView.backgroundColor = backgroundColor == .clear ? nil : backgroundColor
        stackView.layer.cornerRadius = cornerRadius
        return stackView
    }
    
    ///Method for creating Label
    func createLabel(textColor: UIColor, font: UIFont) -> UILabel {
        let label = UILabel()
        label.textColor = textColor
        label.font = font
        return label
    }
    ///Method for creating CustomLabel
    func createCustomLabel(text: String, textColor: UIColor = #colorLiteral(red: 0.5873699188, green: 0.594819963, blue: 0.5993233323, alpha: 1), numberOfLines: Int = 2) -> UILabel {
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
    ///Method for creatung label Attributes
    func createLabelAttributes(label: UILabel, text: String, textColor: UIColor = .white) {
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
    ///Method for creating custom Button with Image and title
    func createCustomButton(arrowColor: UIColor = .systemGreen, isArrowDown: Bool = false) -> UIButton {
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
}

//MARK: -UI Elements SetUP

private extension PlayerInfo2CollectionViewCell {
    ///Method for setting up ClubImageView
    func setUpClubImageView() {
        contentView.addSubview(clubImageView)
        clubImageView.contentMode = .scaleAspectFill
        clubImageView.layer.cornerRadius = CGFloat(circleSize / 2)
        clubImageView.clipsToBounds = true
        clubImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(10)
            make.height.width.equalTo(circleSize)
        }
    }
    ///Method for setting up ContractStackView
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
    ///Method for setting up detailInfoStackView
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
    ///Method for setting up secondDetailInfoStackView
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
    ///Method for setting up thirdInfoStackView
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
    ///Method for setting up valueStackView
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
    ///Method for setting up priceView
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
}
