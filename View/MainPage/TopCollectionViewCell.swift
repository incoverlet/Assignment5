import UIKit
import SnapKit

class TopCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: TopCollectionViewCell.self)
    
    let topImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TopCollectionViewCell {
    
    func setupImageView() {
        
        let shadowView: UIImageView = {
            let view = UIImageView()
            view.backgroundColor = .white
            view.layer.cornerRadius = 10
            view.layer.masksToBounds = false
            
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOffset = CGSize(width: 3, height: 3)
            view.layer.shadowOpacity = 0.1
            view.layer.shadowRadius = 4
            return view
        }()
        
        // Add shadowView to contentView first
        contentView.addSubview(shadowView)
        
        shadowView.snp.makeConstraints { make in
            make.width.equalTo(123)
            make.height.equalTo(182)
            make.center.equalToSuperview() // or set specific position
        }
        
        // Configure and add topImageView to shadowView
        topImageView.backgroundColor = .myOrange
        topImageView.layer.cornerRadius = 10
        topImageView.layer.masksToBounds = true
        
        shadowView.addSubview(topImageView)
        
        topImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
