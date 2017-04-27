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
import RxSwift

protocol HFCommunityLoveWallListCellDelegate: class {
    func cellDidPressOnLike(_ index:Int)
}

class HFCommunityLoveWallListCell: UITableViewCell, NibReusable {
    
    weak var delegate:HFCommunityLoveWallListCellDelegate?
    
    var index: Int = 0
    var model: HFComLoveWallListModel!
    
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var avatarView: HFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var containerBottom: NSLayoutConstraint!
    
    var infoLabel    = YYLabel()
    var bigImageView = HFImageView(frame: CGRect.zero)
    
    @IBAction func onLikeButtonPressed(_ sender: AnyObject) {
        if model.favorite.value { return }
        delegate?.cellDidPressOnLike(self.index)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        infoLabel.copyingEnabled = true
        addSubview(infoLabel)
        infoLabel.frame = CGRect(x: 54, y: 52, width: 100, height: 100)
        addSubview(bigImageView)
        avatarView.cornet(17)
        bigImageView.cornet(4)
        bigImageView.contentMode = .scaleToFill
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func setupWithModel(_ model: HFComLoveWallListModel, index: Int, isDetail: Bool = false) {
        self.index = index
        self.model = model
        
        // AutolAyout 处理补分
        avatarView.loadAvatar(avatar: model.image)
        if model.name.isBlank {
            usernameLabel.text = "匿名同学"
        } else {
            usernameLabel.text = model.name
        }
        
        if model.color == 0 {
            usernameLabel.textColor = UIColor(hexString: "#3d9cdd")
        } else {
            usernameLabel.textColor = UIColor(hexString: "#9b59b6")
        }
        
        dateLabel.text  = Utilities.getTimeStringFromTimeStamp(model.date_int)
        
        // 详情页不用设置
        if !isDetail {
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
            
            model.favorite.asObservable().subscribe(onNext: { [weak self] (element) in
                let image = element ? "fm_community_love_wall_like_fill" : "fm_community_love_wall_like"
                self?.likeImageView.image = UIImage(named: image)
            }).addDisposableTo(disposeBag)
            
            bottomViewHeight.constant = 30
            containerBottom.constant  = 4
        } else {
            bottomViewHeight.constant = 0
            containerBottom.constant  = 12
        }
        
        // Old fashion frame 部分
        // 首页列表补分
        if !isDetail {
            infoLabel.frame.origin.x = 54
            infoLabel.size       = model.listLayout!.textBoundingSize
            infoLabel.textLayout = model.listLayout!
        } else {
            infoLabel.frame.origin.x = 10
            infoLabel.size       = model.detailLayout!.textBoundingSize
            infoLabel.textLayout = model.detailLayout!
        }
        
        
        
        if let _ = model.cImage {
            let frame = CGRect(x: 10,
                               y: model.detailLayout!.textBoundingSize.height + 54 + 8,
                               w: ScreenWidth - 20,
                               h: ScreenWidth - 20)
            
            bigImageView.frame = frame
            
            loadCover(for: model, finished: { (image) in
                var size = CGSize(width: 100, height: 190)
                let imagesize  = model.cImageSize ?? image?.size ?? self.bigImageView.size
                
                let x: CGFloat
                if !isDetail {
                    x = 54
                    size = Utilities.getWidthWithFixedHeight(size: imagesize, height: 190, maxWidth: ScreenWidth - 64)
                } else {
                    x = 10
                    size = Utilities.getImageSize(size: imagesize, maxWidth: ScreenWidth - 20)
                }
                
                self.bigImageView.frame = CGRect(x: x,
                                                 y: self.bigImageView.frame.y,
                                                 w: size.width,
                                                 h: size.height)
            })
        } else {
            bigImageView.yy_cancelCurrentImageRequest()
            bigImageView.frame = CGRect.zero
        }
    }
    
    func loadCover(for model: HFComLoveWallListModel, finished:((_ image: UIImage?)->Void)? = nil) {
        let placeHolder = UIImage(named: "hf_cover_placeholder")
        let urlString = APIBaseURL + "/res/formatImage?key=" + model.cImage!
        if let url = URL(string: urlString) {
            bigImageView.yy_setImage(with: url,
                                     placeholder: placeHolder,
                                     options:  [.progressiveBlur, .showNetworkActivity],
                                     completion: { (image, url, cacheType, stage, error) in
                model.cImageSize = image?.size
                finished?(image)
            })
        }
    }
    
    static func height(model: HFComLoveWallListModel, isDetail: Bool = false) -> CGFloat {
        var imageHeight: CGFloat = model.cImage != nil ? 200 : 0
        
        if isDetail {
            if let imageSize = model.cImageSize {
                imageHeight = Utilities.getImageSize(size: imageSize, maxWidth: ScreenWidth - 20).height + 10
            }
            if let layout = model.detailLayout {
                return layout.textBoundingSize.height + 54 + 22 + imageHeight
            }
        } else {
            if let layout = model.listLayout {
                return layout.textBoundingSize.height + 54 + 44 + imageHeight
            }
        }
        
        let attText = NSMutableAttributedString(string: model.content, attributes: [
            NSFontAttributeName             : UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName  : HFTheme.DarkTextColor,
            ])
        
        let width = isDetail ? ScreenWidth - 20 : ScreenWidth - 64
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let mod = YYTextLinePositionSimpleModifier()
        mod.fixedLineHeight = 20
        
        let container = YYTextContainer(size: size)
        container.linePositionModifier = mod
        
        if !isDetail {
            container.maximumNumberOfRows  = 15
            container.truncationType = YYTextTruncationType.end
            container.truncationToken = NSAttributedString(string: " ...", attributes: [
                NSFontAttributeName             : UIFont.systemFont(ofSize: 14),
                NSForegroundColorAttributeName  : UIColor(hexString: "#3d9cdd")
                ])
        }
        let layout = YYTextLayout(container: container, text: attText)!
        
        if isDetail {
            model.detailLayout = layout
            return layout.textBoundingSize.height + 54 + 14 + imageHeight
        } else {
            model.listLayout   = layout
            return layout.textBoundingSize.height + 54 + 44 + imageHeight
        }
    }
    
}
