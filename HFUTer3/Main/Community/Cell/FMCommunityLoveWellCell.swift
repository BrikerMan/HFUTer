//
//  FMCommunityLoveWellCell.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/5/8.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

protocol FMCommunityLoveWellCellDelegate: class {
    func cellDidPressOnLike(_ index:Int)
}

class FMCommunityLoveWellCell: UITableViewCell, NibReusable {
    
    weak var delegate:FMCommunityLoveWellCellDelegate?

    var index: Int = 0
    var model: HFComLoveWallListModel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avatarView: HFImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var coverImageView: HFImageView!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    
    @IBOutlet weak var likeImageView: UIImageView!
    
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var seperator1Height: NSLayoutConstraint!
    @IBOutlet weak var seperator2Height: NSLayoutConstraint!
    
    @IBOutlet weak var imageViewTop: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var containerTop: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarView.layer.cornerRadius = 20
        seperator2Height.constant = SeperatorHeight
        seperator1Height.constant = SeperatorHeight
    }

    @IBAction func onLikeButtonPressed(_ sender: AnyObject) {
        if model.favorite { return }
        delegate?.cellDidPressOnLike(self.index)
    }
    
    func setupWithModel(_ model: HFComLoveWallListModel , index: Int) {
        self.index = index
        self.model = model
        avatarView.loadAvatar(avatar: model.image)
        if model.name.isBlank {
            nameLabel.text = "匿名"
        } else {
            nameLabel.text = model.name
        }
        timeLabel.text  = Utilities.getTimeStringFromTimeStamp(model.date_int)
        infoLabel.text  = model.content
        
        if model.favoriteCount != 0 {
            likeCount.text = "\(model.favoriteCount)"
        } else {
            likeCount.text = "赞"
        }
        
        if model.commentCount != 0 {
            commentCount.text = "\(model.commentCount)"
        } else {
            commentCount.text = "评论"
        }
        
        if model.color == 0 {
            nameLabel.textColor = UIColor(hexString: "#3d9cdd")
        } else {
            nameLabel.textColor = UIColor(hexString: "#9b59b6")
        }
        
        
        let image = model.favorite ? "fm_community_love_wall_like_fill" : "fm_community_love_wall_like"
        likeImageView.image = UIImage(named: image)
        prepareUIForImage(model.cImage)

    }
    
    func setupWithCommentModel(_ model: HFComLoveWallCommentModel) {
        avatarView.loadAvatar(avatar: model.image)
        if model.name.isBlank {
            nameLabel.text = "匿名"
        } else {
            nameLabel.text = model.name
        }
        timeLabel.text  = Utilities.getTimeStringFromTimeStamp(model.date_int)
        
        let textAttributes   = [ NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                                 NSForegroundColorAttributeName: HFTheme.DarkTextColor ]
        
        let atTextAttributes = [ NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                                 NSForegroundColorAttributeName: HFTheme.TintColor ] as [String : Any]
        
        if model.at.count == 1 {
            let string = NSMutableAttributedString(string: "@\(model.at[0].name)", attributes: atTextAttributes)
            let info   = NSMutableAttributedString(string: " \(model.content)", attributes: textAttributes)
            string.append(info)
            self.infoLabel.attributedText = string
        } else {
            let info  = NSMutableAttributedString(string: model.content, attributes: textAttributes)
            self.infoLabel.attributedText = info
        }
        
        containerTop.constant = 0
        prepareUIForImage(nil)
    }
    
    
    fileprivate func prepareUIForImage(_ image:String?) {
        if let image = image {
            imageViewTop.constant = 10
            imageViewHeight.constant = 11/16 * ScreenWidth
            coverImageView.loadCover(cover: image)
            coverImageView.isHidden = false
        } else {
            imageViewTop.constant = 0
            imageViewHeight.constant = 0
            coverImageView.isHidden = true
        }
    }
}
