//
//  BaseViewController.m
//  SwiftStudyAndAccumulation
//
//  Created by wangzhen on 2017/4/7.
//  Copyright © 2017年 mapbar. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
{
    dispatch_source_t _timer;
    NSRunLoopMode _currentMode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"1111",@"SmartautoTech", nil];
    NSString *str = [NSString stringWithFormat:@"%@",dic];
    NSLog(@"str:%@",str);
    
    NSTimeInterval period = 1.0/60; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        //在这里执行事件
        // 主线程执行：
        if (_currentMode != [NSRunLoop mainRunLoop].currentMode) {
            NSLog(@"runloop的Mode：%@",[NSRunLoop mainRunLoop].currentMode);
            _currentMode = [NSRunLoop mainRunLoop].currentMode;
        }
//        NSLog(@"当前runloop的Mode：%@",[NSRunLoop currentRunLoop].currentMode);
//        NSLog(@"runloop的Mode：%@",[NSRunLoop mainRunLoop].currentMode);
    });
    
    dispatch_resume(_timer);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(UIViewController *)getPresentedViewController {
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//#pragma mark - CXCallObserverDelegate
//
//- (void)callObserver:(CXCallObserver *)callObserver callChanged:(CXCall *)call {
//    
//    if (call == nil || call.hasEnded == YES) {
//        NSLog(@"CXCallState : Disconnected");
//        self.callState = CallState_Disconnected;
//        
//    } else {
//        if (call.isOutgoing == YES && call.hasConnected == NO) {
//            NSLog(@"CXCallState : Dialing");
//            self.callState = CallState_Dialing;
//        }
//        
//        if (call.isOutgoing == NO && call.hasConnected == NO && call.hasEnded == NO && call != nil) {
//            NSLog(@"CXCallState : Incoming");
//            self.callState = CallState_Incoming;
//            [MBProxyManager sharedManager].callIncomed = YES;
//        }
//        
//        if (call.hasConnected == YES && call.hasEnded == NO) {
//            NSLog(@"CXCallState : Connected");
//            self.callState = CallState_Connected;
//        }
//    }
//    
//    if ([self canSendWhenCall] == YES) {
//        // 取消静音
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[MBNaviSession sharedInstance] setEnableSound:YES];
//        });
//    } else {
//        // 静音
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[MBNaviSession sharedInstance] setEnableSound:NO];
//        });
//    }
//}

@end
