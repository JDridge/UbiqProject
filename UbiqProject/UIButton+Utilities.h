//
//  UIButton+Utilities.h
//  UbiqProject
//
//  Created by Robert Vo on 11/26/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Utilities)

+ (UIButton *)getGenericButton:(NSString *)title selectorActionName:(NSString *)selectorMethod;

@end
