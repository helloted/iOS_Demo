//
//  HTSlideBaseController.m
//  TSho
//
//  Created by iMac on 2017/9/16.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HTSlideBaseController.h"
#import "HTMainViewController.h"
#import "HTSlideSideBarController.h"
#import "UIView+HTExtention.h"

#define LEFTMENU_WIDTH 200
#define ContentViewX (LEFTMENU_WIDTH-2)

#define IPHONE_WIDTH         [UIScreen mainScreen].bounds.size.width
#define IPHONE_HEIGHT        [UIScreen mainScreen].bounds.size.height

#define kStatusHeight        20

@implementation UIViewController (HTSlideBase)

- (HTSlideBaseController *)slideVC{
    UIViewController *slidVC = self.parentViewController;
    while (slidVC) {
        if ([slidVC isKindOfClass:[HTSlideBaseController class]]) {
            return (HTSlideBaseController *)slidVC;
        } else if (slidVC.parentViewController && slidVC.parentViewController != slidVC) {
            slidVC = slidVC.parentViewController;
        } else {
            slidVC = nil;
        }
    }
    return nil;
}

@end


@interface HTSlideBaseController ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign)CGFloat                    lastX;
@property (nonatomic, strong)UINavigationController     *homeNav;
@property (nonatomic, strong)UIView                     *maskView;
@property (nonatomic, strong)HTSlideSideBarController   *sideBarVC;

@end

@implementation HTSlideBaseController


- (instancetype)init{
    if (self = [super init]) {
        HTMainViewController *homeVC = [[HTMainViewController alloc]init];
        _homeNav = [[UINavigationController alloc]initWithRootViewController:homeVC];
        [self addChildViewController:_homeNav];
        
        _sideBarVC  = [[HTSlideSideBarController alloc]init];
        [self addChildViewController:_sideBarVC];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lastX = 0;
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self.view addSubview:_sideBarVC.view];
    _sideBarVC.view.center = CGPointMake(-LEFTMENU_WIDTH/2,(IPHONE_HEIGHT + kStatusHeight)/2);
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanAction:)];
    [_sideBarVC.view addGestureRecognizer:pan];
    
    [self.view addSubview:_homeNav.view];
}


- (void)moveSideBar{
    [UIView beginAnimations:nil context:nil];
    if (_sideBarVC.view.frame.origin.x < 0 ) {//呼出侧边栏
        [_sideBarVC.view setX:0];
        [_homeNav.view setX:ContentViewX];
        [_homeNav.view addSubview:self.maskView];
        [_homeNav.view bringSubviewToFront:self.maskView];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ExhaledLeftMenuNotification" object:nil];
    }else{//缩回侧边栏
        [_sideBarVC.view setX:-LEFTMENU_WIDTH];
        [_homeNav.view setX:0];
        [_maskView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RetractLeftMenuNotification" object:nil];
    }
    [_homeNav.view endEditing:YES];
    [UIView commitAnimations];
}

- (void)clickItemPushToViewController:(UIViewController *)viewController{
    [self moveSideBar];
    [_homeNav pushViewController:viewController animated:YES];
}
- (void)pushToViewControllerNoMoveMenu:(UIViewController *)viewController{
    [_sideBarVC.view setX:-LEFTMENU_WIDTH];
    [_homeNav.view setX:0];
    [_maskView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RetractLeftMenuNotification" object:nil];
    
    [_homeNav pushViewController:viewController animated:YES];
}


- (void)handleTapAction:(UITapGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateEnded) {
        if (_sideBarVC.view.center.x > 0) {
            [UIView beginAnimations:nil context:nil];
            [_sideBarVC.view setX:-LEFTMENU_WIDTH];
            [_homeNav.view setX:0];
            [_maskView removeFromSuperview];
            [UIView commitAnimations];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RetractLeftMenuNotification" object:nil];
        }
    }
}

- (void)handlePanAction:(UIPanGestureRecognizer *)rec{
    CGPoint point = [rec translationInView:self.view];
    CGFloat move = point.x - _lastX;
    _lastX = point.x;
    CGFloat target = _sideBarVC.view.frame.origin.x + move;
    if (target <= 0 && target >= - LEFTMENU_WIDTH) {
        [UIView beginAnimations:nil context:nil];
        [_sideBarVC.view moveDistance:move direction:MoveDirectionRight];
        [_homeNav.view moveDistance:move direction:MoveDirectionRight];
        [UIView commitAnimations];
    }
    
    //手势结束
    if (rec.state == UIGestureRecognizerStateEnded) {
        _lastX = 0;
        if (_sideBarVC.view.centerX > 0 ) {//展开侧边栏
            [UIView beginAnimations:nil context:nil];
            [_sideBarVC.view setX:0];
            [_homeNav.view setX:ContentViewX];
            [UIView commitAnimations];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ExhaledLeftMenuNotification" object:nil];
        }else{//缩回侧边栏
            [UIView beginAnimations:nil context:nil];
            [_sideBarVC.view setX:-LEFTMENU_WIDTH];
            [_homeNav.view setX:0];
            [_maskView removeFromSuperview];
            [UIView commitAnimations];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RetractLeftMenuNotification" object:nil];
        }
    }
}


- (void)hideViewController:(UIViewController *)viewController
{
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
}


- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.alpha = 0.3;
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapAction:)];
        [tap setNumberOfTapsRequired:1];
        tap.delegate = self;
        [_maskView addGestureRecognizer:tap];
        
        
        //滑动手势
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanAction:)];
        pan.delegate = self;
        [_maskView addGestureRecognizer:pan];
        
    }
    return _maskView;
}


- (void)dealloc{
    _sideBarVC = nil;
    _homeNav = nil;
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
