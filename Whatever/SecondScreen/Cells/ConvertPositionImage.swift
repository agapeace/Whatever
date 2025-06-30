import Foundation
import UIKit

func coordinates(for position: String, in imageView: UIImageView) -> (CGPoint, UIColor) {
    let width = imageView.bounds.width
    let height = imageView.bounds.height

    switch position.uppercased() {
    case "GK": return (CGPoint( x: width / 2, y: height * 0.9), #colorLiteral(red: 0.8394894004, green: 0.651260972, blue: 0.2595276833, alpha: 1))
    case "DC": return (CGPoint(x: width / 2, y: height * 0.8), #colorLiteral(red: 0.2954768836, green: 0.615254879, blue: 0.9371739626, alpha: 1))
    case "DL": return (CGPoint(x: width * 0.2, y: height * 0.8), #colorLiteral(red: 0.2954768836, green: 0.615254879, blue: 0.9371739626, alpha: 1))
    case "DR": return (CGPoint(x: width * 0.8, y: height * 0.8), #colorLiteral(red: 0.2954768836, green: 0.615254879, blue: 0.9371739626, alpha: 1))
    case "DM": return (CGPoint(x: width / 2, y: height * 0.65), #colorLiteral(red: 0.1175416186, green: 0.7213883996, blue: 0.3636775911, alpha: 1))
    case "MC": return (CGPoint(x: width / 2, y: height * 0.5), #colorLiteral(red: 0.1175416186, green: 0.7213883996, blue: 0.3636775911, alpha: 1))
    case "MR": return (CGPoint(x: width * 0.80, y: height * 0.5), #colorLiteral(red: 0.1175416186, green: 0.7213883996, blue: 0.3636775911, alpha: 1))
    case "ML": return (CGPoint(x: width * 0.2, y: height * 0.5), #colorLiteral(red: 0.1175416186, green: 0.7213883996, blue: 0.3636775911, alpha: 1))
    case "AM": return (CGPoint(x: width / 2, y: height * 0.35), #colorLiteral(red: 0.1175416186, green: 0.7213883996, blue: 0.3636775911, alpha: 1))
    case "LW": return (CGPoint(x: width * 0.2, y: height * 0.2), #colorLiteral(red: 0.9044718742, green: 0.2315939069, blue: 0.2334573567, alpha: 1))
    case "RW": return (CGPoint(x: width * 0.80, y: height * 0.2), #colorLiteral(red: 0.9044718742, green: 0.2315939069, blue: 0.2334573567, alpha: 1))
    case "ST": return (CGPoint(x: width / 2, y: height * 0.1), #colorLiteral(red: 0.9044718742, green: 0.2315939069, blue: 0.2334573567, alpha: 1))
    default: return (CGPoint(x: width / 2, y: height / 2), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))
    }
}
