//
//  HF-Model-protocols.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/5/9.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import Foundation
import UIKit

/// 用于绑定可选变量的
/// 比如 a = 1 b = nil 则 a ??= b 后 a = 1
/// 比如 a = 1 b = 2   则 a ??= b 后 a = 2
infix operator ??= : ATPrecedence
precedencegroup ATPrecedence {
    associativity: left
    higherThan: AdditionPrecedence
    lowerThan: MultiplicationPrecedence
}

/// 如果 `rhs` 为 `nil`, 把 `lhs` 自身的值赋给它
func ??= <T>( lhs: inout T, rhs: T?) {
    lhs = rhs ?? lhs
}
