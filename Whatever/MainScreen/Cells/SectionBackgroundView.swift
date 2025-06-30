import UIKit

final class SectionBackgroundView: UICollectionReusableView {
    
    static let identifier = "section-background-element"

    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = #colorLiteral(red: 0.5647191405, green: 0.5684482455, blue: 0.5727850795, alpha: 1)
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
