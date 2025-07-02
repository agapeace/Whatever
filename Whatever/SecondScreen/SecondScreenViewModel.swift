import Foundation
import UIKit
import Kingfisher

class SecondScreenViewModel {
    
    var observableObject: ObservableObject<ResultResponse> = ObservableObject(resourceArr: [])
    ///Fetching Set collection that is used to keep track of Players Id which prevents from fetching the same player concurrently
    private var fetchingSet = Set<PlayerFetchKey>()
    ///Lock that remporarily stops access to the same source
    private let resourceLock = NSLock()
    
    ///Method for fetching SearchTextField input information
    func fetchSearchTextFieldInput(item: String, type: SearchType, page: Int) {
        NetworkManager2.shared.searchBarRequest(item: item, type: type , page: page) { [weak self] collection in
            self?.observableObject.resourceArr = collection
        }
    }
    ///Method for generating URL + Modifier
    func createKingfisherAttributes(id: Int, stringType: URLStringTypes) -> (URL, AnyModifier) {
        let modifier = NetworkManager2.shared.createRequest()
        guard let url = URL(string: stringType.rawValue + "\(id)") else {
            return (URL(string: stringType.rawValue + "1")!, modifier)
        }
        return (url, modifier)
    }
    ///Method for prefetching mechanism
    func prefetchDetails(for indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let playerId = observableObject.resourceArr[indexPath.item].entity.id
            
            let fullInfoKey = PlayerFetchKey(playerId: playerId, type: .fullInfo)
            
            if observableObject.resourceArr[indexPath.item].entity.fullInfo == nil,
               !fetchingSet.contains(fullInfoKey) {
                
                fetchingSet.insert(fullInfoKey)
                fetchPlayerDetails(fullInfoKey: fullInfoKey, playerId: playerId, indexPath: indexPath)
            }
        }
    }
    ///Method for fetching Players details information
    func fetchPlayerDetails(fullInfoKey: PlayerFetchKey, playerId: Int, indexPath: IndexPath) {
        NetworkManager2.shared.fetchPlayerDetails(playerId: playerId) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.resourceLock.lock()
                defer {
                    self.resourceLock.unlock()
                    self.fetchingSet.remove(fullInfoKey)
                }
    
                guard self.observableObject.resourceArr.indices.contains(indexPath.item) else { return }
                var entity = self.observableObject.resourceArr[indexPath.item].entity
                entity.fullInfo = response
                self.observableObject.resourceArr[indexPath.item].entity = entity
                print("✅ Fetched full info for player id \(playerId)")
                
                
                self.fetchPlayerPosition(fullInfoKey: fullInfoKey, playerId: playerId, indexPath: indexPath)
            }
        }
    }
    ///Method for fetching Players positions
    func fetchPlayerPosition(fullInfoKey: PlayerFetchKey, playerId: Int, indexPath: IndexPath) {
        NetworkManager2.shared.fetchPlayerPositions(playerId: playerId) { positions in
            DispatchQueue.main.async {
                self.resourceLock.lock()
                defer {
                    self.resourceLock.unlock()
                    self.fetchingSet.remove(fullInfoKey)
                }
                                    
                guard self.observableObject.resourceArr.indices.contains(indexPath.item) else { return }
                var entity = self.observableObject.resourceArr[indexPath.item].entity
                entity.positions = positions
                self.observableObject.resourceArr[indexPath.item].entity = entity
                                    
                print("✅ Fetched positions player id \(playerId)")
            }
        }
    }
}
