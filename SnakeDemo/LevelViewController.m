//
//  LevelViewController.m
//  SnakeDemo
//
//  Created by shenhongbang on 16/7/27.
//  Copyright © 2016年 中移(杭州)信息技术有限公司. All rights reserved.
//

#import "LevelViewController.h"
#import "GameViewController.h"



@interface LevelViewController ()


@end

@implementation LevelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self create:@"简单"
          action:@selector(easy)
               y:200];
    [self create:@"正常"
          action:@selector(nomal)
               y:300];
    [self create:@"困难"
          action:@selector(hard)
               y:400];
}

- (void)easy
{
    GameViewController *game = [[GameViewController alloc] initWithMixTime:0.4];
    [self presentViewController:game
                       animated:true
                     completion:nil];
}

- (void)nomal
{
    GameViewController *game = [[GameViewController alloc] initWithMixTime:0.2];
    [self presentViewController:game
                       animated:true
                     completion:nil];
}

- (void)hard
{
    GameViewController *game = [[GameViewController alloc] initWithMixTime:0.1];
    [self presentViewController:game
                       animated:true
                     completion:nil];
}

- (UIButton *)create:(NSString *)title action:(SEL)action y:(CGFloat)y
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title
         forState:UIControlStateNormal];
    [btn addTarget:self
               action:action
     forControlEvents:UIControlEventTouchUpInside];
//    [btn sizeToFit];
    btn.bounds          = CGRectMake(0, 0, 200, 50);
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitleColor:[UIColor whiteColor]
              forState:UIControlStateNormal];
    btn.titleLabel.font    = [UIFont boldSystemFontOfSize:22];
    btn.layer.cornerRadius = 10;
    btn.center             = CGPointMake(CGRectGetWidth(self.view.frame) / 2., y);
    [self.view
     addSubview:btn];
    return btn;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
   #pragma mark - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   }
 */

@end
