//
//  HFTextFieldAlertController.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/23.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

enum HFTextFieldAlertType {
  case bindJWXT
  case bindXXMH
  case email
  case bindNewJW
}

protocol HFTextFieldAlertControllerDelegate :class{
  func alertControllerDidConrim( _ alertController: HFTextFieldAlertController, withText text:String)
}

class HFTextFieldAlertController: UIAlertController {
  
  var type = HFTextFieldAlertType.bindJWXT
  
  weak var delegate: HFTextFieldAlertControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(HFTextFieldAlertController.onTextFieldTextChanged(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func addConrimButtonAndTextField(confermTitle title:String) {
    self.addAction(UIAlertAction(title: "取消", style: .cancel , handler: nil))
    self.addAction(UIAlertAction(title: title, style: .default, handler: { (acction) -> Void in
      self.perform(#selector(HFTextFieldAlertController.didPressOnConfrimButton))
    }))
    actions[1].isEnabled = false
    self.addTextField { (textField) in
      
    }
  }
  
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
  }
  
  @objc fileprivate func didPressOnConfrimButton() {
    delegate?.alertControllerDidConrim(self, withText: textFields!.first!.text!)
  }
  
  @objc fileprivate func onTextFieldTextChanged(_ sender:AnyObject) {
    let text = textFields!.first!.text!
    actions[1].isEnabled = !text.isBlank
  }
  
}
