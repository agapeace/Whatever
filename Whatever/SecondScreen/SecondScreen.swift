import UIKit

enum PlayerFetchType: Hashable {
    case fullInfo
    case positions
}

struct PlayerFetchKey: Hashable {
    let playerId: Int
    let type: PlayerFetchType
}

class SecondScreen: UIViewController {
    
    private lazy var searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.delegate = self
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Type in m'lady", attributes: [.foregroundColor: #colorLiteral(red: 0.6099359989, green: 0.6172198057, blue: 0.6297825575, alpha: 1)])
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
        collection.prefetchDataSource = self
        return collection
    }()
    
    private let loaderView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.color = .white
        loader.hidesWhenStopped = true
        return loader
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        return button
    }()
    
    private var resourceArr: [ResultResponse] = []
    private var fetchingSet = Set<PlayerFetchKey>()
    private let resourceLock = NSLock()
    private var cancelledPrefetchSet = Set<PlayerFetchKey>()
    var shouldBecomeFirstResponder: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        setUpSearchTextField()
        setUpCancelButton()
        setUpPersonCollectionView()
        setUpLoaderView()
    }
    
    func setUpSearchTextField() {
        view.addSubview(searchTextField)
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(80)
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
    
    func setUpLoaderView() {
        view.addSubview(loaderView)
        
        loaderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
    }
    
    private func setUpCancelButton() {
        view.addSubview(cancelButton)
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(searchTextField.snp.trailing).offset(5)
            make.trailing.equalToSuperview().inset(5)
            make.height.equalTo(60)
        }
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    @objc func cancelButtonTapped() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldBecomeFirstResponder {
            searchTextField.becomeFirstResponder()
            shouldBecomeFirstResponder = false
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
        loaderView.startAnimating()
        NetworkManager2.shared.searchBarRequest(item: text, type: .all, page: 0) { response in
            DispatchQueue.main.async {
                self.resourceLock.lock()
                self.resourceArr = response
                self.resourceLock.unlock()
                self.loaderView.stopAnimating()
                self.personCollectionView.reloadData()
                
                print("Presumably prefetching visible values")
                self.personCollectionView.performBatchUpdates(nil) { _ in
                    let visibleIndexPaths = self.personCollectionView.indexPathsForVisibleItems
                    print(visibleIndexPaths.count)
                    print(visibleIndexPaths)
                    self.collectionView(self.personCollectionView, prefetchItemsAt: visibleIndexPaths)
                }
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

extension SecondScreen: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let playerId = resourceArr[indexPath.item].entity.id
            
            let fullInfoKey = PlayerFetchKey(playerId: playerId, type: .fullInfo)
            let positionsKey = PlayerFetchKey(playerId: playerId, type: .positions)
            
            if resourceArr[indexPath.item].entity.fullInfo == nil,
               !fetchingSet.contains(fullInfoKey) {
                
                fetchingSet.insert(fullInfoKey)
                
                NetworkManager2.shared.fetchPlayerDetails(playerId: playerId) { [weak self] response in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.resourceLock.lock()
                        defer {
                            self.resourceLock.unlock()
                            self.fetchingSet.remove(fullInfoKey)
                        }
            
                        guard self.resourceArr.indices.contains(indexPath.item) else { return }
                        var entity = self.resourceArr[indexPath.item].entity
                        entity.fullInfo = response
                        self.resourceArr[indexPath.item].entity = entity
                        print("✅ Fetched full info for player id \(playerId)")
                        
                        NetworkManager2.shared.fetchPlayerPositions(playerId: playerId) { positions in
                            DispatchQueue.main.async {
                                self.resourceLock.lock()
                                defer {
                                    self.resourceLock.unlock()
                                    self.fetchingSet.remove(fullInfoKey)
                                }
                                                    
                                guard self.resourceArr.indices.contains(indexPath.item) else { return }
                                var entity = self.resourceArr[indexPath.item].entity
                                entity.positions = positions
                                self.resourceArr[indexPath.item].entity = entity
                                                    
                                print("✅ Fetched positions player id \(playerId)")
                                print(entity)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard resourceArr.indices.contains(indexPath.item) else { continue }
            let playerId = resourceArr[indexPath.item].entity.id

            cancelledPrefetchSet.insert(PlayerFetchKey(playerId: playerId, type: .fullInfo))
            cancelledPrefetchSet.insert(PlayerFetchKey(playerId: playerId, type: .positions))
        }
    }
}
