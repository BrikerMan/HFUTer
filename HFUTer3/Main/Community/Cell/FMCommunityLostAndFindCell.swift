//
//  FMCommunityLostAndFindCell.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/4/18.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

protocol FMCommunityLostAndFindCellDelegate: class {
    func lostListDidPresContactButton(_ model:HFComLostFoundModel, atIndex: Int)
}

class FMCommunityLostAndFindCell: UITableViewCell, NibReusable {
    
    
    weak var delegate: FMCommunityLostAndFindCellDelegate?
    
    var model:HFComLostFoundModel!
    var index = 0
    
    @IBOutlet weak var containetView: UIView!
    @IBOutlet weak var topColorView: UIView!
    @IBOutlet weak var topImageView: UIImageView!
    
    @IBOutlet weak var imagesView: UIView!
    @IBOutlet weak var avatarImageView: HFImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var thingLabel: UILabel!
    @IBOutlet weak var timeSumLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var contactButton: UIButton!
    
    @IBOutlet weak var seperatorHeight: NSLayoutConstraint!
    @IBOutlet weak var seperator2Height: NSLayoutConstraint!
    @IBOutlet weak var infoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var buttomButtonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var imagesViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imagesViewTop: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        seperatorHeight.constant  = 0.5
        seperator2Height.constant = 0.5
        avatarImageView.layer.cornerRadius = 20
        containetView.clipsToBounds = true
        containetView.layer.cornerRadius  = 3
    }
    
    @IBAction func onContactButtonPressed(_ sender: AnyObject) {
        delegate?.lostListDidPresContactButton(self.model, atIndex: self.index)
    }
    
    func setupModel(_ model: HFComLostFoundModel, index: IndexPath) {
        self.index = index.row
        self.model = model
        
        if model.name.isBlank {
            titleLabel.text = "匿名"
        } else {
            titleLabel.text = model.name
        }
        avatarImageView.loadAvatar(avatar: model.image)
        
        infoLabel.text  = model.content
        timeLabel.text  = Utilities.getTimeStringFromTimeStamp(model.date_int)
        
        placeLabel.text    = model.place
        thingLabel.text    = model.thing
        timeSumLabel.text  = model.time
        
        infoViewHeight.priority = model.place.isBlank ? 750 : 250
        
        
        if model.type == 0 {
            topImageView.image = UIImage(named: "fm_community_lost_list_lost")
            topColorView.backgroundColor = UIColor(hexString: "8E44AD")
        } else {
            topImageView.image = UIImage(named: "fm_community_lost_list_found")
            topColorView.backgroundColor = UIColor(hexString: "FF8252")
        }
        updateUIForImages([])
    }
    
    fileprivate func updateUIForImages(_ pics:[String]) {
        switch pics.count {
        case 1:
            imagesViewHeight.constant = 160
            imagesViewTop.constant    = 10
            
            let imageView1 = HFImageView(frame: CGRect.zero)
            imagesView.addSubview(imageView1)
            imageView1.snp.makeConstraints({ (make) in
                make.edges.equalTo(imagesView)
            })
            imageView1.loadCover(cover: pics[0])
            
        default:
            for view in imagesView.subviews {
                view.removeFromSuperview()
            }
            imagesViewHeight.constant = 0
            imagesViewTop.constant    = 0
        }
    }
    
}
