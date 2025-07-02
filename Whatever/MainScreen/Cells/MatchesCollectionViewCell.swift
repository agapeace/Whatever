import UIKit
import Kingfisher

class MatchesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MatchesCollectionViewCell"
    
    private lazy var startTimeLabel = createLabel(textColor: #colorLiteral(red: 0.5873699188, green: 0.594819963, blue: 0.5993233323, alpha: 1), textAligment: .center)
    private lazy var currentPlayTimeLabel = createLabel(textColor: #colorLiteral(red: 0.9044718742, green: 0.2315939069, blue: 0.2334573567, alpha: 1), textAligment: .center, isBold: true)
    private lazy var timeStackView: UIStackView = createStackView()
    
    private let separatorLine = UIView()
    
    private lazy var homeClubImageView = createImageView()
    private lazy var awayClubImageView = createImageView()
    private lazy var clubsImageStackView = createStackView()
    
    private lazy var homeClubNameLabel = createLabel()
    private lazy var awayClubNameLabel = createLabel()
    private lazy var clubsNameStackView = createStackView()
    
    private lazy var homeClubScoreLabel = createLabel(textColor: .white)
    private lazy var awayClubScoreLabel = createLabel(textColor: .white)
    private lazy var clubsScoreStackView = createStackView()
    
    private let viewModel = MainScreenViewModel()
    
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Configuring UI Elements content. This method is called from cellForItemAt

extension MatchesCollectionViewCell {
    ///Configuring UI Elements content
    func configureElements(club: LiveEventsResponse) {
        self.startTimeLabel.text = club.startTimeText
        self.currentPlayTimeLabel.text = club.currentPlayTimeText
        
        updateClubImage(for: homeClubImageView, clubId: club.homeTeam.id)
        updateClubImage(for: awayClubImageView, clubId: club.awayTeam.id)
        
        updateClubElemets(club: club)
        updateScoreLabelColor(scoreStatus: club.scoreStatus ?? "equal")
    }
}

//MARK: - Updating UI Element's content

private extension MatchesCollectionViewCell {
    ///Method for updating Home and Away Club Images
    func updateClubImage(for imageView: UIImageView, clubId: Int, fallbackImageName: String = "club") {
        let (url, modifier) = viewModel.createKingfisherAttributes(id: clubId, stringType: .teamsLogo)
        imageView.kf.setImage(with: url, options: [.requestModifier(modifier)]) { result in
            if case .failure = result {
                imageView.image = UIImage(named: fallbackImageName)
            }
        }
    }

    ///Method for updating Home and Away Score UI Elements
    func updateClubElemets(club: LiveEventsResponse) {
        self.homeClubNameLabel.text = club.homeTeam.name
        self.awayClubNameLabel.text = club.awayTeam.name
        self.homeClubScoreLabel.text = String(club.homeScore.current)
        self.awayClubScoreLabel.text = String(club.awayScore.current)
    }
    ///Method for updating Score labels color based on the score
    func updateScoreLabelColor(scoreStatus: String) {
        if scoreStatus == ScoreStatus.advantageHome.rawValue {
            self.homeClubScoreLabel.textColor = .white
            self.awayClubScoreLabel.textColor = #colorLiteral(red: 0.5647191405, green: 0.5684482455, blue: 0.5727850795, alpha: 1)
        } else if scoreStatus == ScoreStatus.advantageAway.rawValue {
            self.homeClubScoreLabel.textColor = #colorLiteral(red: 0.5647191405, green: 0.5684482455, blue: 0.5727850795, alpha: 1)
            self.awayClubScoreLabel.textColor = .white
        }
    }
}

//MARK: - UI Elements SetUp

private extension MatchesCollectionViewCell {
    ///Method for setting up timeStackView
    func setUpTimeStackView(){
        contentView.addSubview(timeStackView)
        timeStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(45)
            make.width.equalTo(50)
        }
        timeStackView.addArrangedSubview(startTimeLabel)
        timeStackView.addArrangedSubview(currentPlayTimeLabel)
    }
    
    ///Method for setting up separatorLine view
    func setUpSeparatorLine() {
        contentView.addSubview(separatorLine)
        separatorLine.backgroundColor = #colorLiteral(red: 0.2593512237, green: 0.2680180669, blue: 0.2780236602, alpha: 1)
        separatorLine.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.equalTo(timeStackView.snp.trailing).offset(20)
            make.width.equalTo(1)
        }
    }
    
    ///Method for setting up clubsImageStackView
    func setUpClubsImageStackView() {
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
    
    ///Method for setting up clubsNameStackView
    func setUpClubsNameStackView() {
        contentView.addSubview(clubsNameStackView)
        
        clubsNameStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(clubsImageStackView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(30)
            make.height.equalTo(45)
        }
        
        clubsNameStackView.addArrangedSubview(homeClubNameLabel)
        clubsNameStackView.addArrangedSubview(awayClubNameLabel)
    }
    
    ///Method for setting up clubsScoreStackView
    func setUpClubsScoreStackView() {
        contentView.addSubview(clubsScoreStackView)
        
        clubsScoreStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        
        clubsScoreStackView.addArrangedSubview(homeClubScoreLabel)
        clubsScoreStackView.addArrangedSubview(awayClubScoreLabel)
    }
}

//MARK: - UI Elements Creation

private extension MatchesCollectionViewCell {
    ///Method for creating stackView
    func createStackView(backgroundColor: UIColor = .clear) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.backgroundColor = backgroundColor
        return stackView
    }
    ///Method for creating Label
    func createLabel(text: String = "", textColor: UIColor = UIColor.white, textAligment: NSTextAlignment = .left, isBold: Bool = false) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.textAlignment = textAligment
        label.font = isBold ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 16)
        return label
    }
    ///Method for creating ImageView
    func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
}
