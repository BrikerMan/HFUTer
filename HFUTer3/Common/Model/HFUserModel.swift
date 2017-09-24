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
  var id = 0
  /// 学号
  var sid = ""
  /// 性别
  var sex = ""
  /// 邮箱
  var email = ""
  /// 姓名
  var name = ""
  /// 头像
  var image = ""
  /// 学院
  var college = ""
  /// 专业
  var major = ""
  /// 是否为宣城校区
  var xc = false
  /// 是否绑定了信息门户
  var status_jwxt = false
  /// 是否绑定了教务系统
  var status_xxmh = false
  /// 密码
  var password = ""
  
  var status_new_jwxt: Bool {
    return {
      return PlistManager.userDataPlist.value["newPwdIMS"].string != nil
    }
  }
  
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
