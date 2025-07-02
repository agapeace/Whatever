import UIKit

class PlayerInfoViewController: UIViewController {
    
    
    private var player: EntityResponse
    private var playerInfo: PlayerResponse?
    
    init(player: EntityResponse) {
        self.player = player
        super.init(nibName: nil, bundle: nil)
    }

    private lazy var playerCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        setUpNavigationBar()
        setUpCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI Elements SetUp
private extension PlayerInfoViewController {
    ///Method for setting up CollectionView
    func setUpCollectionView() {
        view.addSubview(playerCollectionView)
        playerCollectionView.register(PlayerInfoCollectionViewCell.self, forCellWithReuseIdentifier: PlayerInfoCollectionViewCell.identifier)
        playerCollectionView.register(PlayerInfo2CollectionViewCell.self, forCellWithReuseIdentifier: PlayerInfo2CollectionViewCell.identifier)
        playerCollectionView.register(PlayerPositionCollectionViewCell.self, forCellWithReuseIdentifier: PlayerPositionCollectionViewCell.identifier)
        playerCollectionView.dataSource = self
        playerCollectionView.backgroundColor = .clear
        playerCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
    }
    ///Method for setting NavigationBar
    func setUpNavigationBar() {
        navigationItem.title = "Player Info"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(goBackButton))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    ///Method for navigating back to previous screen
    @objc func goBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - CollectionView CompositionalLayout Creation

private extension PlayerInfoViewController {
    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout{
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch sectionIndex {
            case 0:
                return self.createFirstSection()
            case 1:
                return self.createSecondSection()
            default:
                return self.createThirdSection()
            }
        }
    }
}

//MARK: - CollectionView LayoutSection Creation
private extension PlayerInfoViewController {
    ///Method for creating first Section
    func createFirstSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 0)
        return section
    }
    ///Method for creating second Section
    func createSecondSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: player.fullInfo?.proposedMarketValue == nil ? .absolute(250) : .absolute(400))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    ///Method for creating Third Section
    func createThirdSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(320))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 0)
        return section
    }
}

//MARK: UICollectionViewDataSource
extension PlayerInfoViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let positions = player.positions else { return 2 }
        return positions == [] ? 2 : 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cellId = PlayerInfoCollectionViewCell.identifier
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PlayerInfoCollectionViewCell
            cell.configureElements(playerId: player.id,
                                   playerName: player.name,
                                   firstColor: UIColor(hex: player.team?.teamColors?.primary ?? "272C32"))
            
            return cell
        case 1:
            let cellId = PlayerInfo2CollectionViewCell.identifier
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PlayerInfo2CollectionViewCell
            
            if let available = player.fullInfo {
                cell.configureElements(playerInfo: available, player: player)
            }
            return cell
        default:
            let cellId = PlayerPositionCollectionViewCell.identifier
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PlayerPositionCollectionViewCell
            if let positions = player.positions {
                print(positions)
                cell.configurePositions(positions: positions)
            }
            return cell
        }
    }
}
