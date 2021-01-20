//
//  MCCustomTabbar.h
//  MonitorClient_iOS
//
//  Created by Davetech on 2021/1/20.
//  Copyright © 2021 johnsoncontrols. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCCustomTabbar : UITabBar
+(void)setTabBarUI:(NSArray*)views tabBar:(UITabBar*)tabBar topLineColor:(UIColor*)lineColor backgroundColor:(UIColor*)backgroundColor index:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
