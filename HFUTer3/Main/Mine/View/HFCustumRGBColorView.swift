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
            let backColor  = UIColor(red: CGFloat(color.r)/255.0, green: CGFloat(color.g)/255.0, blue: CGFloat(color.b)/255.0, alpha: 1.0)
            infoLabel.text = "Red \(color.r) Green \(color.g) Blue \(color.b)\n\(backColor.hex())"
            backView.backgroundColor = backColor
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
        rSlider.value = Float(cColor.redComponent)
        gSlider.value = Float(cColor.greenComponent)
        bSlider.value = Float(cColor.blueComponent)
    }

}

extension UIColor {
    func hex() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
}
