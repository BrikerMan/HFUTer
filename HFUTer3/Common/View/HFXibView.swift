//
//  HFXibBiew.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/17.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import RxSwift

class HFXibView: UIView {
    var view:UIView?
    
    var disposeBag = DisposeBag()
    
    //MARK:- 生命周期
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromXib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)!
        initFromXib()
    }
    
    //MARK:- 加载nib
    func initFromXib(){
        let xibName = NSStringFromClass(self.classForCoder)
        let xibClassName = xibName.characters.split{$0 == "."}.map(String.init).last
        let view = Bundle.main.loadNibNamed(xibClassName!, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        view.translatesAutoresizingMaskIntoConstraints = true
        view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.addSubview(view)
        self.view = view
        
    }
}


class HFView: UIView {
    var view:UIView?
    var disposeBag = DisposeBag()
    
    //MARK:- 生命周期
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)!
        initSetup()
    }
    
    //MARK:- 初始化
    func initSetup(){
        
    }
}

