//
//  HFMineDonateSuccessView.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/6.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFMineDonateSuccessView: HFXibView {
    
    @IBOutlet weak var avatarImageView: HFImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cashLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    override func initFromXib() {
        super.initFromXib()
        avatarImageView.layer.cornerRadius  = 30
        avatarImageView.clipsToBounds       = true
        mainView.layer.cornerRadius         = 3
    }
    
    
    func setup(_ name: String, avatar: String, cash: Int) {
        nameLabel.text = "\(name)同学"
        avatarImageView.loadAvatar(avatar: avatar)
        cashLabel.text = "￥\(cash).0"
        
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        timeLabel.text = formatter.string(from: date)
    }
    
    @IBAction func onTapGesturePressed(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
        }) 
    }
}
