//
//  ViewController.swift
//  Whatever
//
//  Created by Damir Agadilov  on 06.05.2025.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let array: [TimeInterval] = [1, 6, 3, 4, 7, 10, 5]
    var sourceArr: [MovieInfo] = []
    var singleMovieInfo: MovieInfo?
    var isPrefetching = false
    private let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 15
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: createCollectionLayout())
        collection.register(FirstSectionCollectionViewCell.self, forCellWithReuseIdentifier: FirstSectionCollectionViewCell.identifier)
        collection.backgroundColor = .clear
        collection.prefetchDataSource = self
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
        setUpStartButton()
        setUpCollectionView()
    }
    
    func createCollectionLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { index, environment in
            return self.firstCollectionIndex()
        }
    }
    
    func firstCollectionIndex() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        group.interItemSpacing = .fixed(20)
        
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func setUpStartButton() {
        view.addSubview(startButton)
        startButton.addTarget(self, action: #selector(fetchData), for: .touchUpInside)
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(70)
        }
    }
    
    func setUpCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(100)
        }
    }
    
    @objc func fetchData() {
        print("Akes")
        NetworkManager.shared.fetchSingleMovie(limit: 20, topMeterTitlesType: .all) {[weak self] collection in
            
            self?.sourceArr = collection
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sourceArr.count == 0 ? 0 : sourceArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = FirstSectionCollectionViewCell.identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FirstSectionCollectionViewCell
        let currentElement = sourceArr[indexPath.row]
        cell.configureWithKF(title: currentElement.title, releaseYear: currentElement.releaseYear, imageURL: currentElement.imageUrl)
        return cell
    }
}

extension ViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let maxIndex = indexPaths.map({ $0.item }).max() else { return }
        print(maxIndex)
        if maxIndex >= sourceArr.count - 5 && !isPrefetching {
            print(maxIndex)
            print("Additional Log: \(maxIndex)")
            fetchNextPage()
        }
    }
    
    func fetchNextPage() {
        guard !isPrefetching else { return }
        isPrefetching = true
        NetworkManager.shared.fetchSingleMovie(limit: 10, topMeterTitlesType: .all) { [weak self] collection in
            self?.sourceArr.append(contentsOf: collection)
            
            DispatchQueue.main.async {
                self?.isPrefetching = false
                self?.collectionView.reloadData()
            }
        }
    }
}
