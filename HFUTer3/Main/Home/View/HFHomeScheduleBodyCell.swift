//
//  HFHomeScheduleBodyCell.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/19.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFHomeScheduleBodyCell: UICollectionViewCell {
    
    var temptextLabel = UILabel()
    
    var model:[CourseHourModel]!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var seperatorHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        seperatorHeight.constant = 0.5
        seperatorView.backgroundColor = HFTheme.SeperatorColor
        
        addSubview(temptextLabel)
        
        temptextLabel.font = UIFont.systemFont(ofSize: 12)
        temptextLabel.numberOfLines = 0
        temptextLabel.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
        }
    }
    
    func setupWithModel(_ models: [CourseHourModel] ) {
        
        for view in subviews {
            view.removeFromSuperview()
        }
        
        if models.isEmpty {
            self.backgroundColor = UIColor.white
        } else if models.count == 1 {
            // 没有课程情况
            if models[0].models.count == 0 {
                self.backgroundColor = UIColor.white
            } else  {
                let view = HFHomeScheduleBodyCellSubView()
                self.addSubview(view)
                view.snp.makeConstraints({ (make) -> Void in
                    make.edges.equalTo(self)
                })
                
                if models[0].models.count == 1 {
                    // 只有一节大课
                    view.setupWithCourse(models[0].models[0])
                } else {
                    // 有若干大节课在一个格子里。一般只是显示全部课程时候显示
                    view.setupWithCourses(models[0].models)
                }
            }
            
        } else {
            
            self.backgroundColor = UIColor.black
        }
    }
}
