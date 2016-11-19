//
//  HFBaseTableViewCell.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/4/18.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFBaseTableViewCell: UITableViewCell, NibReusable  {

    static var nib: UINib? {
        return UINib(nibName: String(describing: self.self), bundle: nil)
    }
    
    static var reuseIdentifier: String? {
        return String(describing: self.self)
    }

}
