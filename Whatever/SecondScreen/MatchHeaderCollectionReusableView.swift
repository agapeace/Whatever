//
//  MatchHeaderCollectionReusableView.swift
//  Whatever
//
//  Created by Damir Agadilov  on 25.06.2025.
//

import UIKit

class MatchHeaderCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "MatchHeaderCollectionReusableView"
    
    private let tournamentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ron")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let tournamentNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Tournament Name"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    func configureElements(tournamentId: Int, name: String, country: String) {
        self.tournamentNameLabel.text = name
        let tournamentURL = URL(string: "https://sofascore.p.rapidapi.com/tournaments/get-logo?tournamentId=\(tournamentId)")
        let modifier = NetworkManager2.shared.createRequest()
//        self.tournamentImageView.kf.setImage(with: tournamentURL, options: [.requestModifier(modifier)]) { [self] result in
//            switch result {
//            case .success(let value):
//                if value.image.size == .zero {
//                    print("204 No Content for id: \(tournamentId)")
//                    tournamentImageView.image = flagEmojiImage(for: country)
//                }
//                
//            case .failure(let error):
//                print("Failure for id \(tournamentId) \(error)")
//                
//                tournamentImageView.image = flagEmojiImage(for: country)
//            }
//        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTournamentImageView()
        setUpTournamentNameLabel()
    }
    
    private func setUpTournamentImageView() {
        addSubview(tournamentImageView)
        
        tournamentImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(40)
        }
    }
    
    private func setUpTournamentNameLabel() {
        addSubview(tournamentNameLabel)
        
        tournamentNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(tournamentImageView.snp.trailing).offset(43)
            make.trailing.equalToSuperview().inset(10)
            make.height.equalTo(45)
        }
    }
    
    func flagEmojiImage(for countryCode: String, fontSize: CGFloat = 40) -> UIImage? {
        let base : UInt32 = 127397
        var emoji = ""
        for scalar in countryCode.uppercased().unicodeScalars {
            guard let scalarValue = UnicodeScalar(base + scalar.value) else { return nil }
            emoji.unicodeScalars.append(scalarValue)
        }

        let label = UILabel()
        label.text = emoji
        label.font = .systemFont(ofSize: fontSize)
        label.sizeToFit()

        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
