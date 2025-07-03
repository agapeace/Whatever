import UIKit
import Kingfisher

enum SearchType: String {
    case all = "all"
}

enum URLStringTypes: String {
    case teamsLogo = "https://sofascore.p.rapidapi.com/teams/get-logo?teamId="
    case tournamentLogo = "https://sofascore.p.rapidapi.com/tournaments/get-logo?tournamentId="
    case playerImage = "https://sofascore.p.rapidapi.com/players/get-image?playerId="
}

class NetworkManager2 {
    
    private init() {}
    private let headers = ["x-rapidapi-key": "///",
                           "x-rapidapi-host": "sofascore.p.rapidapi.com"]
    static let shared = NetworkManager2()
    
    func searchBarRequest(item: String, type: SearchType, page: Int, completion: @escaping ([ResultResponse]) -> Void) {
        var urlComponents = URLComponents(string: "https://sofascore.p.rapidapi.com/search")
        urlComponents?.queryItems = [
            URLQueryItem(name: "q", value: item),
            URLQueryItem(name: "type", value: type.rawValue),
            URLQueryItem(name: "page", value: String(page))
        ]
        
        guard let url = urlComponents?.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let parsedData = try JSONDecoder().decode(SofaScoreResponse.self, from: data)
                
                let resultArr: [ResultResponse] = parsedData.results.filter {
                    $0.entity.team?.sport?.name == "Football"
                }
                
                completion(resultArr)
                
            }catch {
                print(error)
            }
        }.resume()
    }
    
    func createRequest() -> AnyModifier {
        let modifier = AnyModifier { request in
            var r = request
            r.setValue("b4159b0e50msha04006c7d789f6ap1aa693jsn091e0d919c12", forHTTPHeaderField: "x-rapidapi-key")
            r.setValue("sofascore.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
            return r
        }
        
        return modifier
    }
    
    func fetchPlayerDetails(playerId: Int, completion: @escaping (PlayerResponse) -> Void) {
        
        var urlComponents = URLComponents(string: "https://sofascore.p.rapidapi.com/players/detail")
        urlComponents?.queryItems = [
            URLQueryItem(name: "playerId", value: String(playerId))
        ]
        
        guard let url = urlComponents?.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let parsedData = try JSONDecoder().decode(PlayerInfoResponse.self, from: data)
                completion(parsedData.player)
                
            }catch {
                print(error)
            }
        }.resume()
    }
    
    func fetchPlayerPositions(playerId: Int, completion: @escaping ([String]) -> Void) {
    
        var urlComponents = URLComponents(string: "https://sofascore.p.rapidapi.com/players/get-characteristics")
        urlComponents?.queryItems = [
            URLQueryItem(name: "playerId", value: String(playerId))
        ]
        
        guard let url = urlComponents?.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let parsedData = try JSONDecoder().decode(PlayerPositionResponse.self, from: data)
                completion(parsedData.positions ?? [])
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func fetchLiveMatches(completion: @escaping ([LiveEventsResponse]) ->  Void) {
        
        let urlComponents = URLComponents(string: "https://sofascore.p.rapidapi.com/tournaments/get-live-events?sport=football")
        guard let url = urlComponents?.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print(error)
            }
            
            guard let data = data else { return }
            
            do {
                let parsedData = try JSONDecoder().decode(LiveMatchesResponse.self, from: data)
                completion(parsedData.events)
                
            } catch {
                print(error)
            }
            
        }.resume()
    }
}
