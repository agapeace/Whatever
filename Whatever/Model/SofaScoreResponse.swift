
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
