//
//  HFMineInfoVC.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/23.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Qiniu
import YYImage

class HFMineInfoVC: HFBaseViewController {
  var parser = HFNewParserViewModel()
  
  @IBOutlet weak var tableView: UITableView!
  
  fileprivate var newImage: UIImage?
  
  var infoCellValues:[[HFMineInfoInfoCellModel]] = []
  let picker = HFImagePicker()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareCells()
    tableView.backgroundColor = HFTheme.BlackAreaColor
    NotificationCenter.default.addObserver(self, selector: #selector(onUserDataUpdate), name: NSNotification.Name(rawValue: HFNotification.UserInfoUpdate.rawValue), object: nil)
  }
  
  func prepareCells() {
    if let user = DataEnv.user {
      infoCellValues = [
        [
          HFMineInfoInfoCellModel("头像",nil,"",true),
          ],
        [
          HFMineInfoInfoCellModel("教务系统",user.status_jwxt,"",true),
          HFMineInfoInfoCellModel("新教务系统",user.status_new_jwxt,"",true),
          HFMineInfoInfoCellModel("信息门户",user.status_xxmh,"",true)
        ],
        [
          HFMineInfoInfoCellModel("学号",nil,user.sid,false),
          HFMineInfoInfoCellModel("姓名",nil,user.name,false),
          HFMineInfoInfoCellModel("学院",nil,user.college,false),
          HFMineInfoInfoCellModel("专业",nil,user.major,false),
          HFMineInfoInfoCellModel("邮箱",nil,user.email,true),
          HFMineInfoInfoCellModel("修改密码",nil,"",true),
          ]
      ]
    }
  }
  
  @objc fileprivate func onUserDataUpdate() {
    prepareCells()
    tableView.reloadData()
  }
  
  fileprivate func onSelectImageButtonPressed() {
    picker.delegate = self
    picker.showActionSheet(vc: self)
  }
  
  fileprivate func uploadImageFileToQiniu(withToken token:String) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    let upManager = QNUploadManager()
    let fileName  = Utilities.getJpgFileName()
    let key       = "icon/" + fileName
    let data      = UIImageJPEGRepresentation(newImage!, 1)
    
    upManager?.put(data, key: key, token: token, complete: { (response, name, info) in
      if response?.statusCode == 200 {
        let request = HFUserInfoChangeRequest()
        request.callback = self
        request.updateImage(image: fileName)
        AnalyseManager.ChangePhoto.record()
      } else {
        hud.showError("上传失败，请重试")
      }
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }, option: nil)
    
  }
}

extension HFMineInfoVC: HFTextFieldAlertControllerDelegate {
  func alertControllerDidConrim(_ alertController: HFTextFieldAlertController, withText text: String) {
    let request = HFMineInfoBindRequest()
    request.callback = self
    switch alertController.type {
    case .bindJWXT:
      request.bindWithData(1, password: text)
      AnalyseManager.BindJWXT.record()
    case .bindNewJW:
      self.parser.login(id: DataEnv.user!.sid, pass: text)
        .then { json -> Void in
          print(json)
          if json["result"].boolValue {
            PlistManager.userDataPlist.save(["newPwdIMS": text])
            hud.showMassage("绑定成功")
            self.tableView.reloadData()
          } else {
            HFToast.showError(json["message"].stringValue)
          }
        }.catch { error in
          HFToast.showError("密码错误，请重试")
      }
      
    case .bindXXMH:
      request.bindWithData(0, password: text)
      AnalyseManager.BindXXMH.record()
    case .email:
      let updateEmailRequest = HFUserInfoChangeRequest()
      updateEmailRequest.tag = 0
      updateEmailRequest.callback = self
      updateEmailRequest.updateEmail(email: text)
      AnalyseManager.BindMail.record()
    }
  }
}

extension HFMineInfoVC: HFBaseAPIManagerCallBack {
  func managerApiCallBackFailed(_ manager: HFBaseAPIManager) {
    hud.showError(manager.errorInfo)
  }
  
  func managerApiCallBackSuccess(_ manager: HFBaseAPIManager) {
    if manager is HFMineInfoBindRequest {
      hud.showMassage("绑定成功")
      DataEnv.updateUserInfo()
    }
    
    if manager is HFUserInfoChangeRequest {
      hud.showMassage("修改成功")
      DataEnv.updateUserInfo()
    }
    
    if manager is HFGetQiniuTokenRequest {
      if let token = manager.resultDic[JSONDataKey] as? String {
        self.uploadImageFileToQiniu(withToken: token)
      }
    }
    
    
  }
}

extension HFMineInfoVC: HFImagePickerDelegate {
  func imagePickerDidCancel() {
    
  }
  
  func imagePickerDidGetCroppedImage(image: UIImage) {
    let image = image.yy_imageByResize(to: CGSize(width: 200, height: 200))!
    hud.showLoading("正在上传头像")
    newImage = image
    let request = HFGetQiniuTokenRequest()
    request.callback = self
    request.loadData()
  }
}

//extension HFMineInfoVC: STPhotoKitDelegate {
//    func photoKitController(_ photoKitController: STPhotoKitController, resultImage: UIImage) {
//        hud.showLoading("正在上传头像")
//        newImage = resultImage
//        let request = HFGetQiniuTokenRequest()
//        request.callback = self
//        request.loadData()
//    }
//}

//extension HFMineInfoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        picker.dismiss(animated: true) {
//            let imageOriginal = info[UIImagePickerControllerOriginalImage] as! UIImage
//            let photoVC = STPhotoKitController()
//            photoVC.delegate = self
//            photoVC.imageOriginal = imageOriginal
//            photoVC.sizeClip = CGSize(width: 200, height: 200)
//            self.present(photoVC, animated: true, completion: nil)
//        }
//    }
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//}

extension HFMineInfoVC: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return infoCellValues.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    } else {
      return infoCellValues[section].count
    }
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: HFMineInfoAvatarTableViewCell.identifier, for: indexPath) as! HFMineInfoAvatarTableViewCell
      cell.avatarImageView.loadAvatar(avatar: DataEnv.user?.image)
      cell.selectionStyle = .none
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: HFMineInfoInfoTableViewCell.identifier, for: indexPath) as! HFMineInfoInfoTableViewCell
      let model = infoCellValues[indexPath.section][indexPath.row]
      let isLast = infoCellValues[indexPath.section].count == indexPath.row + 1
      cell.setupCellWithCellModel(model, isLast: isLast)
      cell.selectionStyle = .none
      return cell
    }
  }
}

extension HFMineInfoVC: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch (indexPath.section,indexPath.row) {
    // 点击头像
    case (0,_):
      onSelectImageButtonPressed()
    // 点击绑定
    case (1,_):
      var title   = ""
      var message = ""
      if indexPath.row == 0 {
        title = DataEnv.user!.status_jwxt ? "修改密码" : "绑定"
        message = "请输入教务系统密码"
      } else if indexPath.row == 1 {
        title = DataEnv.user!.status_new_jwxt ? "修改密码" : "绑定"
        message = "请输入新教务系统密码"
      } else {
        title = DataEnv.user!.status_xxmh ? "修改密码" : "绑定"
        message = "请输入信息门户密码"
      }
      let alertController = HFTextFieldAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
      alertController.delegate = self
      switch indexPath.row {
      case 0:
        alertController.type = HFTextFieldAlertType.bindJWXT
      case 1:
        alertController.type = HFTextFieldAlertType.bindNewJW
      default:
        alertController.type = HFTextFieldAlertType.bindXXMH
      }
      
      alertController.addConrimButtonAndTextField(confermTitle: "确认")
      self.present(alertController, animated: true, completion: nil)
    // 点击修改邮箱
    case (2,4):
      let alertController = HFTextFieldAlertController(title: "修改邮箱", message: nil, preferredStyle: UIAlertControllerStyle.alert)
      alertController.delegate = self
      alertController.type = HFTextFieldAlertType.email
      alertController.addConrimButtonAndTextField(confermTitle: "确认")
      self.present(alertController, animated: true, completion: nil)
      
    case (2,5):
      let vc = HFMineChangePasswordVC()
      self.push(vc)
      
    default:
      break
    }
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 {
      return HFMineInfoAvatarTableViewCell.height
    } else {
      return HFMineInfoInfoTableViewCell.height
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 40
    }
    return 20
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
      return "设置头像"
    } else if section == 1 {
      return "账号绑定"
    } else  {
      return "个人信息"
    }
  }
}
