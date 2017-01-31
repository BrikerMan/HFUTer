//
//  HFInfoGradesCalculatorCell.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/26.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import LTMorphingLabel
import AIFlatSwitch

protocol HFInfoGradesCalculatorCellDelegate :class{
    func calculateCell(_ cell:HFInfoGradesCalculatorCell, changedModel model:HFGradesModel, atIndexPath indexPath:IndexPath)
    func calculateCell(_ cell:HFInfoGradesCalculatorCell, deletedModel model:HFGradesModel, atIndexPath indexPath:IndexPath)
}


class HFInfoGradesCalculatorCell: UITableViewCell, NibReusable {
    
    weak var delegate: HFInfoGradesCalculatorCellDelegate?
    
    var index:IndexPath!
    var model:HFGradesModel!

    @IBOutlet weak var titleLabel  : UILabel!
    @IBOutlet weak var scoreLabel  : UILabel!
    @IBOutlet weak var mekupLabel  : UILabel!
    @IBOutlet weak var cridetLabel : UILabel!
    @IBOutlet weak var gpaLabel    : LTMorphingLabel!
    
    @IBOutlet weak var selectionButtonBack: UIView!
    let selectionButton = AIFlatSwitch()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionButton.strokeColor = HFTheme.TintColor
        selectionButton.trailStrokeColor = HFTheme.LightTintColor
        gpaLabel.morphingEffect = .fall
        gpaLabel.morphingEnabled = false
        
        selectionButtonBack.addSubview(selectionButton)
        selectionButton.snp.makeConstraints {
            $0.edges.equalTo(selectionButtonBack)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupWithModel(_ model: HFGradesModel, index: IndexPath) {
        gpaLabel.morphingEnabled = false
        self.model = model
        self.index = index
        
        titleLabel.text  = model.name
        scoreLabel.text  = "成绩：\(model.score)"
        mekupLabel.text  = "补考：\(model.makeup)"
        cridetLabel.text = "学分：\(model.credit)"
        gpaLabel.text    = "绩点：\(model.gpa)"

//        selectionButton.isSelected = (model.gpa == "公选")
        
        
    }
    
    @IBAction func onSwitchValueChange(_ sender: AnyObject) {
        gpaLabel.morphingEnabled = true
        if let flatSwitch = sender as? AIFlatSwitch {
            if flatSwitch.isSelected {
                self.model.gpa = "公选"
            } else {
                self.model.gpa = HFInfoGradesCalculator().calculateGPAForScore(model.score).description
            }
        }
        gpaLabel.text    = "绩点：\(model.gpa)"
        delegate?.calculateCell(self, changedModel: self.model, atIndexPath: self.index)
    }

    @IBAction func onDeleteButtonPressed(_ sender: AnyObject) {
        delegate?.calculateCell(self, deletedModel: self.model, atIndexPath: self.index)
    }
}
