//
//  GameViewController.m
//  SnakeDemo
//
//  Created by shenhongbang on 16/7/28.
//  Copyright © 2016年 中移(杭州)信息技术有限公司. All rights reserved.
//

#import "GameViewController.h"


typedef NS_ENUM(NSInteger, DirectionType) {
    DirectionTypeTop,
    DirectionTypeLeft,
    DirectionTypeBottom,
    DirectionTypeRigth,
};

CGFloat CW = 10;

@interface GameViewController ()

@property (nonatomic, strong) NSTimer   *timer;


@property (nonatomic, strong) NSMutableArray<UIView *>    *views;


@end

@implementation GameViewController{
    
    UIView          *_backView;
    
    
    CGFloat         _minTime;
    
    
    UIButton        *_topBtn;
    UIButton        *_leftBtn;
    UIButton        *_bottomBtn;
    UIButton        *_rightBtn;
    UIButton        *_resetBtn;
    UIButton        *_pauseBtn;
    
    DirectionType   _direction;
    
//    NSMutableArray<UIView *>  *self.views;
    
    UIView          *_tempView;
    UIView          *_tempView2;
    
    
    UILabel         *_score;
}

- (instancetype)initWithMixTime:(CGFloat)minTime {
    self = [super init];
    if (self) {
        _minTime = minTime == 0 ? 0.3 : minTime;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _direction = DirectionTypeRigth;
    self.views = [NSMutableArray arrayWithCapacity:0];
    
    
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    
    CGFloat bh = 400;
    
    NSInteger wCount = width / CW;
    
    CGFloat x = (width - wCount * CW) / 2.;
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(x, 20, wCount * CW, bh)];
    _backView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_backView];
    
    
    CGFloat space = 80;
    
    _topBtn = [self create:@"上" action:@selector(clickedDirectionBtn:) center:CGPointMake(width / 2., bh + 60)];
    _leftBtn = [self create:@"左" action:@selector(clickedDirectionBtn:) center:CGPointMake(space, bh + 110)];
    _rightBtn = [self create:@"右" action:@selector(clickedDirectionBtn:) center:CGPointMake(width - space, bh + 110)];
    _bottomBtn = [self create:@"下" action:@selector(clickedDirectionBtn:) center:CGPointMake(width / 2., bh + 160)];
    
    
    _topBtn.frame = CGRectMake(width / 3., CGRectGetMaxY(_backView.frame), width / 3., 60);
    _leftBtn.frame = CGRectMake(0, CGRectGetMaxY(_topBtn.frame), width / 3., 60);
    _rightBtn.frame = CGRectMake(width * 2 / 3., CGRectGetMinY(_leftBtn.frame), width / 3., 60);
    _bottomBtn.frame = CGRectMake(width / 3., CGRectGetMaxY(_leftBtn.frame), width / 3., 60);
    
    _topBtn.tag = 1000;
    _leftBtn.tag = 1001;
    _bottomBtn.tag = 1002;
    _rightBtn.tag = 1003;
    
    _resetBtn = [self create:@"重置" action:@selector(reset) center:CGPointMake(50, height - 20)];
    _pauseBtn = [self create:@"pause" action:@selector(pause) center:CGPointMake(width - 50, height - 20)];
    [_pauseBtn setTitle: _timer == nil ? @"开始" : @"暂停" forState:UIControlStateNormal];
    [_pauseBtn setTitle:@"继续" forState:UIControlStateSelected];
    
    [self create:@"水平" action:@selector(chooseLevel) center:CGPointMake(width / 2., height - 20)];
    
    UIFont *font = [UIFont systemFontOfSize:12];
    
    _score = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_backView.frame) + 10, width / 3. - 10, font.lineHeight)];
    _score.textColor = [UIColor grayColor];
    _score.font = font;
    _score.text = @"分数：0";
    [self.view addSubview:_score];
    
    
    [self reset];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appInBack:) name:@"IAMINBACK" object:nil];
    
}

- (void)appInBack:(NSNotification *)noti {
    [self pause];
}


- (void)clickedDirectionBtn:(UIButton *)btn {
    
    switch (btn.tag) {
        case 1000: {    //上
            if (_direction == DirectionTypeBottom) {
                return;
            }
            _direction = DirectionTypeTop;
            break;
        }
        case 1001: {    // 左
            if (_direction == DirectionTypeRigth) {
                return;
            }
            _direction = DirectionTypeLeft;
            break;
        }
        case 1002: {    // 下
            if (_direction == DirectionTypeTop) {
                return;
            }
            _direction = DirectionTypeBottom;
            break;
        }
        case 1003: {    // 右
            if (_direction == DirectionTypeLeft) {
                return;
            }
            _direction = DirectionTypeRigth;
            break;
        }
        default:
            break;
    }
    
    _timer = self.timer;
    [_pauseBtn setTitle: _timer == nil ? @"开始" : @"暂停" forState:UIControlStateNormal];
    _pauseBtn.selected = false;

    
}


- (void)reset {
    
    [_timer invalidate];
    _timer = nil;
    _direction = DirectionTypeRigth;
    [_pauseBtn setTitle: _timer == nil ? @"开始" : @"暂停" forState:UIControlStateNormal];
    _score.text = @"分数：0";
    [self.views removeAllObjects];
    _tempView = nil;
    
    for (UIView *view in _backView.subviews) {
        [view removeFromSuperview];
    }
    
    _pauseBtn.selected = false;
    
    
    for (int i = 0; i < 2; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(CW * 2 - i * CW, 0, CW, CW)];
        view.backgroundColor = [UIColor greenColor];
        [_backView addSubview:view];
        [self.views addObject:view];
    }
}

- (void)pause {
    
    if (_timer == nil) {
        _timer = self.timer;
    } else {
        
        [_timer invalidate];
        _timer = nil;
    }
    
    
    [_pauseBtn setTitle: _timer == nil ? @"开始" : @"暂停" forState:UIControlStateNormal];
    
    _pauseBtn.selected = !_pauseBtn.selected;
}

- (void)chooseLevel {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)oneSeconds {
    
    CGRect firstFrame = CGRectZero;
    UIView *view = self.views[0];
    CGFloat x = CGRectGetMinX(view.frame);
    CGFloat y = CGRectGetMinY(view.frame);
    _score.text = [NSString stringWithFormat:@"分数：%lu", ((unsigned long)_views.count - 2) * 10];
    
    switch (_direction) {
        case DirectionTypeTop: {
            firstFrame = CGRectMake(x, y - CW, CW, CW);
            
            break;
        }
        case DirectionTypeLeft: {
            firstFrame = CGRectMake(x - CW, y, CW, CW);
            break;
        }
        case DirectionTypeBottom: {
            firstFrame = CGRectMake(x, y + CW, CW, CW);
            break;
        }
        case DirectionTypeRigth: {
            firstFrame = CGRectMake(x + CW, y, CW, CW);
            break;
        }
    }
    
    if (!CGRectIntersectsRect(firstFrame, _backView.bounds) || [self frameIsInSnake:firstFrame]) {
        [_timer invalidate];
        _timer = nil;
        
        __weak typeof(self) SHB = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你挂了。。。" message:_score.text preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [SHB reset];
        }]];
        [self presentViewController:alert animated:true completion:nil];
        
        
        return;
    }
    
    
    //生成随机块
    if (_tempView == nil || [self frameIsInSnake:_tempView.frame] ) {
        if (_tempView != nil) {
            _tempView2 = _tempView;
            [_tempView removeFromSuperview];
            _tempView = nil;
        }
        
        _tempView = [[UIView alloc] initWithFrame:CGRectZero];
        _tempView.backgroundColor = [UIColor greenColor];
        [_backView addSubview:_tempView];
        
        BOOL flag = true;
        
        CGRect ttFrame = CGRectZero;
        
        while (flag) {
            NSInteger wCount = CGRectGetWidth(_backView.frame) / CW;
            NSInteger hCount = CGRectGetHeight(_backView.frame) / CW;
            
            CGFloat x = arc4random() % wCount * CW;
            CGFloat y = arc4random() % hCount * CW;
            
            ttFrame = CGRectMake(x, y, CW, CW);
            flag = [self frameIsInSnake:ttFrame];
        }
        
        _tempView.frame = ttFrame;
        
    }
    
    
    // 往前跑
    __block CGRect nextFrame = view.frame;
    
    [UIView beginAnimations:@"aa" context:nil];
    [UIView setAnimationDuration:_minTime];
    [self.views enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        
        
        if (idx == 0) {
            obj.frame = firstFrame;
        } else {
            CGRect tempRect = obj.frame;
            obj.frame = nextFrame;
            nextFrame = tempRect;
            if (idx == self.views.count - 1 && CGRectEqualToRect(_tempView2.frame, nextFrame)) {
                UIView *view = [[UIView alloc] initWithFrame:nextFrame];
                view.backgroundColor = [UIColor greenColor];
                [_backView addSubview:view];
                [self.views addObject:view];
                [_tempView2 removeFromSuperview];
                _tempView2 = nil;
                *stop = true;
            }
        }
    }];
    [UIView commitAnimations];
}

- (BOOL)frameIsInSnake:(CGRect)frame {
    
    NSArray *array = [self.views valueForKeyPath:@"@unionOfObjects.frame"];
    NSValue *tempValue = [NSValue valueWithCGRect:frame];
    
    return [array containsObject:tempValue];
}

- (UIButton *)create:(NSString *)title action:(SEL)action center:(CGPoint)center {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    //    [btn sizeToFit];
    btn.bounds = CGRectMake(0, 0, 70, 40);
    btn.center = center;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor grayColor];
    [self.view addSubview:btn];
    return btn;
}


- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_minTime target:self selector:@selector(oneSeconds) userInfo:nil repeats:true];
        
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        
    }
    return _timer;
}


- (void)didReceiveMemoryWarning {
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
