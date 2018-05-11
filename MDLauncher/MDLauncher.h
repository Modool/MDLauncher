//
//  MDLauncher.h
//  MDLauncher
//
//  Created by xulinfeng on 2018/5/11.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for MDLauncher.
FOUNDATION_EXPORT double MDLauncherVersionNumber;

//! Project version string for MDLauncher.
FOUNDATION_EXPORT const unsigned char MDLauncherVersionString[];

@interface MDLauncher : NSObject

// It's YES when the app is first installed, or it's NO.
@property (readonly, class, getter = isFirstInstalled) BOOL firstInstalled;

// It's YES when the app is first launched for a version, maybe acrossing versions without launching before.
@property (readonly, class, getter = isFirstLaunched) BOOL firstLaunched;

// It's YES when the app is first launched for current version, or it's NO.
@property (readonly, class, getter = isFirstLaunchedForCurrentVersion) BOOL firstLaunchedForCurrentVersion;

// All installed versions, maybe acrossing versions.
@property (readonly, class) NSArray<NSString *> *installedVersions;

// Previous installed version.
@property (readonly, class) NSString *previousVersion;

// Current version from CFBundleShortVersionString.
@property (readonly, class) NSString *currentVersion;

@end
