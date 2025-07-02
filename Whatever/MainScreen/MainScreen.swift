import Foundation
import UIKit
import SnapKit

class MainScreen: UIViewController {
    
    ///ResourceArr that contains all the fetched match live information
    private var resourceArr: [[LiveEventsResponse]] = []
    ///MatchesCollectionView that is used to show the data from resourceArr
    private lazy var matchesCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createCompositionalLayout())
    ///SearchTextField for searching players
    private let mainSearchTextField = UISearchTextField()
    ///LoaderView that loads while data is being fetched
    private let loaderView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    ///ViewModel instance
    private let viewModel = MainScreenViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setUpBinders()
        setUpSearchTextField()
        setUpMatchesCollectionView()
        setUpLoaderView()
//        fetchLiveMatches()
    }
}

//MARK: -Binders SetUp

extension MainScreen {
    func setUpBinders() {
        viewModel.observableLiveFootballMatches.binder { [weak self] collection in
            self?.resourceArr = collection
            
            DispatchQueue.main.async {
                self?.loaderView.stopAnimating()
                self?.matchesCollectionView.reloadData()
            }
        }
    }
}

//MARK: - UICollectionViewDatasource

extension MainScreen: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return resourceArr.isEmpty ? 0 : resourceArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resourceArr.isEmpty ? 0 : resourceArr[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = MatchesCollectionViewCell.identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MatchesCollectionViewCell
        if !resourceArr.isEmpty {
            let updatedCurrenMatch = viewModel.updateCurrentLiveMatch(match: resourceArr[indexPath.section][indexPath.item])
            cell.configureElements(club: updatedCurrenMatch)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerId = MatchHeaderCollectionReusableView.identifier
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! MatchHeaderCollectionReusableView
            if !resourceArr.isEmpty {
                let currentSection = resourceArr[indexPath.section][0]
                headerView.configureElements(
                    tournamentId: currentSection.tournament.uniqueTournament?.id ?? currentSection.tournament.id,
                    name: currentSection.tournament.name,
                    country: currentSection.tournament.category.country?.alpha2 ?? "XW")
            }
            
            return headerView
        }
        
        return UICollectionReusableView()
    }
}

//MARK: - UISearchField's Methods

extension MainScreen {
    ///Method for handling user tap on searchField
    @objc private func handleSearchTap() {
        mainSearchTextField.resignFirstResponder()
        animateToSearch()
    }
    ///Method for animating to childView
    func animateToSearch() {
        let searchVC = SecondScreen()
        searchVC.shouldBecomeFirstResponder = true
        addChild(searchVC)
        view.addSubview(searchVC.view)
        
        searchVC.view.frame = view.bounds.offsetBy(dx: 0, dy: view.bounds.height)
        searchVC.didMove(toParent: self)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut]) {
            searchVC.view.frame = self.view.bounds
        }
    }
}

//MARK: - UI Elements SetUp

private extension MainScreen {
    /// SearchTextField set up method
    func setUpSearchTextField() {
        view.addSubview(mainSearchTextField)
        mainSearchTextField.attributedPlaceholder = NSAttributedString(string: "Type in m'lady", attributes: [.foregroundColor: #colorLiteral(red: 0.6099359989, green: 0.6172198057, blue: 0.6297825575, alpha: 1)])
        mainSearchTextField.leftView?.subviews.first?.tintColor = #colorLiteral(red: 0.6099359989, green: 0.6172198057, blue: 0.6297825575, alpha: 1)
        mainSearchTextField.textColor = .white
        if let leftView = mainSearchTextField.leftView as? UIImageView {
            leftView.tintColor = #colorLiteral(red: 0.6099359989, green: 0.6172198057, blue: 0.6297825575, alpha: 1)
        }
        mainSearchTextField.layer.cornerRadius = 15
        mainSearchTextField.addTarget(self, action: #selector(handleSearchTap), for: .editingDidBegin)
        
        mainSearchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(70)
        }
    }
    /// MatchesCollectionView set up method
    func setUpMatchesCollectionView() {
        view.addSubview(matchesCollectionView)
        matchesCollectionView.register(MatchesCollectionViewCell.self, forCellWithReuseIdentifier: MatchesCollectionViewCell.identifier)
        matchesCollectionView.register(MatchHeaderCollectionReusableView.self,
                                       forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                       withReuseIdentifier: MatchHeaderCollectionReusableView.identifier)
        matchesCollectionView.dataSource = self
        matchesCollectionView.backgroundColor = .clear
        
        matchesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(mainSearchTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    ///LoaderView set up method
    func setUpLoaderView() {
        view.addSubview(loaderView)
        loaderView.hidesWhenStopped = true
        loaderView.color = .white
        loaderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
    }
    
    ///Method for fetching data from the Internet
    func fetchLiveMatches() {
        loaderView.startAnimating()
        viewModel.fetchLiveMatches()
    }
}

//MARK: - UICollectionView CompositionalLayout & CollectionSection creation

private extension MainScreen {
    /// Method for creating CompositionalLayout
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            return self.createCollectionSection()
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        layout.register(SectionBackgroundView.self, forDecorationViewOfKind: SectionBackgroundView.identifier)
        return layout
    }
    
    /// Method for creating collection section
    private func createCollectionSection() -> NSCollectionLayoutSection {
        
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
}
