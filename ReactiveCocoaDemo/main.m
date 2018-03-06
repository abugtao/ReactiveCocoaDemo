//
//  main.m
//  ReactiveCocoaDemo
//
//  Created by zht on 15/4/17.
//  Copyright (c) 2015年 zht. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

// From here to end of file added by Injection Plugin //

#ifdef DEBUG
static char _inMainFilePath[] = __FILE__;
static const char *_inIPAddresses[] = {"127.0.0.1", "192.168.4.152", NULL};

#define INJECTION_ENABLED
#import "/Users/zht/Library/Application Support/Developer/Shared/Xcode/Plug-ins/InjectionPlugin.xcplugin/Contents/Resources/BundleInjection.h"
#endif
