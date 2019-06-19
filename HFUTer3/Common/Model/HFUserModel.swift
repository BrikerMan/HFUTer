//
//  HFUserModel.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/16.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation
import YYModel

class HFUserModel: HFBaseModel {
  /// id
  @objc var id = 0
  /// 学号
  @objc var sid = ""
  /// 性别
  @objc var sex = ""
  /// 邮箱
  @objc var email = ""
  /// 姓名
  @objc var name = ""
  /// 头像
  @objc var image = ""
  /// 学院
  @objc var college = ""
  /// 专业
  @objc var major = ""
  /// 是否为宣城校区
  @objc var xc = false
  /// 是否绑定了信息门户
  @objc var status_jwxt = false
  /// 是否绑定了教务系统
  @objc var status_xxmh = false
  /// 是否绑定了新教务系统
  @objc var status_new_ims = false
  /// 密码
  @objc var password = ""
  
  func save() {
    let dic = self.yy_modelToJSONObject() as! NSDictionary
    let data = [PlistKey.UserData.rawValue:dic]
    PlistManager.userDataPlist.saveValues(data)
  }
  
  
  class func read() -> HFUserModel? {
    if let data = PlistManager.userDataPlist.getValues(), let json = data[PlistKey.UserData.rawValue] as? NSDictionary {
      let model = HFUserModel.yy_model(withJSON: json)
      return model
    }
    return nil
  }
  
}
