#import "MyAlertCenter.h"

//尺寸设置
#define aiScreenWidth [UIScreen mainScreen].bounds.size.width
#define aiScreenHeight [UIScreen mainScreen].bounds.size.height
#define STATUS_BAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAVIGATION_BAR_HEIGHT self.navigationController.navigationBar.frame.size.height
#define TAB_BAR_HEIGHT self.tabBarController.tabBar.frame.size.height

@interface MyAlertCenter ()

@end

@implementation MyAlertCenter

+ (void)addToastWithString:(NSString *)string inView:(UIView *)view {
    
    CGRect initRect = CGRectMake(0, STATUS_BAR_HEIGHT + 44, aiScreenWidth, 0);
    CGRect rect = CGRectMake(0, STATUS_BAR_HEIGHT + 44, aiScreenWidth, 22);
    UILabel* label = [[UILabel alloc] initWithFrame:initRect];
    label.text = string;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor colorWithRed:0 green:0.6 blue:0.9 alpha:0.6];
    
    [view addSubview:label];
    
    //弹出label
    [UIView animateWithDuration:0.5 animations:^{
        
        label.frame = rect;
        
    } completion:^ (BOOL finished){
        //弹出后持续5s
        // 只是调试用的
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(removeToastWithView:) userInfo:label repeats:NO];
    }];
}

+ (void)removeToastWithView:(NSTimer *)timer {
    
    UILabel* label = [timer userInfo];
    
    CGRect initRect = CGRectMake(0, STATUS_BAR_HEIGHT + 44, aiScreenWidth, 0);
    //    label消失
    [UIView animateWithDuration:0.5 animations:^{
        
        label.frame = initRect;
    } completion:^(BOOL finished){
        
        [label removeFromSuperview];
        [timer invalidate];
    }];
}

+ (UIViewController *)getPresentedViewController {
    
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}

@end
