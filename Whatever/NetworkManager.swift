//
//  NetworkManager.swift
//  Whatever
//
//  Created by Damir Agadilov  on 27.05.2025.
//

import UIKit

enum TopMeterTitlesType: String {
    case all = "ALL"
}

class NetworkManager {
    
    private let headers = ["x-rapidapi-key": "67f240ff7fmsh64dfd6cca767880p138221jsnc8d70bdfaee9",
                   "x-rapidapi-host": "imdb232.p.rapidapi.com"
    ]
    
    private init() {}
    
    static let shared = NetworkManager()
    
    
    func fetchMovies(limit: Int, topMeterTitlesType: TopMeterTitlesType, completionHandler: @escaping ([MovieInfo]) -> Void) {
        
        var urlComponents = URLComponents(string: "https://imdb232.p.rapidapi.com/api/title/get-most-popular")
        urlComponents?.queryItems = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "topMeterTitlesType", value: "ALL")
        ]
        
        guard let url = urlComponents?.url else { return }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let parsedData = try JSONDecoder().decode(FirstLayer.self, from: data)
                print(parsedData.data.topMeterTitles.edges.count)
                guard parsedData.data.topMeterTitles.edges.first != nil else { return }
                                
                var resultArr: [MovieInfo] = []
                parsedData.data.topMeterTitles.edges.forEach {
                    let element = MovieInfo(id: $0.node.id,
                                            title: $0.node.titleText.text,
                                            releaseYear: String($0.node.releaseYear.year),
                                            imageUrl: $0.node.primaryImage.url,
                                            image: nil)
                    resultArr.append(element)
                }
                
                Task {
                    let moviesWithImages = await self.fetchMoviesImagesAsync(arr: resultArr)
                    completionHandler(moviesWithImages)
                }
                
//               self.fetchMoviesImagesV2(arr: resultArr, completion: completionHandler)

                
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func fetchMoviesImages(arr: [MovieInfo], completion: @escaping ([MovieInfo]) -> Void) {
        
        var copy = arr
        let group = DispatchGroup()
        
        
        
        for i in 0..<copy.count {
            group.enter()
            
            guard let url = URL(string: copy[i].imageUrl) else {
                group.leave()
                continue
            }

            URLSession.shared.dataTask(with: url) { data, response, error in
                defer { group.leave() }
                
                if error != nil {
                    print("Error")
                    return
                }
                
                guard let data = data else { return }
                
                let image = UIImage(data: data)
                copy[i].image = image
                
            }.resume()
        }
        
        group.notify(queue: .main) {
            print("All images fetched")
            completion(copy)
        }
    }
    
    func fetchMoviesImagesAsync(arr: [MovieInfo]) async -> [MovieInfo] {
        await withTaskGroup(of: (Int, MovieInfo).self) { group in
            var updatedMovies = Array(repeating: MovieInfo(id: "", title: "", releaseYear: "", imageUrl: ""), count: arr.count)

            for (index, movie) in arr.enumerated() {
                group.addTask {
                    var updated = movie
                    if let url = URL(string: movie.imageUrl) {
                        do {
                            let (data, _) = try await URLSession.shared.data(from: url)
                            updated.image = UIImage(data: data)
                        } catch {
                            print("Failed to fetch image for \(movie.title): \(error)")
                        }
                    }
                    return (index, updated)
                }
            }

            for await (index, updatedMovie) in group {
                updatedMovies[index] = updatedMovie
            }

            return updatedMovies
        }
    }

    
    
    func fetchMoviesImagesV2(arr: [MovieInfo], completion: @escaping ([MovieInfo]) -> Void) {
        var updatedMovies = Array(repeating: MovieInfo(id: "", title: "", releaseYear: "", imageUrl: ""), count: arr.count)
        
        let queue = OperationQueue()
        let lock = NSLock()
        queue.maxConcurrentOperationCount = 5
        
//        let completionQueue = DispatchQueue(label: "completionQueue")
        let group = DispatchGroup()
        
        for (index, movie) in arr.enumerated() {
            group.enter()
            
            queue.addOperation {
                defer { group.leave() }
                var updated = movie
                if let url = URL(string: movie.imageUrl),
                   let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {

                    updated.image = image
                }
                
                lock.lock()
                updatedMovies[index] = updated
                lock.unlock()
                
            }
        }
        
        group.notify(queue: .main) {
            completion(updatedMovies)
        }
    }
    
    func fetchSingleMovie(limit: Int, topMeterTitlesType: TopMeterTitlesType, completion: @escaping ([MovieInfo]) -> Void) {
        
        var urlComponents = URLComponents(string: "https://imdb232.p.rapidapi.com/api/title/get-most-popular")
        urlComponents?.queryItems = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "topMeterTitlesType", value: topMeterTitlesType.rawValue)
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
                let parsedData = try JSONDecoder().decode(FirstLayer.self, from: data)
                var resultSourceArr: [MovieInfo] = []
                parsedData.data.topMeterTitles.edges.forEach { element in
                    let firstMovie = MovieInfo(id: element.node.id,
                                               title: element.node.titleText.text,
                                               releaseYear: String(element.node.releaseYear.year),
                                               imageUrl: element.node.primaryImage.url)
                    resultSourceArr.append(firstMovie)
                }
                completion(resultSourceArr)
            }catch {
                print(error)
            }
            
        }.resume()
    }
}


struct FirstLayer: Decodable {
    let data: SecondLayer
}

struct SecondLayer: Decodable {
    let topMeterTitles: ThirdLayer
}

struct ThirdLayer: Decodable {
    let edges: [FourthLayer]
}

struct FourthLayer: Decodable {
    let node: FifthLayer
}

struct FifthLayer: Decodable {
    let id: String
    let titleText: FifthLayerTitleText
    let releaseYear: FifthLayerReleaseYear
    let primaryImage: FifthLayerPrimaryImage
    
}

struct FifthLayerTitleText: Decodable {
    let text: String
}

struct FifthLayerReleaseYear: Decodable {
    let year: Int
}

struct FifthLayerPrimaryImage: Decodable {
    let url: String
}

struct MovieInfo {
    let id: String
    let title: String
    let releaseYear: String
    let imageUrl: String
    var image: UIImage?
}
