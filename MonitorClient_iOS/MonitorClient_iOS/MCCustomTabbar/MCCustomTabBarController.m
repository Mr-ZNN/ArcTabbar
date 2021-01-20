//
//  MCCustomTabBarController.m
//  MonitorClient_iOS
//
//  Created by Davetech on 2021/1/20.
//  Copyright © 2021 johnsoncontrols. All rights reserved.
//

#import "MCCustomTabBarController.h"
#import "MCCustomTabbar.h"
#import "ViewController.h"

@interface MCCustomTabBarController ()<UITabBarControllerDelegate>
//记录上一次点击tabbar
@property (nonatomic, assign) NSInteger indexFlag;
@end

@implementation MCCustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.indexFlag = 0;
    [self setupUI];
}
- (void)setupUI{
    MCCustomTabbar * tabbar = [[MCCustomTabbar alloc] init];
    [self setValue:tabbar forKeyPath:@"tabBar"];
 
    //设备
    ViewController * deviceVC = [[ViewController alloc] init];
    deviceVC.view.backgroundColor = [UIColor redColor];
    UINavigationController * deviceNav = [self addChildVc:deviceVC title:@"设备" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
    //首页
    ViewController * homeVC = [[ViewController alloc] init];
    homeVC.view.backgroundColor = [UIColor yellowColor];
    UINavigationController * homeNav = [self addChildVc:homeVC title:@"首页" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    //我的
    ViewController * mineVC = [[ViewController alloc] init];
    mineVC.view.backgroundColor = [UIColor blueColor];
    UINavigationController * mineNav = [self addChildVc:mineVC title:@"我的" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
    
    self.viewControllers = @[deviceNav,homeNav,mineNav];
    self.delegate = self;
}
- (UINavigationController*)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    // 同时设置tabbar和navigationBar的文字
    childVc.title = title;
    // 设置子控制器的图片
    childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //未选中字体颜色
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:13]} forState:UIControlStateNormal];
    //选中字体颜色
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:13]} forState:UIControlStateSelected];
    //包装一个导航控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    return nav;
}
#pragma mark - 类的初始化方法，只有第一次使用类的时候会调用一次该方法
+ (void)initialize{
    //tabbar去掉顶部黑线
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //初始化第0个顶部弧形
    [MCCustomTabbar setTabBarUI:self.tabBar.subviews tabBar:self.tabBar topLineColor:[UIColor lightGrayColor] backgroundColor:self.tabBar.barTintColor index:0];
    //执行动画
    NSMutableArray *arry = [NSMutableArray array];
    for (UIView *btn in self.tabBar.subviews) {
        if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            for (UIView *imageView in btn.subviews) {
                if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                    [arry addObject:imageView];
                }
            }
        }
    }
    //添加动画
    [self addscaleAndUpTranslationAndKeepAnimtaionWithArr:arry index:self.indexFlag];
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSUInteger index = [tabBar.items indexOfObject:item];
    NSLog(@"%ld",index);
    //切换顶部弧形
    [MCCustomTabbar setTabBarUI:self.tabBar.subviews tabBar:self.tabBar topLineColor:[UIColor lightGrayColor] backgroundColor:self.tabBar.barTintColor index:index];
    //tabbarItem动画
    if (index != self.indexFlag) {
        //执行动画
        NSMutableArray *arry = [NSMutableArray array];
        for (UIView *btn in self.tabBar.subviews) {
            if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                for (UIView *imageView in btn.subviews) {
                    if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                        [arry addObject:imageView];
                    }
                }
            }
        }
        //添加动画
        [self addscaleAndUpTranslationAndKeepAnimtaionWithArr:arry index:index];
        
        self.indexFlag = index;
    }
}

#pragma mark - TabbarItem动画样式
//1、先放大，再缩小
- (void)addScaleAnimtaionWithArr:(NSMutableArray *)arry index:(NSInteger)index
{
    //放大效果，并回到原位
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //速度控制函数，控制动画运行的节奏
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.2;       //执行时间
    animation.repeatCount = 1;      //执行次数
    animation.autoreverses = YES;    //完成动画后会回到执行动画之前的状态
    animation.fromValue = [NSNumber numberWithFloat:0.7];   //初始伸缩倍数
    animation.toValue = [NSNumber numberWithFloat:1.3];     //结束伸缩倍数
    [[arry[index] layer] addAnimation:animation forKey:nil];
}
//2、Z轴旋转
- (void)addRotationAnimtaionWithArr:(NSMutableArray *)arry index:(NSInteger)index
{
    //z轴旋转180度
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //速度控制函数，控制动画运行的节奏
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.2;       //执行时间
    animation.repeatCount = 1;      //执行次数
    animation.removedOnCompletion = YES;
    animation.fromValue = [NSNumber numberWithFloat:0];   //初始伸缩倍数
    animation.toValue = [NSNumber numberWithFloat:M_PI];     //结束伸缩倍数
    [[arry[index] layer] addAnimation:animation forKey:nil];
}
//3、向上移动
- (void)addUpTranslationAnimtaionWithArr:(NSMutableArray *)arry index:(NSInteger)index
{
    //向上移动
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    //速度控制函数，控制动画运行的节奏
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.2;       //执行时间
    animation.repeatCount = 1;      //执行次数
    animation.removedOnCompletion = YES;
    animation.fromValue = [NSNumber numberWithFloat:0];   //初始伸缩倍数
    animation.toValue = [NSNumber numberWithFloat:-10];     //结束伸缩倍数
    [[arry[index] layer] addAnimation:animation forKey:nil];
}
//4、放大并保持
- (void)addscaleAndKeepAnimtaionWithArr:(NSMutableArray *)arry index:(NSInteger)index
{
    //放大效果
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //速度控制函数，控制动画运行的节奏
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.2;       //执行时间
    animation.repeatCount = 1;      //执行次数
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;           //保证动画效果延续
    animation.fromValue = [NSNumber numberWithFloat:1.0];   //初始伸缩倍数
    animation.toValue = [NSNumber numberWithFloat:1.1];     //结束伸缩倍数
    [[arry[index] layer] addAnimation:animation forKey:nil];
    //移除其他tabbar的动画
    for (int i = 0; i<arry.count; i++) {
        if (i != index) {
            [[arry[i] layer] removeAllAnimations];
        }
    }
}
//5、放大向上平移并保持
- (void)addscaleAndUpTranslationAndKeepAnimtaionWithArr:(NSMutableArray *)arry index:(NSInteger)index
{
    //放大效果
    CABasicAnimation *animationScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //速度控制函数，控制动画运行的节奏
    animationScale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationScale.duration = 0.2;       //执行时间
    animationScale.repeatCount = 1;      //执行次数
    animationScale.removedOnCompletion = NO;
    animationScale.fillMode = kCAFillModeForwards;           //保证动画效果延续
    animationScale.fromValue = [NSNumber numberWithFloat:1.0];   //初始伸缩倍数
    animationScale.toValue = [NSNumber numberWithFloat:1.5];     //结束伸缩倍数
    [[arry[index] layer] addAnimation:animationScale forKey:@"animationScale"];
    //向上移动
    CABasicAnimation *animationTrans = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    //速度控制函数，控制动画运行的节奏
    animationTrans.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationTrans.duration = 0.2;       //执行时间
    animationTrans.repeatCount = 1;      //执行次数
    animationTrans.removedOnCompletion = NO;
    animationTrans.fillMode = kCAFillModeForwards;           //保证动画效果延续
    animationTrans.fromValue = [NSNumber numberWithFloat:0];   //初始伸缩倍数
    animationTrans.toValue = [NSNumber numberWithFloat:-10];     //结束伸缩倍数
    [[arry[index] layer] addAnimation:animationTrans forKey:@"animationTrans"];
    //移除其他tabbar的动画
    for (int i = 0; i<arry.count; i++) {
        if (i != index) {
            [[arry[i] layer] removeAllAnimations];
        }
    }
}
@end
