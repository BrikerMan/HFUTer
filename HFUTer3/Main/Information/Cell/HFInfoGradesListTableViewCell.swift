//
//  HFInfoGradesListTableViewCell.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/24.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFInfoGradesListTableViewCell: UITableViewCell {
    
    static let identifier = "GradesListTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var classCodeLabel: UILabel!
    
    
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var makeupLabel: UILabel!
    @IBOutlet weak var cridetLabel: UILabel!
    @IBOutlet weak var gpaLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupWithModel(_ model:HFGradesModel) {
        titleLabel.text  = model.name
        codeLabel.text   = "课程代码：\(model.code)"
        classCodeLabel.text = "教学班号：\(model.classCode)"
        
        gradeLabel.text  = model.score
        makeupLabel.text = model.makeup
        
        if model.credit.hasPrefix("."){
            cridetLabel.text = "0" + model.credit
        }else{
            cridetLabel.text = model.credit
        }
    
        gpaLabel.text    = model.gpa
    }
    
    static func getHeightForModel(_ model:HFGradesModel) -> CGFloat {
        let labelHeight = model.name.heightWithConstrainedWidth(ScreenWidth-159, font: UIFont.systemFont(ofSize: 14))
        return 53 + labelHeight
    }
    
}
