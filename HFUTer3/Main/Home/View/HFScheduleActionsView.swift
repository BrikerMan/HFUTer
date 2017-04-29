
//
//  HFScheduleActionsView.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/4/28.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit

protocol HFScheduleActionsViewDelegate: class {
    func actionsViewDidChooseAdd()
    func actionsViewDidChooseCustomBack()
    func actionsViewDidChooseShare()
}

class HFScheduleActionsView: HFXibView {
    
    weak var delegate: HFScheduleActionsViewDelegate?
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var containerView      : UIView!
    @IBOutlet weak var weekEndSwitch      : UISwitch!
    @IBOutlet weak var shceduleDateSwitch : UISwitch!
    @IBOutlet weak var roundStyleSwitch   : UISwitch!
    
    @IBOutlet weak var alphaSegment : UISegmentedControl!
    @IBOutlet weak var alphaValue   : UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gestureView: UIImageView!
    
    fileprivate var isShowing = false
    
    override func initFromXib() {
        super.initFromXib()
        self.clipsToBounds = true
        alphaSegment.isMomentary = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        gestureView.addGestureRecognizer(tap)
        
        weekEndSwitch.isOn = DataEnv.settings.weekendSchedule.value
        shceduleDateSwitch.isOn = DataEnv.settings.scheduleShowDayDate.value
        roundStyleSwitch.isOn   = DataEnv.settings.scheduleRoundStyle.value
        
        DataEnv.settings.scheduleCellAlpha.asObservable().subscribe(onNext: { [weak self] (element) in
            self?.alphaValue.text = String(format: "%.2f", element)
        }).addDisposableTo(disposeBag)
        
        DataEnv.settings.scheduleBackImage.asObservable().subscribe(onNext: { [weak self] (element) in
            if let image = element {
                self?.imageView.image = image
                self?.deleteButton.isHidden = false
            } else {
                self?.imageView.image = nil
                self?.deleteButton.isHidden = true
            }
        }).addDisposableTo(disposeBag)
    }
    
    func show() {
        if isShowing {
            hide()
            return
        }
        self.isHidden = false
        isShowing = true
        self.superview?.bringSubview(toFront: self)
        backgroundColor = UIColor.clear
        containerView.alpha = 0.0
        topConstraint.constant = -300
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            self.topConstraint.constant = 0
            self.containerView.alpha = 1.0
            self.layoutIfNeeded()
        }) { (_) in
            
        }
    }
    
    func hide() {
        isShowing = false
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = UIColor.clear
            self.topConstraint.constant = -300
            self.containerView.alpha = 0.0
            self.layoutIfNeeded()
        }) { (_) in
            self.isHidden = true
        }
    }
    
    @IBAction func onDelteBackImageButtonPressed(_ sender: Any) {
        DataEnv.settings.scheduleBackImage.value = nil
    }
    
    @IBAction func onCreateCourceButtonPressed(_ sender: Any) {
        delegate?.actionsViewDidChooseAdd()
    }
    
    @IBAction func onSegmentValueChanged(_ sender: UISegmentedControl) {
        var new = DataEnv.settings.scheduleCellAlpha.value
        if sender.selectedSegmentIndex == 0 {
            new -= 0.1
        } else {
            new += 0.1
        }
        
        if new < 0.1 {
            new = 0.1
        } else if new > 1.0 {
            new = 1.0
        } else {
            DataEnv.settings.scheduleCellAlpha.value = new
            DataEnv.settings.save()
        }
        
    }
    
    
    @IBAction func showWeekEndChanged(_ sender: UISwitch) {
        DataEnv.settings.weekendSchedule.value = sender.isOn
        DataEnv.settings.save()
    }
    
    
    @IBAction func showScheduleDateCHanged(_ sender: UISwitch) {
        DataEnv.settings.scheduleShowDayDate.value = sender.isOn
        DataEnv.settings.save()
    }
    
    @IBAction func showRoundStyleChanged(_ sender: UISwitch) {
        DataEnv.settings.scheduleRoundStyle.value = sender.isOn
        DataEnv.settings.save()
    }
    
    @IBAction func onCustomBackButtonPressed(_ sender: Any) {
        delegate?.actionsViewDidChooseCustomBack()
    }
    
    @IBAction func onShareButtonPressed(_ sender: Any) {
        delegate?.actionsViewDidChooseShare()
    }
}
