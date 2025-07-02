import UIKit

class PlayerInfoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PlayerInfoCollectionViewCell"
    ///Attribute for specifying corner radius of ImageView
    private let circleSize = 100
    ///ImageView for displaying player
    private let personImageView = UIImageView()
    ///Label for displaying player name
    private let playerNameLabel = UILabel()
    ///Instance of viewModel
    private let viewModel = PlayerInfoViewModel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        
        setUpPersonImageView()
        setUpPlayerNameLabel()
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

//MARK: - UI Element Configuration Method that is called from cellForItemAt

extension PlayerInfoCollectionViewCell {
    func configureElements(playerId: Int, playerName: String, firstColor: UIColor) {
        playerNameLabel.text = playerName
        setGradientBackground(middleColor: firstColor)
        updateImageView(for: personImageView, id: playerId, stringType: .playerImage)
    }
}

//MARK: - UI Elements Update

private extension PlayerInfoCollectionViewCell {
    ///Method for setting backgroundColor based on provided user color
    func setGradientBackground(middleColor: UIColor) {
        let gradient = CAGradientLayer()
        gradient.colors = [#colorLiteral(red: 0.1526213586, green: 0.1714697778, blue: 0.1979335845, alpha: 1).cgColor, middleColor.cgColor, #colorLiteral(red: 0.1529411765, green: 0.1725490196, blue: 0.1960784314, alpha: 1).cgColor]
        gradient.locations = [0.0, -0.8, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.frame = contentView.bounds
        
        contentView.layer.insertSublayer(gradient, at: 0)
    }
    ///Method for updating playerImageView
    func updateImageView(for imageView: UIImageView, id: Int, stringType: URLStringTypes) {
        let (url, modifier) = viewModel.createKingFisherAttribute(id: id, stringType: .playerImage)
        imageView.kf.setImage(with: url, options: [.requestModifier(modifier)])
    }
}

//MARK: - UI Elements SetUp
private extension PlayerInfoCollectionViewCell {
    ///Method for setitng up person ImageView
    func setUpPersonImageView() {
        contentView.addSubview(personImageView)
        personImageView.contentMode = .scaleAspectFill
        personImageView.layer.cornerRadius = CGFloat(circleSize / 2)
        personImageView.clipsToBounds = true
        personImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(circleSize)
            make.leading.equalToSuperview().offset(10)
        }
    }
    ///Method for setting up player Label
    func setUpPlayerNameLabel() {
        contentView.addSubview(playerNameLabel)
        playerNameLabel.textColor = .white
        playerNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        playerNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.leading.equalTo(personImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(10)
        }
    }
}
