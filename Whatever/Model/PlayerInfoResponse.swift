
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
    let dateOfBirthTimestamp: Int?
    let contractUntilTimestamp: Int?
    let proposedMarketValue: Int?
}
