//
//  HFInfoAcademicClassDetailVCCell.swift
//  HFUTer3
//
//  Created by 帅帅 on 16/3/23.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFInfoAcademicClassDetailTableCell:UITableViewCell {
    static let identifer = "HFInfoAcademicClassDetailTableCell"
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var sidLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var seperatorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var seperatorLeftConsraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        seperatorHeightConstraint.constant = 0.5
    }
    
    func setupCellWithStruct(_ model:HFAcademicClassDetailModel,isLast:Bool){
        idLabel.text  = model.id
        sidLabel.text = model.sid
        nameLabel.text = model.name
        
        if isLast {
            seperatorLeftConsraint.constant = 0
        }else{
            seperatorLeftConsraint.constant = 10
        }
    }
}
