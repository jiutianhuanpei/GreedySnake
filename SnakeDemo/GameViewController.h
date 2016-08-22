//
//  GameViewController.h
//  SnakeDemo
//
//  Created by shenhongbang on 16/7/28.
//  Copyright © 2016年 中移(杭州)信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController



- (instancetype)initWithMixTime:(CGFloat)minTime;

- (void)pause;

@end
