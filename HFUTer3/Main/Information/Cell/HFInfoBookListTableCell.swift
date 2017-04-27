//
//  HFInfoBookListTableCell.swift
//  HFUTer3
//
//  Created by 帅帅 on 16/4/11.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFInfoBookListTableCell: UITableViewCell {
    static let identifer = "HFInfoBookListTableCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var returnDateLabel: UILabel!
    @IBOutlet weak var renewCountLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    @IBOutlet weak var seperatorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var seperatorLeftConsraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        seperatorHeightConstraint.constant = 0.5
    }
    
    func setupCellWithStruct(_ model:HFInfoBookModel,isLast:Bool){
        nameLabel.text       = model.name
        codeLabel.text       = model.code
        authorLabel.text     = model.author
        startDateLabel.text  = model.startDate
        returnDateLabel.text = model.returnDate
        renewCountLabel.text = model.renewCount
        locationLabel.text   = model.location
        
        codeLabel.textColor       = HFTheme.GreyTextColor
        authorLabel.textColor     = HFTheme.GreyTextColor
        startDateLabel.textColor  = HFTheme.GreyTextColor
        returnDateLabel.textColor = HFTheme.GreyTextColor
        renewCountLabel.textColor = HFTheme.GreyTextColor
        locationLabel.textColor   = HFTheme.GreyTextColor
        
        if isLast {
            seperatorLeftConsraint.constant = 0
        }else{
            seperatorLeftConsraint.constant = 10
        }
    }
}
