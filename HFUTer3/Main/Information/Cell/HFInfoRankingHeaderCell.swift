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
        let normal      = [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15), NSAttributedStringKey.foregroundColor: ColorManager.shared.DarkTextColor ]
        let heightligh: [NSAttributedStringKey : Any]  = [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15), NSAttributedStringKey.foregroundColor: ColorManager.shared.TintColor ]
        
        
        
        // Create a blank attributed string
        let mutableAttrString = NSMutableAttributedString()
        
        mutableAttrString.append(NSAttributedString(string: "共 ", attributes: normal))
        mutableAttrString.append(NSAttributedString(string: "\(number) ", attributes: heightligh))
        mutableAttrString.append(NSAttributedString(string: " 人参与了排行，本排行结果仅供参考。\n",
                                                    attributes: normal))
        mutableAttrString.append(NSAttributedString(string: "本功能处于测试阶段，不保证准确性。如果需要准确结果，请使用图书馆的机器查询。",
                                                    attributes: heightligh))
        headerLabel.attributedText = mutableAttrString
    }
    
}
