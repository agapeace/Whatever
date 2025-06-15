//
//  SecondScreen.swift
//  Whatever
//
//  Created by Damir Agadilov  on 09.06.2025.
//

import UIKit

class SecondScreen: UIViewController {
    
    private lazy var searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.placeholder = "Type in m'facka"
        searchTextField.delegate = self
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Type in m'facka", attributes: [.foregroundColor: #colorLiteral(red: 0.6099359989, green: 0.6172198057, blue: 0.6297825575, alpha: 1)])
        searchTextField.leftView?.subviews.first?.tintColor = #colorLiteral(red: 0.6099359989, green: 0.6172198057, blue: 0.6297825575, alpha: 1)
        searchTextField.textColor = .white
        if let leftView = searchTextField.leftView as? UIImageView {
            leftView.tintColor = #colorLiteral(red: 0.6099359989, green: 0.6172198057, blue: 0.6297825575, alpha: 1)
        }
        return searchTextField
    }()
    
    private lazy var personCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collection.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        return collection
    }()
    
    private var resourceArr: [ResultResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        setUpSearchTextField()
        setUpPersonCollectionView()
    }
    
    func setUpSearchTextField() {
        view.addSubview(searchTextField)
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            make.leading.trailing.equalToSuperview().inset(5)
            make.height.equalTo(60)
        }
    }
    
    func setUpPersonCollectionView() {
        view.addSubview(personCollectionView)
        
        personCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(5)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
    }
    
    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            return self.setUpFirstSectionIndex()
        }
    }
    
    func setUpFirstSectionIndex() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let imageItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [imageItem])
        group.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
}


extension SecondScreen: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        NetworkManager2.shared.searchBarRequest(item: text, type: .all, page: 0) {[weak self] response in
            self?.resourceArr = response
            
            DispatchQueue.main.async {
                self?.personCollectionView.reloadData()
            }
        }
        return textField.resignFirstResponder()
    }
}

extension SecondScreen: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resourceArr.count == 0 ? 0 : resourceArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = ImageCollectionViewCell.identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCollectionViewCell
        
        if resourceArr.count > 0 {
            let currentElement = resourceArr[indexPath.row].entity
            cell.configureElements(playerId: currentElement.id, playerName: currentElement.name, clubId: currentElement.team?.id ?? 241802, clubName: currentElement.team?.name ?? "No club")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PlayerInfoViewController(player: resourceArr[indexPath.row].entity)
//        let vc = PlayerInfoViewController(playerId: 750, playerName: "Cristiano Ronaldo")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
