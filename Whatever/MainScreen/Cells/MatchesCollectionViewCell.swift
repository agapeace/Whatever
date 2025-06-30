import UIKit
import Kingfisher

class MatchesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MatchesCollectionViewCell"
    
    private lazy var startTimeLabel = createLabel(text: "16:00", textColor: #colorLiteral(red: 0.5873699188, green: 0.594819963, blue: 0.5993233323, alpha: 1), textAligment: .center)
    private lazy var currentPlayTimeLabel = createLabel(text: "45+", textColor: #colorLiteral(red: 0.9044718742, green: 0.2315939069, blue: 0.2334573567, alpha: 1), textAligment: .center, isBold: true)
    
    private lazy var timeStackView: UIStackView = createStackView()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2593512237, green: 0.2680180669, blue: 0.2780236602, alpha: 1)
        return view
    }()
    
    private lazy var homeClubImageView = createImageView()
    private lazy var awayClubImageView = createImageView()
    private lazy var clubsImageStackView: UIStackView = createStackView()
    
    private lazy var homeClubNameLabel = createLabel(text: "Zhetysu Zhetysu Zhetysu Zhetysu Zhetysu")
    private lazy var awayClubNameLabel = createLabel(text: "Qingdao")
    private lazy var clubsNameStackView = createStackView()
    
    private lazy var homeClubScoreLabel = createLabel(text: "3", textColor: .white)
    private lazy var awayClubScoreLabel = createLabel(text: "2", textColor: .white)
    private lazy var clubsScoreStackView = createStackView()
    
    func configureElements(club: LiveEventsResponse) {
        self.startTimeLabel.text = convertTimestampAndCalculateYears(from: TimeInterval(club.startTimestamp), timeFormat: .hours).startTime
        self.currentPlayTimeLabel.text = calculateCurrentMinute(startTimeStamp: TimeInterval(club.startTimestamp), lastPeriod: club.lastPeriod)
        
//        let modifier = NetworkManager2.shared.createRequest()
//        let homeClubUrl = URL(string: "https://sofascore.p.rapidapi.com/teams/get-logo?teamId=\(club.homeTeam.id)")
//        let awayClubUrl = URL(string: "https://sofascore.p.rapidapi.com/teams/get-logo?teamId=\(club.awayTeam.id)")
//        self.homeClubImageView.kf.setImage(with: homeClubUrl, options: [.requestModifier(modifier)])
//        self.awayClubImageView.kf.setImage(with:awayClubUrl, options: [.requestModifier(modifier)])
        
        self.homeClubNameLabel.text = club.homeTeam.name
        self.awayClubNameLabel.text = club.awayTeam.name
        self.homeClubScoreLabel.text = String(club.homeScore.current)
        self.awayClubScoreLabel.text = String(club.awayScore.current)
        
        if club.homeScore.current > club.awayScore.current {
            self.homeClubScoreLabel.textColor = .white
            self.awayClubScoreLabel.textColor = #colorLiteral(red: 0.5647191405, green: 0.5684482455, blue: 0.5727850795, alpha: 1)
        } else if club.awayScore.current > club.homeScore.current {
            self.homeClubScoreLabel.textColor = #colorLiteral(red: 0.5647191405, green: 0.5684482455, blue: 0.5727850795, alpha: 1)
            self.awayClubScoreLabel.textColor = .white
        }
    }
    
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
            make.width.equalTo(50)
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
            make.trailing.equalToSuperview().inset(30)
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
    
    func convertTimestampAndCalculateYears(from timestamp: TimeInterval, timeFormat: TimeFormat) -> (date: Date, startTime: String) {
        let date = Date(timeIntervalSince1970: timestamp)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = timeFormat.rawValue
        dateFormatter.timeZone = .current
        
        let hourString = dateFormatter.string(from: date)
        
        return (date, hourString)
    }
    
    func calculateCurrentMinute(startTimeStamp: TimeInterval, lastPeriod: String?) -> String {
        let now = Date()

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        let currentTime = formatter.string(from: now)
        let start = convertTimestampAndCalculateYears(from: startTimeStamp, timeFormat: .hours)
        let value = minutesBetween(start.startTime, currentTime)

        guard let value else { return "45++" }

        if lastPeriod == nil, value > 45, value < 60 {
            return "HT"
        }
        
        if value <= 45 {
            return value <= 45 ? "\(value)'" : "45+"
        }
        
        if value > 60 && value < 130 {
            return value - 15 <= 90 ? "\(value - 15)'" : "90+"
        }

        return "FT"
        
    }
    
    func minutesBetween(_ time1: String, _ time2: String) -> Int? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date1 = formatter.date(from: time1.replacingOccurrences(of: " ", with: "")),
              let date2 = formatter.date(from: time2.replacingOccurrences(of: " ", with: "")) else {
            return nil
        }

        let diff = Calendar.current.dateComponents([.minute], from: date1, to: date2)
        return diff.minute
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
    
    private func createLabel(text: String, textColor: UIColor = UIColor.white, textAligment: NSTextAlignment = .left, isBold: Bool = false) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.textAlignment = textAligment
        label.font = isBold ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 16)
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
