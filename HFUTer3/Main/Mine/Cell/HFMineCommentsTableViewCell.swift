//
//  HFMineCommentsTableViewCell.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/6/21.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit
import YYText

protocol HFMineCommentsTableViewCellDelegate: class {
    func onDeleteButtonPressed(model: HFMineCommentModel, indexPath: IndexPath)
}

class HFMineCommentsTableViewCell: UITableViewCell, NibReusable {
    
    weak var delegate: HFMineCommentsTableViewCellDelegate?
    
    var titleLabel    =  YYLabel()
    var originalLabel = YYLabel()
    var originalBackView = UIView()
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var model: HFMineCommentModel!
    var indexPath: IndexPath!
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.frame = CGRect(x: 12, y: 10, w: 0, h: 0)
        originalBackView.backgroundColor = Theme.BlackAreaColor
        originalBackView.layer.cornerRadius = 3
        addSubview(titleLabel)
        addSubview(originalBackView)
        originalBackView.addSubview(originalLabel)
    }
    
    func blind(model: HFMineCommentModel, indexPath: IndexPath) {
        guard
            let titleLayout = model.layoutCache["titleLayout"] as? YYTextLayout,
            let originalLayout = model.layoutCache["originalLayout"] as? YYTextLayout,
            let dateAttText = model.layoutCache["dateAttText"] as? NSMutableAttributedString
            else {
                Logger.error("错误啦错误啦，计算少了")
                return
        }
        self.indexPath = indexPath
        self.model = model
        
        titleLabel.size       = titleLayout.textBoundingSize
        titleLabel.textLayout = titleLayout
        
        originalBackView.frame = CGRect(x: 12,
                                        y: titleLayout.textBoundingSize.height + 20,
                                        w: ScreenWidth - 24,
                                        h: originalLayout.textBoundingSize.height + 16)
        originalLabel.frame = CGRect(x: 8,
                                     y: 8,
                                     w: originalLayout.textBoundingSize.width,
                                     h: originalLayout.textBoundingSize.height)
        originalLabel.textLayout = originalLayout
        dateLabel.attributedText = dateAttText
        Logger.debug("\(model.content) \n\(titleLayout.textBoundingSize)")
    }
    
    @IBAction func onDeleteButtonPressed(_ sender: Any) {
        delegate?.onDeleteButtonPressed(model: self.model, indexPath: indexPath)
    }
    
    static func height(model: HFMineCommentModel) -> CGFloat {
        if let originalLayout = model.layoutCache["originalLayout"] as? YYTextLayout,
            let titleLayout = model.layoutCache["titleLayout"] as? YYTextLayout {
            return titleLayout.textBoundingSize.height + originalLayout.textBoundingSize.height + 10 + 10 + 8 + 8 + 10 + 14 + 10
        }
        
        let titleContainer = YYTextContainer(size: CGSize(width: ScreenWidth - 24, height: CGFloat.greatestFiniteMagnitude))
        let titleLayout = YYTextLayout(container: titleContainer, text: NSAttributedString(string: model.content))!
        model.layoutCache["titleLayout"] = titleLayout
        
        var originalText = NSMutableAttributedString()
        if let original = model.confession {
            let name = original.name.isBlank ? "匿名" : original.name
            originalText.append(NSMutableAttributedString(string: name + "：",
                                                          attributes: [
                                                            NSForegroundColorAttributeName: HFTheme.TintColor
                ]))
            
            originalText.append(NSMutableAttributedString(string: original.content,
                                                          attributes: [
                                                            NSForegroundColorAttributeName: HFTheme.DarkTextColor
                ]))
        } else {
            originalText = NSMutableAttributedString(string: "表白已被删除", attributes: [
                NSForegroundColorAttributeName: HFTheme.DarkTextColor
                ])
        }
        
        let originalContainer = YYTextContainer(size: CGSize(width: ScreenWidth - 40, height: 100))
        let originalLayout = YYTextLayout(container: originalContainer, text: originalText)!
        
        model.layoutCache["originalLayout"] = originalLayout
        
        let att = NSMutableAttributedString()
        let date = NSAttributedString(string: Utilities.getTimeStringWithYear(model.date))
        att.append(date)
        
        if model.name == "" {
            let poster = NSAttributedString(string: " #匿名发布", attributes: [NSForegroundColorAttributeName: Theme.TintColor])
            att.append(poster)
        }
        model.layoutCache["dateAttText"] = att
        
        Logger.debug("cache \(model.content) \n\(titleLayout.textBoundingSize)")
        return titleLayout.textBoundingSize.height + originalLayout.textBoundingSize.height + 10 + 10 + 8 + 8 + 10 + 14 + 10
    }
}
