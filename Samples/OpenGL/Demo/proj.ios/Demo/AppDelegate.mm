/*
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at http://live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#import "AppDelegate.h"
#import "ViewController.h"
#import "LAppAllocator.h"
#import <iostream>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "LAppPal.h"
#import "LAppDefine.h"
#import "LAppLive2DManager.h"
#import "LAppTextureManager.h"


@interface AppDelegate ()

@property (nonatomic) LAppAllocator cubismAllocator; // Cubism3 Allocator
@property (nonatomic) Csm::CubismFramework::Option cubismOption; // Cubism3 Option
@property (nonatomic) bool captured; // 你点击了么?
@property (nonatomic) float mouseX; // マウスX座標
@property (nonatomic) float mouseY; // マウスY座標
@property (nonatomic) bool isEnd; // APP是否结束
@property (nonatomic, readwrite) LAppTextureManager *textureManager; // 纹理管理器
@property (nonatomic) Csm::csmInt32 sceneIndex;  //执行应用程序后台时临时保存场景索引值

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _textureManager = [[LAppTextureManager alloc]init];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[ViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    [self initializeCubism];
    
//    [self.viewController initializeSprite];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    self.viewController.mOpenGLRun = false;
    
    [_textureManager release];
    _textureManager = nil;
    
    _sceneIndex = [[LAppLive2DManager getInstance] sceneIndex];
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    self.viewController.mOpenGLRun = true;
    
    _textureManager = [[LAppTextureManager alloc]init];
    
    [[LAppLive2DManager getInstance] changeScene:_sceneIndex];
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self.viewController release];
    self.viewController = nil;
}

- (void)initializeCubism
{
    _cubismOption.LogFunction = LAppPal::PrintMessage;
    _cubismOption.LoggingLevel = LAppDefine::CubismLoggingLevel;
    
    Csm::CubismFramework::StartUp(&_cubismAllocator,&_cubismOption);
    
    Csm::CubismFramework::Initialize();
    
    [LAppLive2DManager getInstance];
    
    Csm::CubismMatrix44 projection;
    
    LAppPal::UpdateTime();
}

- (bool)getIsEnd
{
    return _isEnd;
}

- (void)finishApplication
{
    [self.viewController releaseView];
    
    [_textureManager release];
    _textureManager = nil;
    
    [LAppLive2DManager releaseInstance];
    
    Csm::CubismFramework::Dispose();
    
    [self.window release];
    self.window = nil;

    [self.viewController release];
    self.viewController = nil;
    
    _isEnd = true;

    exit(0);
}

@end
