/*
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at http://live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#ifndef LAppSprite_h
#define LAppSprite_h

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "ViewController.h"

@interface LAppSprite : NSObject
@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (nonatomic, readonly, getter=GetTextureId) GLuint textureId; // 纹理ID

/**
 * @brief Rect 構造体。
 */
typedef struct
{
    float left;     ///< 左辺
    float right;    ///< 右辺
    float up;       ///< 上辺
    float down;     ///< 下辺
}SpriteRect;

/**
 * @brief 初期化
 *
 * @param[in]       x            x座標
 * @param[in]       y            y座標
 * @param[in]       width        横幅
 * @param[in]       height       高さ
 * @param[in]       textureId    纹理ID
 */
- (id)initWithMyVar:(float)x Y:(float)y Width:(float)width Height:(float)height TextureId:(GLuint) textureId;

/**
 * @brief 解放処理
 */
- (void)dealloc;

/**
 * @brief 描画する
 *
 * @param[in]     vertexBufferID    片段着色器ID
 * @param[in]     fragmentBufferID  顶点着色器ID
 */
- (void)render:(GLuint)vertexBufferID fragmentBufferID:(GLuint)fragmentBufferID;


/**
 * @brief 构造函数
 *
 * @param[in]       pointX    x座標
 * @param[in]       pointY    y座標
 */
- (bool)isHit:(float)pointX PointY:(float)pointY;

@end

#endif /* LAppSprite_h */
