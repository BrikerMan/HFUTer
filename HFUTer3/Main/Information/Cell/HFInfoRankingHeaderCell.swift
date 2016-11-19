//
//  HFInfoRankingHeaderCell.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/8/23.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFInfoRankingHeaderCell: UITableViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(_ number:Int) {
        let normal      = [ NSFontAttributeName: UIFont.systemFont(ofSize: 15), NSForegroundColorAttributeName: ColorManager.shared.DarkTextColor ]
        let heightligh  = [ NSFontAttributeName: UIFont.systemFont(ofSize: 15), NSForegroundColorAttributeName: ColorManager.shared.TintColor ]
        

        
        // Create a blank attributed string
        let mutableAttrString = NSMutableAttributedString()
        
        mutableAttrString.append(NSAttributedString(string: "共 ", attributes: normal))
        mutableAttrString.append(NSAttributedString(string: "\(number) ", attributes: heightligh))
        mutableAttrString.append(NSAttributedString(string: " 人参与了排行，本排行结果仅供参考。", attributes: normal))
        
        headerLabel.attributedText = mutableAttrString
    }

}
