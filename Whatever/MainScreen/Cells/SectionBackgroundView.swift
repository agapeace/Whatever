import UIKit

final class SectionBackgroundView: UICollectionReusableView {
    
    static let identifier = "section-background-element"

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
