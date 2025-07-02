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
    ///SearchTextfield that is connected to the API and returns football players information
    private lazy var searchTextField = UISearchTextField()
    ///PersonCollectionView that shows fetched data from the SearchTextField
    private lazy var personCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    ///Loader that activites during fetching process
    private let loaderView = UIActivityIndicatorView(style: .large)
    ///Canceling button that allows to go back to Parent View (MainScreen)
    private let cancelButton = UIButton()
    ///Resource arr for containing fetched information
    private var resourceArr: [ResultResponse] = []
    ///Cancelled Prefetch Set
    private var cancelledPrefetchSet = Set<PlayerFetchKey>()
    ///Bool variable that speciefies whether or not searchTextField should become first Responder
    var shouldBecomeFirstResponder: Bool = true
    ///Instance of ViewModel class
    private let viewModel = SecondScreenViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        setUpBinders()
        setUpSearchTextField()
        setUpCancelButton()
        setUpPersonCollectionView()
        setUpLoaderView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        makeSearchTextFieldFirstResponder(isFirstResponder: shouldBecomeFirstResponder)
    }
}

//MARK: - Setting Up Binders

private extension SecondScreen {
    ///Method for setting binders
    func setUpBinders() {
        viewModel.observableObject.binder { collection in
            DispatchQueue.main.async {
                self.resourceArr = collection
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
    }
}

//MARK: - Handling User Actions

private extension SecondScreen {
    ///Method for whether or not becoming the searchtextFIeld first responder
    func makeSearchTextFieldFirstResponder(isFirstResponder: Bool) {
        if isFirstResponder {
            searchTextField.becomeFirstResponder()
            shouldBecomeFirstResponder = false
        }
    }
    
    @objc func cancelButtonTapped() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}

//MARK: - UITextFieldDelegate

extension SecondScreen: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        loaderView.startAnimating()
        viewModel.fetchSearchTextFieldInput(item: text, type: .all, page: 0)
        return textField.resignFirstResponder()
    }
}

//MARK: - UICollectionViewDataSource

extension SecondScreen: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resourceArr.count == 0 ? 0 : resourceArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = ImageCollectionViewCell.identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCollectionViewCell
        
        let currentElement = resourceArr[indexPath.row].entity
        cell.configureElements(entity: currentElement)
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension SecondScreen: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PlayerInfoViewController(player: resourceArr[indexPath.row].entity)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UICollectionView Prefetching

extension SecondScreen: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        viewModel.prefetchDetails(for: indexPaths)
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

//MARK: - UI Elements SetUp

private extension SecondScreen {
    ///Method for setting up SearchTextField
    func setUpSearchTextField() {
        view.addSubview(searchTextField)
        searchTextField.delegate = self
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Type in m'lady", attributes: [.foregroundColor: #colorLiteral(red: 0.6099359989, green: 0.6172198057, blue: 0.6297825575, alpha: 1)])
        searchTextField.leftView?.subviews.first?.tintColor = #colorLiteral(red: 0.6099359989, green: 0.6172198057, blue: 0.6297825575, alpha: 1)
        searchTextField.textColor = .white
        if let leftView = searchTextField.leftView as? UIImageView {
            leftView.tintColor = #colorLiteral(red: 0.6099359989, green: 0.6172198057, blue: 0.6297825575, alpha: 1)
        }
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(80)
            make.height.equalTo(60)
        }
    }
    ///Method for setting up PersonCollectionView
    func setUpPersonCollectionView() {
        view.addSubview(personCollectionView)
        personCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        personCollectionView.delegate = self
        personCollectionView.dataSource = self
        personCollectionView.backgroundColor = .clear
        personCollectionView.prefetchDataSource = self
        personCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(5)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
    }
    ///Method for setting up LoaderView
    func setUpLoaderView() {
        view.addSubview(loaderView)
        loaderView.color = .white
        loaderView.hidesWhenStopped = true
        loaderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
    }
    ///Method for setting up Cancel Button
    func setUpCancelButton() {
        view.addSubview(cancelButton)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(searchTextField.snp.trailing).offset(5)
            make.trailing.equalToSuperview().inset(5)
            make.height.equalTo(60)
        }
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
}

//MARK: - SearchCollectionView CompositionalLayout & Layout Section SetUp

private extension SecondScreen {
    ///Method for creating compositionalLayout
    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            return self.setUpFirstSectionIndex()
        }
    }
    ///Method for creating Layout Section
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
