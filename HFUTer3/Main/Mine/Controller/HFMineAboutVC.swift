//
//  HFMineAboutVC.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/6.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFMineAboutVC: HFBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellTitles = ["帮助","关于我们","隐私条款","反馈"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "关于"
        tableView.tableFooterView = UIView()
        
        AnalyseManager.SeeAbout.record()
    }
}

extension HFMineAboutVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "aboutHeaderCell")
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "aboutDataListCell") as! HFMineListInfoTableViewCell
            cell.setup(cellTitles[indexPath.row], isLast: indexPath.row == 2)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 3
        }
    }
}

extension HFMineAboutVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 3 {
                let vc = HFMineRepostViewController()
                self.push(vc)
            } else {
                let vc = HFHelpInfoWebVC(nibName: "HFHelpInfoWebVC",bundle: nil)
                if indexPath.row == 0 {
                    vc.type = HFHelpInfoWebType.Help
                } else if indexPath.row == 1 {
                    vc.type = HFHelpInfoWebType.About
                } else {
                    vc.type = HFHelpInfoWebType.Privacy
                }
                self.push(vc)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        } else {
            return 10
        }
    }
}
