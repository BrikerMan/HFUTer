//
//  HFScheduleTimePicker.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/4/27.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFScheduleTimePicker: HFXibView {
    @IBOutlet weak var pickerView       : UIPickerView!
    @IBOutlet weak var backImageView    : UIImageView!
    @IBOutlet weak var bottomConstraint : NSLayoutConstraint!
    
    var finishedBlock: ((Int, Int, Int) -> Void)?
    
    @IBAction func onDoneButtonPressed(_ sender: Any) {
        
        

        tappedBack()
    }
    
    override func initFromXib() {
        super.initFromXib()
        bottomConstraint.constant = -250
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedBack))
        backImageView.addGestureRecognizer(tap)
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    
    @objc func tappedBack() {
        let duration = pickerView.selectedRow(inComponent: 2) - pickerView.selectedRow(inComponent: 1) + 1
        if duration < 1 {
            Hud.showError("请选择正确时间")
            return
        }
        
        finishedBlock?(
            pickerView.selectedRow(inComponent: 0),
            pickerView.selectedRow(inComponent: 1),
            duration
        )
        
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.bottomConstraint.constant = -250
            self.layoutIfNeeded()
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    func add(to: UIView) {
        to.addSubview(self)
        self.snp.makeConstraints {
            $0.edges.equalTo(to)
        }
        show()
    }
    
    
    func show() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0)
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            self.bottomConstraint.constant = 0
            self.layoutIfNeeded()
        }) { (_) in
            
        }
    }
    
    func setup(day: Int, hour: Int, duration: Int) {
        pickerView.selectRow(day , inComponent: 0, animated: true)
        pickerView.selectRow(hour , inComponent: 1, animated: true)
        pickerView.selectRow(hour + duration - 1 , inComponent: 2, animated: true)
    }
}


extension HFScheduleTimePicker: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 7
        case 1, 2:
            return 11
        default:
            return 0
        }
    }
}

extension HFScheduleTimePicker: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return k.dayNames[row]
        case 1, 2:
            return (row + 1).description
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 1 || component == 2 {
            if pickerView.selectedRow(inComponent: 2) < pickerView.selectedRow(inComponent: 1) {
                pickerView.selectRow(pickerView.selectedRow(inComponent: 1) , inComponent: 2, animated: true)
            }
        }
    }
}
