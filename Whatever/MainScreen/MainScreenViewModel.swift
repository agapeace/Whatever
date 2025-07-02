import UIKit
import Kingfisher

class MainScreenViewModel {
    
    var observableLiveFootballMatches: ObservableObject<[LiveEventsResponse]> = ObservableObject(resourceArr: [[]])
    
    ///Method for requesting data from the Network and updating the observable object
    func fetchLiveMatches() {
        NetworkManager2.shared.fetchLiveMatches { [weak self] collection in
            guard let finalResourceArr = self?.createLiveMatchResource(resourceArr: collection) else { return }
            self?.observableLiveFootballMatches.resourceArr = finalResourceArr
        }
    }
    ///Method for updating liveMatch's content
    func updateCurrentLiveMatch(match: LiveEventsResponse) -> LiveEventsResponse {
        var currentMatch = match
        currentMatch.startTimeText = convertTimestampAndCalculateYears(from: TimeInterval(currentMatch.startTimestamp), timeFormat: .hours).startTime
        currentMatch.currentPlayTimeText = calculateCurrentMinute(startTimeStamp: TimeInterval(currentMatch.startTimestamp), lastPeriod: currentMatch.lastPeriod)
        currentMatch.scoreStatus = calculateScoreStatus(homeScore: currentMatch.homeScore.current, awayScore: currentMatch.awayScore.current)
        return currentMatch
    }
    ///Method for returning URL + KingFisher Modifier
    func createKingfisherAttributes(id: Int, stringType: URLStringTypes) -> (URL, AnyModifier) {
        let modifier = NetworkManager2.shared.createRequest()
        guard let url = URL(string: stringType.rawValue + "\(id)") else {
            return (URL(string: stringType.rawValue + "1")!, modifier)
        }
        return (url, modifier)
    }
}


//MARK: - Private
private extension MainScreenViewModel {
    ///Method for creating nested DataSource
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
    
    ///Method for calculating playTime based on provided timeStamp
    func convertTimestampAndCalculateYears(from timestamp: TimeInterval, timeFormat: TimeFormat) -> (date: Date, startTime: String) {
        let date = Date(timeIntervalSince1970: timestamp)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = timeFormat.rawValue
        dateFormatter.timeZone = .current
        
        let hourString = dateFormatter.string(from: date)
        
        return (date, hourString)
    }
    
    ///Method for calculating currentMinute from the provided timeStamp and current time
    func calculateCurrentMinute(startTimeStamp: TimeInterval, lastPeriod: String?) -> String {
        let now = Date()

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        let currentTime = formatter.string(from: now)
        let start = convertTimestampAndCalculateYears(from: startTimeStamp, timeFormat: .hours)
        let value = minutesBetween(start.startTime, currentTime)

        guard let value else { return "45++" }

        if lastPeriod == nil, value > 45, value < 60 {
            return "HT"
        }
        
        if value <= 45 {
            return value <= 45 ? "\(value)'" : "45+"
        }
        
        if value > 60 && value < 130 {
            return value - 15 <= 90 ? "\(value - 15)'" : "90+"
        }

        return "FT"
    }
    
    ///Method for calculating difference between provided times in String format
    func minutesBetween(_ time1: String, _ time2: String) -> Int? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date1 = formatter.date(from: time1.replacingOccurrences(of: " ", with: "")),
              let date2 = formatter.date(from: time2.replacingOccurrences(of: " ", with: "")) else {
            return nil
        }

        let diff = Calendar.current.dateComponents([.minute], from: date1, to: date2)
        return diff.minute
    }
    ///Method for calculating Score Status
    func calculateScoreStatus(homeScore: Int, awayScore: Int) -> String {
        if homeScore > awayScore {
            return ScoreStatus.advantageHome.rawValue
        } else if awayScore > homeScore {
            return ScoreStatus.advantageAway.rawValue
        } else {
            return ScoreStatus.equal.rawValue
        }
    }
}

//MARK: - MatchesHeaderView Cell Logic

extension MainScreenViewModel {
    ///Method for converting provided alpha2 string code into UIIMage
    func flagEmojiImage(for countryCode: String, fontSize: CGFloat = 40) -> UIImage? {
        let base : UInt32 = 127397
        var emoji = ""
        for scalar in countryCode.uppercased().unicodeScalars {
            guard let scalarValue = UnicodeScalar(base + scalar.value) else { return nil }
            emoji.unicodeScalars.append(scalarValue)
        }

        let label = UILabel()
        label.text = emoji
        label.font = .systemFont(ofSize: fontSize)
        label.sizeToFit()

        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
