//
//  QMUIConfigurationTemplate.m
//  qmui
//
//  Created by QMUI Team on 15/3/29.
//  Copyright (c) 2021年 QMUI Team. All rights reserved.
//

#import "QMUIConfigurationTemplateGrass.h"

@implementation QMUIConfigurationTemplateGrass

#pragma mark - <QMUIConfigurationTemplateProtocol>

- (void)applyConfigurationTemplate {
    QMUICMI.needsBackBarButtonItemTitle = NO;
    QMUICMI.navBarTitleFont = UIFontBoldMake(20);
    QMUICMI.navBarTitleColor = [UIColor blackColor];
    QMUICMI.navBarTintColor = [UIColor blackColor];
}

- (BOOL)shouldApplyTemplateAutomatically {
    [QMUIThemeManagerCenter.defaultThemeManager addThemeIdentifier:self.themeName theme:self];
    QMUIThemeManagerCenter.defaultThemeManager.currentTheme = self;
    return YES;
}

#pragma mark - <QDThemeProtocol>

- (NSString *)themeName {
    return @"Grass";;
}

@end
