//
//  HFCustumRGBColorView.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/2/3.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFCustumRGBColorView: HFXibView {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var rSlider: UISlider!
    @IBOutlet weak var gSlider: UISlider!
    @IBOutlet weak var bSlider: UISlider!
   
    
    var color: (r: Int, g: Int, b: Int) = (0,0,0) {
        didSet {
            let hex = String(format: "%02hhX%02hhX%02hhX", color.r, color.g, color.b)
            infoLabel.text = "Red \(color.r) Green \(color.g) Blue \(color.b)\n#\(hex)"
            backView.backgroundColor = UIColor(hexString: hex)!
        }
    }
    
    
    @IBAction func onCancelButtonPressed(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @IBAction func onConfermButtonPressed(_ sender: Any) {
        HFTheme.saveTintColor(name: "自定义",
                              color: String(format: "%02hhX%02hhX%02hhX", color.r, color.g, color.b))
        self.removeFromSuperview()
    }
    
    @IBAction func onSliderSlide(_ sender: UISlider) {
        switch sender.tag {
        case 1:
            color.r = Int(sender.value)
        case 2:
            color.g = Int(sender.value)
        case 3:
            color.b = Int(sender.value)
        default:
            break
        }
    }
    
    override func initFromXib() {
        super.initFromXib()
        let cColor = HFTheme.TintColor
        color = (cColor.redComponent, cColor.greenComponent, cColor.blueComponent)
    }
    

}
