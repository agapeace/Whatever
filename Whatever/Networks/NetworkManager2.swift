//
//  NetworkManager2.swift
//  Whatever
//
//  Created by Damir Agadilov  on 09.06.2025.
//

import UIKit
import Kingfisher

enum SearchType: String {
    case all = "all"
}

class NetworkManager2 {
    
    private init() {}
    private let headers = ["x-rapidapi-key": "5fcfe43b1dmshfdd3b392a75d3b4p13091fjsn6c63b490e455",
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
            r.setValue("5fcfe43b1dmshfdd3b392a75d3b4p13091fjsn6c63b490e455", forHTTPHeaderField: "x-rapidapi-key")
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
    
    func fetchLiveMatches(completion: @escaping ([[LiveEventsResponse]]) ->  Void) {
        
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
                let sortedAnswer = self.createLiveMatchResource(resourceArr: parsedData.events)
                print("Aleeeeee")
                print(sortedAnswer.count)
                completion(sortedAnswer)
            } catch {
                print(error)
            }
            
        }.resume()
    }
    
    func createLiveMatchResource(resourceArr: [LiveEventsResponse]) -> [[LiveEventsResponse]] {
        
        let grouped = Dictionary(grouping: resourceArr) { $0.tournament.id }
        var keysSet = Set<Int>()
        
        var resultArr: [[LiveEventsResponse]] = []
        resourceArr.forEach {
            if !keysSet.contains($0.tournament.id) {
                resultArr.append(grouped[$0.tournament.id] ?? [])
                keysSet.insert($0.tournament.id)
            }
        }
            
        return resultArr
    }
    
}


//MARK: - Search Struct
struct SofaScoreResponse: Decodable {
    let results: [ResultResponse]
}

struct ResultResponse: Decodable {
    var entity: EntityResponse
}

struct EntityResponse: Decodable {
    let id: Int
    let name: String
    let userCount: Int?
    let team: TeamResponse?
    let country: CountryResponse?
    let position: String?
    let jerseyNumber: String?
    var fullInfo: PlayerResponse?
    var positions: [String]?
}

struct TeamResponse: Decodable {
    let id: Int
    let name: String
    let sport: SportResponse?
    let teamColors: TeamColors?
}

struct SportResponse: Decodable {
    let name: String
}

struct CountryResponse: Decodable {
    let alpha2: String?
    let name: String?
}

struct TeamColors: Decodable {
    let primary: String
}

//MARK: - Player Details Struct
struct PlayerInfoResponse: Decodable {
    let player: PlayerResponse
}

struct PlayerResponse: Decodable {
    let shortName: String
    let position: String
    let jerseyNumber: String?
    let height: Int
    let preferredFoot: String
    let dateOfBirthTimestamp: Int
    let contractUntilTimestamp: Int?
    let proposedMarketValue: Int?
}

//MARK: - Players Positions Struct
struct PlayerPositionResponse: Decodable {
    let positions: [String]?
}


struct FinalPlayer {
    let player: PlayerResponse
    let playerInfo: PlayerInfoResponse
    let positions: [String]
}


//MARK: - Live matches

struct LiveMatchesResponse: Decodable {
    let events: [LiveEventsResponse]
}

struct LiveEventsResponse: Decodable {
    let tournament: TournamentResponse
    let status: StatusResponse
    let homeTeam: HomeTeamResponse
    let awayTeam: AwayTeamResponse
    let homeScore: HomeScoreResponse
    let awayScore: AwayScoreResponse
    let time: TimeResponse
    let changes: ChangesResponse
    let startTimestamp: Int
    let lastPeriod: String?
}

struct TournamentResponse: Decodable {
    let name: String
    let id: Int
    let category: CategoryResponse
    let uniqueTournament: UniqueTournamentResponse?
    
}

struct CategoryResponse: Decodable {
    let country: CountryResponse?
}

struct UniqueTournamentResponse: Decodable {
    let name: String
    let id: Int
}

struct StatusResponse: Decodable {
    let code: Int
    let description: String
    let type: String
}

struct HomeTeamResponse: Decodable {
    let name: String
    let id: Int
    let teamColors: TeamColors
}

struct AwayTeamResponse: Decodable {
    let name: String
    let id: Int
    let teamColors: TeamColors
}

struct HomeScoreResponse: Decodable {
    let current: Int
    let display: Int
    let period1: Int?
}

struct AwayScoreResponse: Decodable {
    let current: Int
    let display: Int
    let period1: Int?
}

struct TimeResponse: Decodable {
    let periodLength: Int?
    let overtimeLength: Int?
    let totalPeriodCount: Int?
    let max: Int?
    let extra: Int?
    let currentPeriodStartTimestamp: Int?
}

struct ChangesResponse: Decodable {
    let changeTimeStamp: Int?
}

enum TimeFormat: String {
    case hours = "HH:mm"
    case minutes = "mm"
}


