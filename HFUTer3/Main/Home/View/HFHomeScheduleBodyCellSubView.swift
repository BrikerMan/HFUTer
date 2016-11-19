//
//  HFHomeScheduleBodyCellSubView.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/19.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFHomeScheduleBodyCellSubView: HFXibView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var seperatorHeight: NSLayoutConstraint!
    
    override func initFromXib() {
        super.initFromXib()
        view?.backgroundColor = UIColor.white
        seperatorHeight.constant = 0.5
    }
    
    func setupWithCourse(_ model:HFCourseModel) {
        titleLabel.text = model.name
        placeLabel.text = model.place
        view?.backgroundColor = HFTheme.getColorForCourses(withName: model.name)
    }
    
    func setupWithCourses(_ models:[HFCourseModel]) {
        var title = ""
        var place = ""
        
        for i in 0..<models.count {
            if i == 0 {
                title = title + getShortCharacters(models[i].name)
                place = place + getShortCharacters(models[i].place)
            } else {
                title = title + " & " + getShortCharacters(models[i].name)
                place = place + " & " + getShortCharacters(models[i].place)
            }
        }
        titleLabel.text = title
        placeLabel.text = place
        view?.backgroundColor = HFTheme.getRandomColor().color
    }
    
    
    func getShortCharacters(_ original:String) -> String {
        if let short = original[0..<5] {
            return short
        }
        return original
    }
    
}
