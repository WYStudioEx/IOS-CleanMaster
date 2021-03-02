//
//  Public.h
//  IOSBaseTemplate
//
//  Created by WYStudio on 2021/1/25.
//

#ifndef __Macro__Public__
#define __Macro__Public__

#import <Foundation/Foundation.h>

//以iphoneX为基准,viewcontroller内排版，高度的724是企业微信设计稿预设的屏幕高度 - 80（导航栏 + 状态栏）
#define _size_W_X(value)  (value / 375.0f) * self.view.qmui_width
#define _size_H_X(value)  (value / 724.0f) * self.view.qmui_height

#define _size_W_R(value, width)  (value / 375.0f) * width
#define _size_H_R(value, height)  (value / 724.0f) * height

//以iphoneX为基准,屏幕内排版
#define _size_W_S_X(value)  ((value / 375.0f) * [UIScreen mainScreen].bounds.size.width)              //以iphoneX为基准
#define _size_H_S_X(value)  ((value / 812.0f) * [UIScreen mainScreen].bounds.size.height)

//设备型号
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6PlusScale ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//导航栏
#define StatusBarHeight (iPhoneX ? 44.f : 20.f)
#define StatusBarAndNavigationBarHeight (iPhoneX ? 88.f : 64.f)
#define TabbarHeight (iPhoneX ? (49.f + 34.f) : (49.f))
#define BottomSafeAreaHeight (iPhoneX ? (34.f) : (0.f))

#endif /* defined(__Macro__Public__) */
