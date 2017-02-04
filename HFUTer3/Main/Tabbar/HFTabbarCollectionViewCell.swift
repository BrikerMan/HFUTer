//
//  HFTabbarCollectionViewCell.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/3.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFTabbarCollectionViewCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var hubView: UIView!
    
    var shouldShowDate = false {
        didSet { dateLabel.isHidden = !shouldShowDate}
    }
    
    var dateLabel = UILabel()
    
    static var nib: UINib? {
        return UINib(nibName: "HFTabbarCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hubView.isHidden = true
        hubView.layer.cornerRadius = 4
        
        let now = Date() // 現在日時の取得
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d" // 日付フォーマットの設定
        let date = dateFormatter.string(from: now)
        
        dateLabel.font = UIFont.boldSystemFont(ofSize: 10)
        dateLabel.text = date
        dateLabel.isHidden = true
        dateLabel.textAlignment = .center
        iconImageView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(iconImageView.snp.centerX).offset(0.5)
            make.centerY.equalTo(iconImageView.snp.centerY).offset(3)
        }
        
        iconImageView.tintColor = HFTheme.TintColor
 
    }
    
    

    func setup(_ title:String, icon: String, selected: Bool) {
        titleLabel.text = title
        if selected {
            titleLabel.textColor = HFTheme.TintColor
            iconImageView.image  = UIImage(named: icon + "_fill")?.withRenderingMode(.alwaysTemplate)
            dateLabel.textColor  = HFTheme.TintColor
        } else {
            titleLabel.textColor = HFTheme.GreyTextColor
            iconImageView.image  = UIImage(named: icon)
            dateLabel.textColor  = UIColor(hexString: "999999")
        }
        
        if title == "课表" {
            dateLabel.isHidden = false
        } else {
            dateLabel.isHidden = true
        }
        iconImageView.tintColor = HFTheme.TintColor
    }
    
}
