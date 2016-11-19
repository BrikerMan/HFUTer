//
//  HFBaseNavBar.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/17.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

protocol HFBaseNavBarDelegate :class{
    func navBarDidPressOnBackButton()
    func navBarOnNavRightButtonPressed()
}

enum navRightIconType: String {
    case More   = "hf_nav_more_icon"
    case Static = "hf_nav_static_button"
    
    func image() -> UIImage {
        return UIImage(named: self.rawValue)!
    }
}

class HFBaseNavBar: HFXibView {

    weak var delegate:HFBaseNavBarDelegate?
    
    @IBOutlet weak var navLeftButton: UIButton!
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var navRightButton: UIButton!
    @IBOutlet weak var navRightButtonImage: UIImageView!
    
    override func initFromXib() {
        super.initFromXib()
        navRightButton.isHidden       = true
        navRightButtonImage.isHidden  = true
    }
    
    var shouldShowBackButton = true {
        didSet {
            navLeftButton.isHidden = !shouldShowBackButton
        }
    }
    
    func showNavRightButton(withButton button:navRightIconType) {
        navRightButton.isHidden       = false
        navRightButtonImage.isHidden  = false
        navRightButtonImage.image   = button.image()
    }
    
    func setNavTitle(_ title:String) {
        navTitleLabel.text = title
    }

    @IBAction func onBackButtonPressed(_ sender: AnyObject) {
        delegate?.navBarDidPressOnBackButton()
    }

    @IBAction func onNavRightButtonPressed(_ sender: AnyObject) {
        delegate?.navBarOnNavRightButtonPressed()
    }
}
