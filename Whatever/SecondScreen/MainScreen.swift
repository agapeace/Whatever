//
//  MainScreen.swift
//  Whatever
//
//  Created by Damir Agadilov  on 24.06.2025.
//

import Foundation
import UIKit

class MainScreen: UIViewController {
    
    private var resourseArr: [[LiveEventsResponse]] = []
    private lazy var matchesCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: self.createCompositionalLayout())
        collection.register(MatchesCollectionViewCell.self, forCellWithReuseIdentifier: MatchesCollectionViewCell.identifier)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        return collection
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
//        fetchLiveMatches()
        setUpMatchesCollectionView()
    }
    
    private func fetchLiveMatches() {
        NetworkManager2.shared.fetchLiveMatches { [weak self] collection in
            self?.resourseArr = collection
        }
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            return self.createFirstSection()
        }
    }
    
    private func createFirstSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 0, bottom: 5, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 15, leading: 0, bottom: 15, trailing: 0)
        return section
    }
    
    private func setUpMatchesCollectionView() {
        view.addSubview(matchesCollectionView)
        
        matchesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension MainScreen: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section % 2 == 0 ? 2 : 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = MatchesCollectionViewCell.identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MatchesCollectionViewCell
        
        return cell
    }
}
