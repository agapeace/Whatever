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
        collection.register(MatchHeaderCollectionReusableView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: MatchHeaderCollectionReusableView.identifier)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setUpMatchesCollectionView()
        fetchLiveMatches()
    }
    
    private func fetchLiveMatches() {
        NetworkManager2.shared.fetchLiveMatches { [weak self] collection in
            self?.resourseArr = collection
            print("Hellooooo")
            guard let firstElement = self?.resourseArr[0][0] else { return }
            
            print(firstElement)
            
            let startTime = self?.convertTimestampAndCalculateYears(from: TimeInterval(firstElement.startTimestamp))
            let changeTime = self?.convertTimestampAndCalculateYears(from: TimeInterval(firstElement.changes.changeTimeStamp ?? 100))
            let currentTime = self?.convertTimestampAndCalculateYears(from: TimeInterval(firstElement.time.currentPeriodStartTimestamp ?? 100))
            
            print("Startime is: \(String(describing: startTime?.date))")
            print("ChangeTime is: \(String(describing: changeTime?.date))")
            print("currentTime is: \(String(describing: currentTime?.date))")
            
            DispatchQueue.main.async {
                self?.matchesCollectionView.reloadData()
            }
        }
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            return self.createFirstSection()
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        layout.register(SectionBackgroundView.self, forDecorationViewOfKind: SectionBackgroundView.identifier)
        return layout
    }
    
    private func createFirstSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 0, bottom: 0, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(110))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading)
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: SectionBackgroundView.identifier)
        backgroundItem.contentInsets = .zero
        section.decorationItems = [backgroundItem]
        
        
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
    
    func convertTimestampAndCalculateYears(from timestamp: TimeInterval) -> (date: Date, startTime: String) {
        let date = Date(timeIntervalSince1970: timestamp)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = .current
        
        let hourString = dateFormatter.string(from: date)
        
        return (date, hourString)
    }
}

extension MainScreen: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return resourseArr.isEmpty ? 0 : resourseArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return section % 2 == 0 ? 2 : 1
        return resourseArr.isEmpty ? 0 : resourseArr[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = MatchesCollectionViewCell.identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MatchesCollectionViewCell
        if !resourseArr.isEmpty {
            cell.configureElements(club: resourseArr[indexPath.section][indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerId = MatchHeaderCollectionReusableView.identifier
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! MatchHeaderCollectionReusableView
            let currentSection = resourseArr[indexPath.section][0]
            headerView.configureElements(
                tournamentId: currentSection.tournament.uniqueTournament?.id ?? currentSection.tournament.id,
                name: currentSection.tournament.name,
                country: currentSection.tournament.category.country?.alpha2 ?? "CA")
            return headerView
        }
        
        return UICollectionReusableView()
    }
}
