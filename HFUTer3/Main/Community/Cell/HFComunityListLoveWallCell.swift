//
//  HFComunityListLoveWallCell.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/4/27.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit
import YYText
import RxSwift
import YYWebImage

class HFComunityListLoveWallCell: UITableViewCell, NibReusable {
    
    weak var delegate:HFCommunityLoveWallListCellDelegate?
    
    var disposeBag = DisposeBag()
    var index: Int = 0
    var model: HFComLoveWallListModel!
    
    @IBOutlet weak var avatarView    : HFImageView!
    @IBOutlet weak var usernameLabel : UILabel!
    @IBOutlet weak var dateLabel     : UILabel!
    
    @IBOutlet weak var likeCountLabel    : UILabel!
    @IBOutlet weak var likeImageView     : UIImageView!
    @IBOutlet weak var commentCountLabel : UILabel!
    
    var infoLabel    = YYLabel()
    var bigImageView = HFImageView(frame: CGRect.zero)
    
    @IBAction func onLikeButtonPressed(_ sender: AnyObject) {
        let model = self.model!
        if model.favorite.value { return }
        hud.showLoading("正在处理")
        HFBaseRequest.fire("/api/confession/favorite", method: HFBaseAPIRequestMethod.POST, params: ["id":model.id], succesBlock: { (request, resultDic) in
            model.favoriteCount += 1
            model.favorite.value = true
            hud.dismiss()

        }) { (request, error) in
            hud.showError(error)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        infoLabel.copyingEnabled = true
        addSubview(infoLabel)
        infoLabel.frame = CGRect(x: 54, y: 52, width: 100, height: 100)
        addSubview(bigImageView)
        avatarView.cornet(17)
        //        bigImageView.cornet(4)
        bigImageView.contentMode = .scaleToFill
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func setupWithModel(_ model: HFComLoveWallListModel, index: Int) {
        bigImageView.isHidden = true
        bigImageView.yy_cancelCurrentImageRequest()
        
        self.index = index
        self.model = model
        
        // AutolAyout 处理补分
        avatarView.loadAvatar(avatar: model.image)
        if model.name.isBlank {
            usernameLabel.text = "匿名童鞋"
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
        
        model.favorite.asObservable().subscribe(onNext: { [weak self] (element) in
            let image = element ? "fm_community_love_wall_like_fill" : "fm_community_love_wall_like"
            runOnMainThread {
                self?.likeImageView.image = UIImage(named: image)
                if self?.model.favoriteCount != 0 {
                    self?.likeCountLabel.text = "  \(model.favoriteCount)"
                } else {
                    self?.likeCountLabel.text = "  赞"
                }
            }
        }).addDisposableTo(disposeBag)
        
        if let layout = model.layout["infoLayout"] as? YYTextLayout {
            infoLabel.frame.origin.x = 54
            infoLabel.size       = layout.textBoundingSize
            infoLabel.textLayout = layout
            
            if let _ = model.cImage {
                bigImageView.isHidden = false
                let frame = CGRect(x: 53,
                                   y: layout.textBoundingSize.height + 54 + 8,
                                   w: 200,
                                   h: 190)
                
                bigImageView.frame = frame
                
                loadCover(for: model, finished: { (image) in
                    var size = CGSize(width: 100, height: 190)
                    let imagesize  = model.cImageSize ?? image?.size ?? self.bigImageView.size
                    
                    size = Utilities.getWidthWithFixedHeight(size: imagesize, height: 190, maxWidth: ScreenWidth - 64)
                    
                    self.bigImageView.frame = CGRect(x: 54,
                                                     y: self.bigImageView.frame.y,
                                                     w: size.width,
                                                     h: size.height)
                })
            } else {
                bigImageView.frame = CGRect.zero
            }
        }
    }
    
    
    func loadCover(for model: HFComLoveWallListModel, finished:((_ image: UIImage?)->Void)? = nil) {
        let placeHolder = UIImage(named: "hf_cover_placeholder")
        let urlString = APIBaseURL + "/res/formatImage?key=" + model.cImage!
        if let url = URL(string: urlString) {
            bigImageView.yy_setImage(with: url,
                                     placeholder: placeHolder,
                                     options:  [.showNetworkActivity],
                                     completion: { (image, url, cacheType, stage, error) in
                                        model.cImageSize = image?.size
                                        finished?(image)
            })
            
        }
    }
    
    static func cacheLayout(_ model: HFComLoveWallListModel) -> CGFloat {
        let imageHeight: CGFloat = model.cImage != nil ? 200 : 0
        
        if let layout = model.layout["infoLayout"] as? YYTextLayout {
            return layout.textBoundingSize.height + 54 + 44 + imageHeight
        } else {
            let attText = NSMutableAttributedString(string: model.content, attributes: [
                NSFontAttributeName             : UIFont.systemFont(ofSize: 14),
                NSForegroundColorAttributeName  : HFTheme.DarkTextColor,
                ])
            
            let width = ScreenWidth - 64
            let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
            
            let mod = YYTextLinePositionSimpleModifier()
            mod.fixedLineHeight = 20
            
            let container = YYTextContainer(size: size)
            container.linePositionModifier = mod
            
            container.maximumNumberOfRows  = 15
            container.truncationType = YYTextTruncationType.end
            container.truncationToken = NSAttributedString(string: " ...", attributes: [
                NSFontAttributeName             : UIFont.systemFont(ofSize: 14),
                NSForegroundColorAttributeName  : UIColor(hexString: "#3d9cdd")
                ])
            let infoLayout = YYTextLayout(container: container, text: attText)!
            model.layout["infoLayout"] = infoLayout
            return infoLayout.textBoundingSize.height + 54 + 44 + imageHeight
        }
    }
}
