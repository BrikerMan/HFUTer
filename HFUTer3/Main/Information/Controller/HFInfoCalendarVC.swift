//
//  HFInfoCalendarVC.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/10.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFInfoCalendarVC: HFBaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: HFImageView!
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
    var loadingView: HFLoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "校历"
        
        initUI()
        load()
        
        AnalyseManager.QueryCalender.record()
    }
    
    
    func load() {
        loadingView.show()
        
        if let
            urlString = PlistManager.userDataPlist.getValues()?["calendarURL"] as? String,
            let url = URL(string: urlString) {
            self.loadImage(url)
        }
        
        
        HFBaseRequest.fire("/api/calendar", succesBlock: { (request, resultDic) in
            if let urlString = resultDic["data"] as? String,  let url = URL(string:urlString) {
                PlistManager.userDataPlist.saveValues(["calendarURL":urlString])
                self.loadImage(url)
            }
        }) { (request, error) in
            hud.showError(error)
        }
    }
    
    func loadImage(_ url: URL) {
        self.imageView.loadImage(withURL: url, allowResize: false) {
            self.loadingView.hide()
        }
    }
    
    
    fileprivate func initUI() {
        imageWidth.constant   = ScreenWidth
        imageHeight.constant  = ScreenHeight - NavbarHeight
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.placeHolder = UIImage(named: "hf_cover_placeholder")
        imageView.backgroundColor = UIColor.clear
        
        loadingView = HFLoadingView()
        self.view.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(NavbarHeight, 0, 0, 0))
        }
    }
}

extension HFInfoCalendarVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
