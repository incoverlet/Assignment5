//
//  BottomCollectionViewCell.swift
//  BookSearching
//
//  Created by 이유진 on 5/2/24.
//

import UIKit
import SnapKit

class BottomCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: BottomCollectionViewCell.self)
    
    let bottomImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension BottomCollectionViewCell {
    func setupCellUI() {
        self.backgroundColor = .myOrange
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = false
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 4
    }
}