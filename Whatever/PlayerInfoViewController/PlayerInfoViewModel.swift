import UIKit
import Kingfisher

class PlayerInfoViewModel {
    
    ///Method for creating URL + KingfisherAttribute
    func createKingFisherAttribute(id: Int, stringType: URLStringTypes) -> (URL, AnyModifier) {
        let modifier = NetworkManager2.shared.createRequest()
        guard let url = URL(string: stringType.rawValue + "\(id)") else {
            return (URL(string: stringType.rawValue + "1")!, modifier)
        }
        return (url, modifier)
    }
    
    ///Method for returning country Text from alpha2 code
    func flagEmoji(for countryCode: String) -> String {
        let base: UInt32 = 127397
        var emoji = ""
        countryCode.uppercased().unicodeScalars.forEach {
            if let scalar = UnicodeScalar(base + $0.value) {
                emoji.unicodeScalars.append(scalar)
            }
        }
        return emoji
    }
    
    ///Method for converting timeStamp into fullDate and years
    func convertTimestampAndCalculateYears(from timestamp: TimeInterval) -> (date: Date, fullYears: Int) {
        let date = Date(timeIntervalSince1970: timestamp)
        
        let calendar = Calendar.current
        let now = Date()
        
        let components = calendar.dateComponents([.year], from: date, to: now)
        let fullYears = components.year ?? 0
        
        return (date, fullYears)
    }
    
    ///Method for formating date into String
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
    
    ///Method for calculating market value from provided Int value
    func formatMarketValue(_ value: Int) -> String {
        let million = 1_000_000
        let thousand = 1_000
        
        if value >= million {
            let formatted = Double(value) / Double(million)
            return String(format: formatted >= 10 ? "%.0fM" : "%.1fM", formatted) + " €"
        } else if value >= thousand {
            let formatted = Double(value) / Double(thousand)
            return String(format: formatted >= 10 ? "%.0fK" : "%.1fK", formatted) + " €"
        } else {
            return "\(value) €"
        }
    }
    
}
