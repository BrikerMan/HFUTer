//
//  YYLabel+Copyable.h
//  HFUTer3
//
//  Created by BrikerMan on 2017/1/31.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText/YYText.h>

/**
 A category to enable long press copy feature on UILabel.
 */
@interface YYLabel (Copyable)
    
    /**
     Set this property to YES in order to enable the copy feature. Defaults to NO.
     */
    @property (nonatomic) IBInspectable BOOL copyingEnabled;
    
    /**
     Used to enable/disable the internal long press gesture recognizer. Defaults to YES.
     */
    @property (nonatomic) IBInspectable BOOL shouldUseLongPressGestureRecognizer;
    
    @end
