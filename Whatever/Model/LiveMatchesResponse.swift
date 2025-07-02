import Foundation

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
    var startTimeText: String?
    var currentPlayTimeText: String?
    var scoreStatus: String?
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

enum ScoreStatus: String {
    case advantageHome = "home"
    case advantageAway = "away"
    case equal = "equal"
}
