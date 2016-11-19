//
//  HFHomeViewModel.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/16.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

class HFHomeViewModel {
    func prepareScheuldeModels(dic:[String:AnyObject]) {
        if let data = dic["data"] {
            do {
                let array = try JSONSerialization.jsonObject(with: (data.data(using: String.Encoding.utf8.rawValue)! as Data), options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [AnyObject]
                PlistManager.dataPlist.saveValues([PlistKey.ScheduleList.rawValue: array as AnyObject])
            } catch {
                return
            }
        }
    }
}
