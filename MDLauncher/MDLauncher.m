//
//  MDLauncher.m
//  MDLauncher
//
//  Created by xulinfeng on 2018/5/11.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "MDLauncher.h"

NSString * const MDLauncherInstalledVersionsUserDefaultKey = @"MDLauncherInstalledVersionsUserDefaultKey";
NSString * const MDLauncherPreviousVersionUserDefaultKey = @"MDLauncherPreviousVersionUserDefaultKey";
NSString * const MDLauncherStoredVersionUserDefaultKey = @"MDLauncherStoredVersionUserDefaultKey";

@interface MDLauncher ()

@property (nonatomic, assign, getter = isFirstInstalled) BOOL firstInstalled;

@property (nonatomic, assign, getter = isFirstLaunched) BOOL firstLaunched;

@property (nonatomic, assign, getter = isFirstLaunchedForCurrentVersion) BOOL firstLaunchedForCurrentVersion;

@property (nonatomic, copy) NSArray<NSString *> *installedVersions;

@property (nonatomic, copy) NSString *previousVersion;

@property (nonatomic, copy) NSString *storedVersion;

@end

@implementation MDLauncher

+ (void)initialize{
    [super initialize];
    
    [[self default] initialize];
}

+ (instancetype)default{
    static MDLauncher *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[MDLauncher alloc] init];
    });
    return sharedManager;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@\nfirstInstalled: %d\nfirstLaunched: %d\nfirstLaunchedForCurrentVersion: %d\ninstalledVersions: %@\npreviousVersion: %@\nstoredVersion: %@", [self class], [self isFirstInstalled], [self isFirstLaunched], [self isFirstLaunchedForCurrentVersion], [self installedVersions], [self previousVersion], [self storedVersion]];
}

- (NSString *)debugDescription{
    return [self description];
}

#pragma mark - accessor

- (NSArray<NSString *> *)installedVersions{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:MDLauncherInstalledVersionsUserDefaultKey];
}

- (void)setInstalledVersions:(NSString *)installedVersions{
    [[NSUserDefaults standardUserDefaults] setObject:installedVersions ?: @[] forKey:MDLauncherInstalledVersionsUserDefaultKey];
}

- (NSString *)previousVersion{
    return [[NSUserDefaults standardUserDefaults] stringForKey:MDLauncherPreviousVersionUserDefaultKey];
}

- (void)setPreviousVersion:(NSString *)previousVersion{
    [[NSUserDefaults standardUserDefaults] setObject:previousVersion ?: @"" forKey:MDLauncherPreviousVersionUserDefaultKey];
}

- (NSString *)storedVersion{
    return [[NSUserDefaults standardUserDefaults] stringForKey:MDLauncherStoredVersionUserDefaultKey];
}

- (void)setStoredVersion:(NSString *)storedVersion{
    [[NSUserDefaults standardUserDefaults] setObject:storedVersion ?: @"" forKey:MDLauncherStoredVersionUserDefaultKey];
}

- (NSString *)currentVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

#pragma mark - class accessor

+ (BOOL)isFirstInstalled{
    return [[self default] isFirstInstalled];
}

+ (BOOL)isFirstLaunched{
    return [[self default] isFirstLaunched];
}

+ (BOOL)isFirstLaunchedForCurrentVersion{
    return [[self default] isFirstLaunchedForCurrentVersion];
}

+ (NSArray<NSString *> *)installedVersions{
    return [[self default] installedVersions];
}

+ (NSString *)previousVersion{
    return [[self default] previousVersion];
}

+ (NSString *)currentVersion{
    return [[self default] currentVersion];
}

#pragma mark - private

- (void)initialize{
    NSString *version = [self currentVersion];
    
    NSArray<NSString *> *installedVersions = [self installedVersions];
    NSString *previousVersion = [self previousVersion];
    NSString *storedVersion = [self storedVersion];
    
    BOOL firstInstalled = ![storedVersion length] && ![previousVersion length];
    BOOL firstLaunched = ![storedVersion length];
    BOOL firstLaunchedForCurrentVersion = ![storedVersion length] || [storedVersion compare:version] == NSOrderedAscending;
    
    self.firstInstalled = firstInstalled;
    self.firstLaunched = firstLaunched;
    self.firstLaunchedForCurrentVersion = firstLaunchedForCurrentVersion;
    
    if (!firstLaunchedForCurrentVersion) return;
    
    self.installedVersions = [installedVersions ?: @[] arrayByAddingObject:version ?: @""];
    self.previousVersion = storedVersion;
    self.storedVersion = version;
}

@end
