//
//  HFInfoAcademicClassListVCCell.swift
//  HFUTer3
//
//  Created by 帅帅 on 16/3/23.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFInfoAcademicClassTableCell:UITableViewCell {
    static let height:CGFloat = 74
    static let identifer = "HFInfoAcademicClassTableCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var classCodeLabel: UILabel!
    @IBOutlet weak var seperatorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var seperatorLeftConsraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        seperatorHeightConstraint.constant = 0.5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCellWithStruct(_ model:HFAcademicClassListModel,isLast:Bool){
        nameLabel.text = model.name
        codeLabel.text = model.code
        codeLabel.textColor = ColorManager.shared.GreyTextColor
        classCodeLabel.text = model.classCode
        classCodeLabel.textColor = ColorManager.shared.GreyTextColor
        
        if isLast {
            seperatorLeftConsraint.constant = 0
        }else {
            seperatorLeftConsraint.constant = 15
        }
    }
}
