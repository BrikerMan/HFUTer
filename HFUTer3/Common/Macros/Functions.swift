//
//  Functions.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/16.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

//延迟函数
func delay(seconds: Double, completion:@escaping ()->()) {
    let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
    
    DispatchQueue.main.asyncAfter(deadline: popTime) {
        completion()
    }
}

/**
 主线程运行
 
 - parameter block: 主线程运行的block部分
 */
func runOnMainThread(_ block:@escaping ()->()) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async {
            block()
        }
    }
}

/**
 后台线程运行
 
 - parameter block:  后台线程运行的block部分
 */
func runOnBackThread(_ block:@escaping ()->()) {
    DispatchQueue.global(qos: .background).async {
        block()
    }
}
