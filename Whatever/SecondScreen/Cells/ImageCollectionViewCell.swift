import UIKit
import Kingfisher

class ImageCollectionViewCell: UICollectionViewCell {
    
    
    static let identifier = "ImageCollectionViewCell"

    private let circleSize = 100
    private let smallCircleSize = 25

    ///ImageView that shows player
    private lazy var playerImageView = createImageView(isSystemImage: false, cornerRadius: CGFloat(circleSize))
    ///Players name label
    private lazy var playerNameLabel = createLabel(font: UIFont.boldSystemFont(ofSize: 20))
    ///FirstStackView that contains Club Image + Name + Additional Information
    private lazy var firstStackView = createStackView(axis: .horizontal, alignment: .center, distribution: .fill)
    ///SecondStackView that contains firstStackView + PlayerNameLabel
    private lazy var secondStackView = createStackView(axis: .vertical, alignment: .fill, distribution: .fill)
    private lazy var clubImageView = createImageView(isSystemImage: false, cornerRadius: CGFloat(smallCircleSize))
    private lazy var clubLabel = createLabel(isSizeToFit: true)
    
    ///Additional information such as: Football Icon, Football text etc.
    private lazy var circleImageView = createImageView(isSystemImage: true, tintColor: #colorLiteral(red: 0.3028887808, green: 0.3154447377, blue: 0.3345597088, alpha: 1))
    private lazy var footballIconImageView = createImageView(isSystemImage: true, systemName: "soccerball.inverse", tintColor: #colorLiteral(red: 0.3028887808, green: 0.3154447377, blue: 0.3345597088, alpha: 1))
    private lazy var footballLabel = createLabel(text: "Football")
    
    ///Instance of viewModel class
    private let viewModel = SecondScreenViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = #colorLiteral(red: 0.1526213586, green: 0.1714697778, blue: 0.1979335845, alpha: 1)
        contentView.layer.cornerRadius = 15
        
        setUpPlayerImageView()
        setUpSecondStackView()
        setUpFirstStackView()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Configuration Method that is called form cellForItemAt

extension ImageCollectionViewCell {
    func configureElements(entity: EntityResponse) {
        
        self.playerNameLabel.text = entity.name
        self.clubLabel.text = entity.team?.name
    
        updateImageView(for: playerImageView, id: entity.id, stringType: .playerImage)
        updateImageView(for: clubImageView, id: entity.team?.id ?? 1, stringType: .teamsLogo)
    }
}

//MARK: - Update UI Elements

private extension ImageCollectionViewCell {
    ///Method for making request to iamgeView by Kingfisher
    func updateImageView(for imageView: UIImageView, id: Int, stringType: URLStringTypes) {
        let (url, modifier) = viewModel.createKingfisherAttributes(id: id, stringType: stringType)
        imageView.kf.setImage(with: url, options: [.requestModifier(modifier)])
    }
}

//MARK: - UI Elements Set Up

private extension ImageCollectionViewCell {
    ///Method for setting up PlayerImageView
    func setUpPlayerImageView() {
        contentView.addSubview(playerImageView)
        
        playerImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(circleSize)
            make.leading.equalToSuperview().offset(10)
        }
    }
    ///Method for setting up SecondStackView
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
    ///Method for setting up firstStackView
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
    ///Method for setting up Player NameLabel
    func setUpPlayerNameLabel() {
        contentView.addSubview(playerNameLabel)
        
        playerNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(playerImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(10)
            make.height.equalTo(50)
        }
    }
}

//MARK: - UI Element Configurations

private extension ImageCollectionViewCell {
    ///Method for creatng ImageView based on provided properties
    func createImageView(isSystemImage: Bool, systemName: String = "circle.fill", contentMode: UIImageView.ContentMode = .scaleAspectFill, cornerRadius: CGFloat = 0, tintColor: UIColor = .clear) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = contentMode
        imageView.layer.cornerRadius = cornerRadius == 0 ? 0 : cornerRadius / 2
        imageView.clipsToBounds = true
        imageView.tintColor = tintColor != .clear ? tintColor : nil
        imageView.image = isSystemImage ? UIImage(systemName: systemName) : nil
        return imageView
    }
    
    ///Method for creating stackView
    func createStackView(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat = 10) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        return stackView
    }
    
    ///Method for creating Labels
    func createLabel(text: String = "", textColor: UIColor = .white, font: UIFont? = nil, isSizeToFit: Bool = false, numberOfLines: Int = 1) -> UILabel {
        let label = UILabel()
        label.numberOfLines = numberOfLines
        label.text = text
        label.textColor = textColor
        label.font = font == nil ? nil : font
        isSizeToFit ? label.sizeToFit() : ()
        return label
    }
}
