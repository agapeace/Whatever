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
    private let headers = ["x-rapidapi-key": "67f240ff7fmsh64dfd6cca767880p138221jsnc8d70bdfaee9",
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
            r.setValue("67f240ff7fmsh64dfd6cca767880p138221jsnc8d70bdfaee9", forHTTPHeaderField: "x-rapidapi-key")
            r.setValue("sofascore.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
            return r
        }
        
        return modifier
    }
}


struct SofaScoreResponse: Decodable {
    let results: [ResultResponse]
}

struct ResultResponse: Decodable {
    let entity: EntityResponse
}

struct EntityResponse: Decodable {
    let id: Int
    let name: String
    let userCount: Int?
    let team: TeamResponse?
    let country: CountryResponse?
    let position: String?
    let jerseyNumber: String?
}

struct TeamResponse: Decodable {
    let id: Int
    let name: String
    let sport: SportResponse?
}

struct SportResponse: Decodable {
    let name: String
}

struct CountryResponse: Decodable {
    let name: String
}
