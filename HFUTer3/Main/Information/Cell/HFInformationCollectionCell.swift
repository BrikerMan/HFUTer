//
//  HFInformationCollectionCell.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/24.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

struct HFInformationFonctionListModel {
    var title: String
    var image: String
    var segue: String
    
    init(_ title: String, _ image: String, _ segue: String) {
        self.title = title
        self.image = image
        self.segue = segue
    }
    
}

class HFInformationCollectionCell: UICollectionViewCell {
    
    static let identifier = "infoFonctionsCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setupWithModel(_ model: HFInformationFonctionListModel) {
        titleLabel.text = model.title
        imageView.image = UIImage(named: model.image)
    }
}
