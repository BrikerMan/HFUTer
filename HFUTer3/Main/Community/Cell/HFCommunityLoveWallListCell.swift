//
//  HFCommunityLoveWallListCell.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/1/29.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit
import YYText
import YYWebImage

protocol HFCommunityLoveWallListCellDelegate: class {
    func cellDidPressOnLike(_ index:Int)
}

class HFCommunityLoveWallListCell: UITableViewCell, NibReusable {
    
    weak var delegate:HFCommunityLoveWallListCellDelegate?
    
    var index: Int = 0
    var model: HFComLoveWallListModel!
    
    @IBOutlet weak var avatarView: HFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    var infoLabel    = YYLabel()
    var bigImageView = HFImageView(frame: CGRect.zero)
    
    
    @IBAction func onLikeButtonPressed(_ sender: AnyObject) {
        if model.favorite { return }
        delegate?.cellDidPressOnLike(self.index)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(infoLabel)
        infoLabel.frame = CGRect(x: 54, y: 52, width: 100, height: 100)
        addSubview(bigImageView)
        avatarView.cornet(17)
        bigImageView.cornet(4)
    }
    
    func setupWithModel(_ model: HFComLoveWallListModel, index: Int) {
        self.index = index
        self.model = model
        
        // AutolAyout 处理补分
        avatarView.loadAvatar(avatar: model.image)
        if model.name.isBlank {
            usernameLabel.text = "匿名"
        } else {
            usernameLabel.text = model.name
        }
        
        if model.color == 0 {
            usernameLabel.textColor = UIColor(hexString: "#3d9cdd")
        } else {
            usernameLabel.textColor = UIColor(hexString: "#9b59b6")
        }
        
        dateLabel.text  = Utilities.getTimeStringFromTimeStamp(model.date_int)
        
        if model.favoriteCount != 0 {
            likeCountLabel.text = "  \(model.favoriteCount)"
        } else {
            likeCountLabel.text = "  赞"
        }
        
        if model.commentCount != 0 {
            commentCountLabel.text = "  \(model.commentCount)"
        } else {
            commentCountLabel.text = "  评论"
        }
        
        let image = model.favorite ? "fm_community_love_wall_like_fill" : "fm_community_love_wall_like"
        likeImageView.image = UIImage(named: image)
        
        
        
        // Old fashion frame 部分
        infoLabel.size = model.listLayout!.textBoundingSize
        infoLabel.textLayout = model.listLayout!
        
        if let bigImage = model.cImage {
            bigImageView.frame = CGRect(x: 53,
                                        y: model.listLayout!.textBoundingSize.height + 54 + 8,
                                        w: 200,
                                        h: 190)
            
            loadCover(bigImage, finished: { (image) in
                let size  = image?.size ?? self.bigImageView.size
                print(size)
                var width = size.width * 190 / size.height
                if width > ScreenWidth - 64 {
                    width = ScreenWidth - 64
                }
                self.bigImageView.frame = CGRect(x: 53,
                                                 y: model.listLayout!.textBoundingSize.height + 54 + 8,
                                                 w: width,
                                                 h: 190)
            })
        } else {
            bigImageView.frame = CGRect.zero
        }
    }
    
    func loadCover(_ cover: String, finished:((_ image: UIImage?)->Void)? = nil) {
        let placeHolder = UIImage(named: "hf_cover_placeholder")
        let urlString = APIBaseURL + "/res/formatImage?key=" + cover
        if let url = URL(string: urlString) {
            bigImageView.yy_setImage(with: url,
                             placeholder: placeHolder,
                             options: [.progressiveBlur, .showNetworkActivity],
                             progress: nil,
                             transform: { (image, url) -> UIImage? in
                                return image.yy_image(byRoundCornerRadius: 4 * ScreenScale)
            }) { (image, url, cacheType, stage, error) in
                finished?(image)
            }
        }
    }
    
    static func height(model: HFComLoveWallListModel) -> CGFloat {
        let imageHeight: CGFloat = model.cImage != nil ? 200 : 0
        
        if let layout = model.listLayout {
            
            return layout.textBoundingSize.height + 52 + 42 + imageHeight
        }
        
        let attText = NSMutableAttributedString(string: model.content, attributes: [
            NSFontAttributeName             : UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName  : HFTheme.DarkTextColor
            ])
        
        let size = CGSize(width: ScreenWidth - 64, height: CGFloat.greatestFiniteMagnitude)
        
        let mod = YYTextLinePositionSimpleModifier()
        mod.fixedLineHeight = 18
        
        let container = YYTextContainer(size: size)
        container.linePositionModifier = mod
        container.maximumNumberOfRows  = 15
        container.truncationType = YYTextTruncationType.end
        container.truncationToken = NSAttributedString(string: " ...", attributes: [
            NSFontAttributeName             : UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName  : UIColor(hexString: "#3d9cdd")!
            ])
        let layout = YYTextLayout(container: container, text: attText)!
        model.listLayout = layout
        
        return layout.textBoundingSize.height + 52 + 42 + imageHeight
    }
    
}
