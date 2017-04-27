//
//  HFEurekaInfoCell.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/4/27.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Eureka

public class HFEurekaInfoCell: Cell<String>, CellType {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var colorView: UIView!
    
    var isColor = false
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        colorView.layer.cornerRadius = 15
    }


    public override func update() {
        super.update()
        infoLabel.text  = row.value ?? ""
        titleLabel.text = row.title
        textLabel?.isHidden = true
        
        colorView.isHidden = !isColor
        infoLabel.isHidden = isColor
        
        if isColor {
            colorView.backgroundColor = HFTheme.getColor(with: row.value ?? "")
        }
    }
}


public final class HFEurekaInfoRow: Row<HFEurekaInfoCell>, RowType {
    
    var isColor = false {
        didSet {
            cell.isColor = isColor
        }
    }
    
    
    required public init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<HFEurekaInfoCell>(nibName: "HFEurekaInfoCell")
    }
}
