/*
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at http://live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#import <Foundation/Foundation.h>
#import "LAppSprite.h"
#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#define BUFFER_OFFSET(bytes) ((GLubyte *)NULL + (bytes))

@interface LAppSprite()

@property (nonatomic, readwrite) GLuint textureId; // 纹理ID
@property (nonatomic) SpriteRect rect; // 矩形
@property (nonatomic) GLuint vertexBufferId;
@property (nonatomic) GLuint fragmentBufferId;

@end

@implementation LAppSprite
@synthesize baseEffect;

- (id)initWithMyVar:(float)x Y:(float)y Width:(float)width Height:(float)height TextureId:(GLuint) textureId
{
    self = [super self];
    if(self != nil)
    {
        _rect.left = (x - width * 0.5f); //0
        _rect.right = (x + width * 0.5f);//width
        _rect.up = (y + height * 0.5f);//height
        _rect.down = (y - height * 0.5f);//0
        _textureId = textureId;
        
        self.baseEffect = [[GLKBaseEffect alloc] init];
        self.baseEffect.useConstantColor = GL_TRUE;
        self.baseEffect.constantColor = GLKVector4Make(1.0f,1.0f,1.0f,1.0f);
        self.baseEffect.texture2d0.enabled = GL_TRUE;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)render:(GLuint)vertexBufferID fragmentBufferID:(GLuint)fragmentBufferID
{
    [self.baseEffect prepareToDraw];//绘制时同步所有效果更改以保持一致状态
    
    //描画画像変更
    self.baseEffect.texture2d0.name = _textureId;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float maxWidth = screenRect.size.width;
    float maxHeight = screenRect.size.height;
    
    float positionVertex[] = //位置顶点数组
    {
        (_rect.left  - maxWidth * 0.5f) / (maxWidth * 0.5f), (_rect.down - maxHeight * 0.5f) / (maxHeight * 0.5f),
        (_rect.right - maxWidth * 0.5f) / (maxWidth * 0.5f), (_rect.down - maxHeight * 0.5f) / (maxHeight * 0.5f),
        
        (_rect.left  - maxWidth * 0.5f) / (maxWidth * 0.5f), (_rect.up   - maxHeight * 0.5f) / (maxHeight * 0.5f),
        (_rect.right - maxWidth * 0.5f) / (maxWidth * 0.5f), (_rect.up   - maxHeight * 0.5f) / (maxHeight * 0.5f),
    };
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID); //指定当前活动缓冲区的对象
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(positionVertex), positionVertex, GL_STATIC_DRAW);//用数据分配和初始化缓冲区对象
    /* 第一个参数:target:可以是GL_ARRAY_BUFFER()（顶点数据）或GL_ELEMENT_ARRAY_BUFFER(索引数据)
     * 第二个参数:size:存储相关数据所需要的内存容量
     * 第三个参数:data:用于初始化缓冲区对象,可以是一个指向客户区内存的指针,也可以是NULL
     * 第四个参数:usage:数据在分配之后如何进行读写,如如GL_STREAM_READ，GL_STREAM_DRAW，GL_STREAM_COPY
     */
    
    //指定顶点信息的位置作为顶点处理的变量（使用此绘制）
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    //为顶点处理教授顶点处理存储位置和格式
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, BUFFER_OFFSET(0));
    
    glBindBuffer(GL_ARRAY_BUFFER, fragmentBufferID);
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, BUFFER_OFFSET(0));
    
    //描绘图形
    glDisable(GL_CULL_FACE);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

//判断是否在设置的矩形区域内
- (bool)isHit:(float)pointX PointY:(float)pointY
{
    return (pointX >= _rect.left && pointX <= _rect.right &&
            pointY >= _rect.down && pointY <= _rect.up);
}

@end


