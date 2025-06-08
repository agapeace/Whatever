//
//  FirstSectionCollectionViewCell.swift
//  Whatever
//
//  Created by Damir Agadilov  on 02.06.2025.
//

import UIKit
import Kingfisher

class FirstSectionCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FirstSectionCollectionViewCell"
    
    private var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Test Title"
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private var releaseYearTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Test Release Year"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    func configureElements(title: String, releaseYear: String, image: UIImage) {
        titleLabel.text = title
        releaseYearTitleLabel.text = releaseYear
        mainImageView.image = image
    }
    
    func configureWithKF(title: String, releaseYear: String, imageURL: String) {
        titleLabel.text = title
        releaseYearTitleLabel.text = releaseYear
        let url = URL(string: imageURL)
        mainImageView.kf.indicatorType = .activity
        mainImageView.kf.setImage(with: url, options: [.transition(.fade(1))])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 15
        contentView.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        setUpImageView()
        setUpStackView()
    }
    
    private func setUpImageView() {
        contentView.addSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(100)
//            make.height.equalTo(200)
        }
    }
    
    private func setUpStackView() {
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(releaseYearTitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
