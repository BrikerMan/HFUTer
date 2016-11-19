//
//  HFMineVC.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/16.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFMineVC: HFBasicViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var actionList:[[HFMineListCellInfo]] = []
    
    var shouldShowBandge = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if DataEnv.allowDonate {
            actionList = [
                [
                    HFMineListCellInfo("个人信息","fm_mine_geren",""),
                    HFMineListCellInfo("我的发布","fm_mine_publish",""),
                    HFMineListCellInfo("我的消息","fm_mine_message","")
                ],
                [
                    HFMineListCellInfo("设置","fm_mine_setting",""),
                    HFMineListCellInfo("打赏作者","fm_mine_donate",""),
                    HFMineListCellInfo("关于","fm_mine_about",""),
                ]
            ]
        } else {
            actionList = [
                [
                    HFMineListCellInfo("个人信息","fm_mine_geren",""),
                    HFMineListCellInfo("我的发布","fm_mine_publish",""),
                    HFMineListCellInfo("我的消息","fm_mine_message","")
                ],
                [
                    HFMineListCellInfo("设置","fm_mine_setting",""),
                    HFMineListCellInfo("关于","fm_mine_about",""),
                ]
            ]
        }
        
        
        shouldShowBandge = UIApplication.shared.applicationIconBadgeNumber != 0
        
        automaticallyAdjustsScrollViewInsets = false
        tableView.backgroundColor = HFTheme.BlackAreaColor
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateViewData), name: NSNotification.Name(rawValue: HFNotification.UserLogin.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateViewData), name: NSNotification.Name(rawValue: HFNotification.UserInfoUpdate.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showBundge), name: NSNotification.Name(rawValue: HFNotification.ReceiveRemoteNotif.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.clearBundge), name: NSNotification.Name(rawValue: HFNotification.RemoveBundge.rawValue), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let destinationVC = segue.destination
        destinationVC.hidesBottomBarWhenPushed = true
    }
    
    func showBundge() {
        shouldShowBandge = true
        tableView.reloadData()
    }
    
    func clearBundge() {
        shouldShowBandge = false
        tableView.reloadData()
    }
    
    func updateViewData() {
        tableView.reloadData()
    }
}

extension HFMineVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0,3:
            return 1
        case 1:
            return 3
        case 2:
            return DataEnv.allowDonate ? 3 : 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: HFMineHeaderTableViewCell.identifer, for: indexPath) as! HFMineHeaderTableViewCell
            cell.selectionStyle = .none
            if let model = DataEnv.user {
                cell.setupWithModel(model)
            }
            return cell
        case 1,2:
            let cell = tableView.dequeueReusableCell(withIdentifier: HFMineListTableViewCell.identifer, for: indexPath) as! HFMineListTableViewCell
            cell.selectionStyle = .none
            let model  = actionList[indexPath.section-1][indexPath.row]
            let isLast = actionList[indexPath.section-1].count == indexPath.row + 1
            cell.setupCellWithStruct(model, isLast: isLast)
            if indexPath.row == 2 && shouldShowBandge && indexPath.section == 1 {
                cell.hubView.isHidden = false
            } else {
                cell.hubView.isHidden = true
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: HFMineListActionTableViewCell.identifer, for: indexPath) as! HFMineListActionTableViewCell
            cell.selectionStyle = .none
            cell.titleLabel.text = "退出登录"
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension HFMineVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: HFMineSegue.PushInfoVC.rawValue, sender: nil)
            case 1:
                self.performSegue(withIdentifier: HFMineSegue.PushMyPublishVC.rawValue, sender: nil)
            case 2:
                self.performSegue(withIdentifier: HFMineSegue.PushMyMessageVC.rawValue, sender: nil)
            default:
                self.performSegue(withIdentifier: HFMineSegue.PushInfoVC.rawValue, sender: nil)
            }
            
        case 2:
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: HFMineSegue.PushSettingVC.rawValue, sender: nil)
            case 1:
                if DataEnv.allowDonate {
                    self.performSegue(withIdentifier: "HFMinePushDonateSegue", sender: nil)
                } else {
                    self.performSegue(withIdentifier: "HFMinePushAboutSegue", sender: nil)
                }
            case 2:
                self.performSegue(withIdentifier: "HFMinePushAboutSegue", sender: nil)
            default:
                self.performSegue(withIdentifier: "HFMinePushAboutSegue", sender: nil)
            }
            
        case 3:
            DataEnv.handleLogout()
            AnalyseManager.Logout.record()
            
        default:
            print(indexPath)
            self.performSegue(withIdentifier: "HFMineSeguePushSettingVC", sender: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return HFMineHeaderTableViewCell.height
        } else {
            return HFMineListTableViewCell.height
        }
    }
}
