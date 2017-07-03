//
//  PMScrollView.m
//  SwiftStudyAndAccumulation
//
//  Created by wangzhen on 2017/6/5.
//  Copyright © 2017年 mapbar. All rights reserved.
//

#import "PMScrollView.h"

@implementation PMScrollView

- (void)setContentOffset:(CGPoint)contentOffset {
    contentOffset = contentOffset;
    NSLog(@"contentOffset:%@",NSStringFromCGPoint(contentOffset));
}








/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
