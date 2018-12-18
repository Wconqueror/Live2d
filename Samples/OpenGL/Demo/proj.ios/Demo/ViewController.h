/*
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at http://live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface ViewController :GLKViewController <GLKViewDelegate>

@property (nonatomic, assign) bool mOpenGLRun;
@property (nonatomic, assign) bool mTextureOn;
@property (nonatomic) GLuint vertexBufferId;
@property (nonatomic) GLuint fragmentBufferId;
@property (nonatomic) GLuint programId;
@property (nonatomic,strong) GLKBaseEffect *baseEffect;

/**
 * @brief 解放処理
 */
- (void)dealloc;

/**
 * @brief 解放する。
 */
- (void)releaseView;

/**
 * @brief 初始化图像
 */
- (void)initializeSprite;

/**
 * @brief タッチしているときにポインタが動いたら呼ばれる。
 *
 * @param[in]       pointX            スクリーンX座標
 * @param[in]       pointY            スクリーンY座標
 */
- (void)onTouchesMoved:(float)pointX PointY:(float)pointY;

/**
 * @brief タッチが終了したら呼ばれる。
 *
 * @param[in]       pointX            スクリーンX座標
 * @param[in]       pointY            スクリーンY座標
 */
- (void)onTouchesEnded:(float)pointX PointY:(float) pointY;

/**
 * @brief 将X坐标转换为View坐标。
 *
 * @param[in]       deviceX            设备x坐标
 */
- (float)transformViewX:(float)deviceX;

/**
 * @brief 将X坐标转换为View坐标。
 *
 * @param[in]       deviceY             设备y坐标
 */
- (float)transformViewY:(float)deviceY;

/**
 * @brief 将X坐标转换为屏幕坐标。
 *
 * @param[in]       deviceX            デバイスX座標
 */
- (float)transformScreenX:(float)deviceX;

/**
 * @brief Y座標をScreen座標に変換する。
 *
 * @param[in]       deviceY            デバイスY座標
 */
- (float)transformScreenY:(float)deviceY;

@end

