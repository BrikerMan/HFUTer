//
//  HFCommunityLoveDetailCommentCell.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/1/31.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit
import YYText

enum HFCommentActionType {
    case replyComment
    case delete
}

protocol HFCommunityLoveDetailCommentCellDelegate: class {
    func commentCell(cell: HFCommunityLoveDetailCommentCell, didPessOnAction action: HFCommentActionType)
}

class HFCommunityLoveDetailCommentCell: UITableViewCell, NibReusable {
    
    weak var delegate: HFCommunityLoveDetailCommentCellDelegate?
    
    var index: Int = 0
    var model: HFComLoveWallCommentModel!
    
    @IBOutlet weak var avatarView: HFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var infoLabel = YYLabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        infoLabel.copyingEnabled = true
        addSubview(infoLabel)
        infoLabel.frame = CGRect(x: 54, y: 52, width: 100, height: 100)
        avatarView.cornet(17)
    }
    
    @IBAction func onActionButtonPressed(_ sender: Any) {
        var action = HFCommentActionType.replyComment
        if model.mine {
            action = .delete
        }
        delegate?.commentCell(cell: self, didPessOnAction: action)
    }
    
    func setup(_ model: HFComLoveWallCommentModel, index: Int) {
        self.index = index
        self.model = model
        
        // AutolAyout 处理补分
        avatarView.loadAvatar(avatar: model.image)
        
        if model.name.isBlank {
            usernameLabel.text = "匿名"
            actionButton.isHidden = true
        } else {
            actionButton.isHidden = false
            actionButton.setImage(UIImage(named: "fm_community_love_wall_comment_small"), for: .normal)
            usernameLabel.text = model.name
        }
        
        if model.mine {
            actionButton.isHidden = false
            actionButton.setImage(UIImage(named: "fm_community_love_wall_delete_small"), for: .normal)
        }
        
        infoLabel.size       = model.detailLayout!.textBoundingSize
        infoLabel.textLayout = model.detailLayout!
        
        
        let att = NSMutableAttributedString()
        let date = NSAttributedString(string: Utilities.getTimeStringFromTimeStamp(model.date_int))
        att.append(date)
        
        if model.poster {
            let poster = NSAttributedString(string: " #楼主", attributes: [NSForegroundColorAttributeName: Theme.TintColor])
            att.append(poster)
        }
        
        dateLabel.attributedText = att
    }
    
    
    static func height(model: HFComLoveWallCommentModel) -> CGFloat {
        if let layout = model.detailLayout {
            return layout.textBoundingSize.height + 54 + 14
        }
        
        let textAttributes   = [ NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: HFTheme.DarkTextColor ]
        let atTextAttributes = [ NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: HFTheme.TintColor ] as [String : Any]
        
        var attText: NSMutableAttributedString
        
        if model.at.count == 1 {
            attText = NSMutableAttributedString(string: "@\(model.at[0].name)", attributes: atTextAttributes)
            let info   = NSMutableAttributedString(string: " \(model.content)", attributes: textAttributes)
            attText.append(info)
        } else {
            attText = NSMutableAttributedString(string: model.content, attributes: textAttributes)
        }
        
        let width = ScreenWidth - 64
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let mod = YYTextLinePositionSimpleModifier()
        mod.fixedLineHeight = 20
        
        let container = YYTextContainer(size: size)
        container.linePositionModifier = mod
        
        let layout = YYTextLayout(container: container, text: attText)!
        model.detailLayout = layout
        
        
        return layout.textBoundingSize.height + 54 + 14
    }
}
