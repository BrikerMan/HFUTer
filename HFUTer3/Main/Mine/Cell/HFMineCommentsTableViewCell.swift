//
//  HFMineCommentsTableViewCell.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/6/21.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFMineCommentsTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var originalConfessLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func blind(model: HFMineCommentModel) {
        titleLabel.text = model.content
        
        if let original = model.confession {
            let attText = NSMutableAttributedString()
            
            let name = original.name.isBlank ? "匿名" : original.name
            attText.append(NSMutableAttributedString(string: name + "：",
                                                     attributes: [
                                                        NSForegroundColorAttributeName: HFTheme.TintColor
                ]))
            
            attText.append(NSMutableAttributedString(string: original.content,
                                                     attributes: [
                                                        NSForegroundColorAttributeName: HFTheme.DarkTextColor
                ]))
            originalConfessLabel.attributedText = attText
        } else {
            let attText = NSMutableAttributedString(string: "表白已被删除", attributes: [
                NSForegroundColorAttributeName: HFTheme.DarkTextColor
                ])
            originalConfessLabel.attributedText = attText
        }
        
        
        let att = NSMutableAttributedString()
        let date = NSAttributedString(string: Utilities.getTimeStringWithYear(model.date))
        att.append(date)
        
        if model.name == "" {
            let poster = NSAttributedString(string: " #匿名发布", attributes: [NSForegroundColorAttributeName: Theme.TintColor])
            att.append(poster)
        }
        
        dateLabel.attributedText = att
    }
    
    @IBAction func onDeleteButtonPressed(_ sender: Any) {
        
    }
}
