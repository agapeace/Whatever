import UIKit

class MatchHeaderCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "MatchHeaderCollectionReusableView"
    
    private let tournamentImageView = UIImageView()
    private let tournamentNameLabel = UILabel()
    private let viewModel = MainScreenViewModel()
    
    func configureElements(tournamentId: Int, name: String, country: String) {
        self.tournamentNameLabel.text = name
        updateTournamentImageView(for: tournamentImageView, tournamentId: tournamentId, country: country)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTournamentImageView()
        setUpTournamentNameLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Updating UI Elements

private extension MatchHeaderCollectionReusableView {
    ///Method for updating Tournament Image
    func updateTournamentImageView(for imageView: UIImageView, tournamentId: Int, country: String) {
        let tournamentContent = viewModel.createKingfisherAttributes(id: tournamentId, stringType: .tournamentLogo)
        imageView.kf.setImage(with: tournamentContent.0, options: [.requestModifier(tournamentContent.1)]) { [weak self] result in
            switch result {
            case .success(let value):
                if value.image.size == .zero {
                    imageView.image = self?.viewModel.flagEmojiImage(for: country)
                }
            case .failure:
                imageView.image = self?.viewModel.flagEmojiImage(for: country)
            }
        }
    }
}

//MARK: - UI Elements SetUp

private extension MatchHeaderCollectionReusableView {
    ///Method for setting tournament ImageView
    func setUpTournamentImageView() {
        addSubview(tournamentImageView)
        tournamentImageView.image = UIImage(named: "ron")
        tournamentImageView.contentMode = .scaleAspectFit
        
        tournamentImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(40)
        }
    }
    
    ///Method for setting up the tournament Label
    func setUpTournamentNameLabel() {
        addSubview(tournamentNameLabel)
        tournamentNameLabel.text = "Tournament Name"
        tournamentNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        tournamentNameLabel.numberOfLines = 0
        tournamentNameLabel.textColor = .white
        tournamentNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(tournamentImageView.snp.trailing).offset(43)
            make.trailing.equalToSuperview().inset(10)
            make.height.equalTo(45)
        }
    }
}
