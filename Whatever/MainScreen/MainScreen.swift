import Foundation
import UIKit
import SnapKit

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
    
    private lazy var mainSearchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.delegate = self
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Type in m'lady", attributes: [.foregroundColor: #colorLiteral(red: 0.6099359989, green: 0.6172198057, blue: 0.6297825575, alpha: 1)])
        searchTextField.leftView?.subviews.first?.tintColor = #colorLiteral(red: 0.6099359989, green: 0.6172198057, blue: 0.6297825575, alpha: 1)
        searchTextField.textColor = .white
        if let leftView = searchTextField.leftView as? UIImageView {
            leftView.tintColor = #colorLiteral(red: 0.6099359989, green: 0.6172198057, blue: 0.6297825575, alpha: 1)
        }
        searchTextField.layer.cornerRadius = 15
        
        return searchTextField
    }()
    
    private let loaderView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.hidesWhenStopped = true
        loader.color = .white
        return loader
    }()
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setUpSearchTextField()
        setUpMatchesCollectionView()
        setUpLoaderView()
        fetchLiveMatches()
    }
    
    private func fetchLiveMatches() {
        loaderView.startAnimating()
        NetworkManager2.shared.fetchLiveMatches { [weak self] collection in
            self?.resourseArr = collection
            
            DispatchQueue.main.async {
                self?.loaderView.stopAnimating()
                self?.matchesCollectionView.reloadData()
            }
        }
    }
    
    private func setUpSearchTextField() {
        view.addSubview(mainSearchTextField)
        
        mainSearchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(70)
        }
        
        mainSearchTextField.addTarget(self, action: #selector(handleSearchTap), for: .editingDidBegin)
    }
    
    @objc private func handleSearchTap() {
        mainSearchTextField.resignFirstResponder()
        animateToSearch()
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
    
    private func createSliderSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    private func setUpMatchesCollectionView() {
        view.addSubview(matchesCollectionView)
        
        matchesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(mainSearchTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setUpLoaderView() {
        view.addSubview(loaderView)
        
        loaderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
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
            if !resourseArr.isEmpty {
                let currentSection = resourseArr[indexPath.section][0]
                headerView.configureElements(
                    tournamentId: currentSection.tournament.uniqueTournament?.id ?? currentSection.tournament.id,
                    name: currentSection.tournament.name,
                    country: currentSection.tournament.category.country?.alpha2 ?? "CA")
            }
            
            return headerView
        }
        
        return UICollectionReusableView()
    }
}

extension MainScreen: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
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
