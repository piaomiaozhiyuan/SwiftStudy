//
//  MyAlertCenter.h
//  HelloSDL
//
//  Created by gaolele on 2017/4/13.
//  Copyright © 2017年 Ford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyAlertCenter : NSObject

+(void) addToastWithString:(NSString *)string inView:(UIView *)view;
+(void) removeToastWithView:(NSTimer *)timer;
+(UIViewController *)getPresentedViewController;

@end
