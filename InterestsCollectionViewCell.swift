//
//  InterestsCollectionViewCell.swift
//  MyDemos
//
//  Created by StoneNan on 2017/6/2.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit

class InterestsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    
    
    // MARK: - Public API
    var interest: Interest! {
        didSet {
            updateUI()
        }
    }
    
    fileprivate func updateUI() {
        titleLable.text = interest.title
        featuredImageView.image = interest.featuredImage
    }
    
    // MARK: - refactor layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
    }
}
