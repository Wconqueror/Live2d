/*
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at http://live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#import "ViewController.h"
#import "SwipeView.h"

#import <math.h>
#import <string>
#import <QuartzCore/QuartzCore.h>
#import "CubismFramework.hpp"
#import <Math/CubismMatrix44.hpp>
#import <Math/CubismViewMatrix.hpp>
#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "AppDelegate.h"
#import "LAppSprite.h"
#import "TouchManager.h"
#import "LAppDefine.h"
#import "LAppLive2DManager.h"
#import "LAppTextureManager.h"
#import "LAppPal.h"

#define BUFFER_OFFSET(bytes) ((GLubyte *)NULL + (bytes))

using namespace std;
using namespace LAppDefine;


@interface ViewController ()
@property (nonatomic,strong) SwipeView *swipeView;

@property (nonatomic) LAppSprite *back; //背景画像
@property (nonatomic) LAppSprite *gear; //设置画像
@property (nonatomic) TouchManager *touchManager;// 触摸管理器
@property (nonatomic) Csm::CubismMatrix44 *deviceToScreen;///< 设备到屏幕的矩阵
@property (nonatomic) Csm::CubismViewMatrix *viewMatrix;
@property (nonatomic) UIButton *cryBtn;
@end

@implementation ViewController

-(UIButton *)cryBtn{
    if (!_cryBtn) {
        _cryBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_cryBtn setBackgroundColor:[UIColor lightGrayColor]];
        _cryBtn.frame = CGRectMake(kScreenHeight - 80, kScreenWidth - 80, 64, 64);
        _cryBtn.layer.cornerRadius = 32;
        [_cryBtn addTarget:self action:@selector(cryAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cryBtn;
}

-(void)cryAction:(UIButton *)btn{
    [LAppLive2DManager getInstance];
}

@synthesize mOpenGLRun;
-(SwipeView *)swipeView{
    if (!_swipeView) {
        _swipeView = [[SwipeView alloc]initWithFrame:self.view.bounds];
    }
    return _swipeView;
}

static const GLfloat uv[] =
{
    0.0f, 1.0f,
    1.0f, 1.0f,
    
    0.0f, 0.0f,
    1.0f, 0.0f,
};

- (void)dealloc
{
    [super dealloc];
}

- (void)releaseView
{
    [_back release];
    _back = nil;
    
    GLKView *view = (GLKView*)self.view;
    [view.context release];
    
    [view release];
    view = nil;
    
    delete(_viewMatrix);
    _viewMatrix = nil;
    delete(_deviceToScreen);
    _deviceToScreen = nil;
    [_touchManager release];
    _touchManager = nil;
}

- (void)viewDidLoad
{
        [self.view addSubview:self.swipeView];
    //    [self.view addSubview:self.cryBtn];
    
    mOpenGLRun = true;
    
    // 初始化触摸管理器
    _touchManager = [[TouchManager alloc]init];
    
    //将设备坐标转化为屏幕坐标
    _deviceToScreen = new CubismMatrix44();
    
    // 用于放大/缩小屏幕显示和转换运动的矩阵
    _viewMatrix = new CubismViewMatrix();
    
    //屏幕的初始化
    [self initializeScreen];
    
    [super viewDidLoad];
    
    GLKView *view = (GLKView*)self.view;
    // OpenGL ES2を指定
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    //set context
    [EAGLContext setCurrentContext:view.context];
    
    float r = 242 / 255.0;
    
    glClearColor(r, r, r, 1.0f);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    
    glEnable(GL_BLEND);//开启剔除操作效果
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glGenBuffers(1, &_vertexBufferId); //生成独立的vertexBufferid
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferId); //绑定vertexBufferId
    //GL_APPAY_BUFFER用于为定点数组传值
    
    glGenBuffers(1, &_fragmentBufferId);
    glBindBuffer(GL_ARRAY_BUFFER,  _fragmentBufferId);
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(uv), uv, GL_STATIC_DRAW);//绑定定点到缓冲区
}

//将屏幕进行坐标转换
- (void)initializeScreen
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int width = screenRect.size.width;
    int height = screenRect.size.height;
    
    //static_cast 任何隐士类型的转换都可以用它 比如int与float、double与char、enum与int之间的转换
    float ratio = static_cast<float>(height) / static_cast<float>(width);
    float left = ViewLogicalLeft; //逻辑left
    float right = ViewLogicalRight;
    float bottom = -ratio;
    float top = ratio;
    
    // 屏幕的范围对应于设备。 X的左端，X的右端，Y的下端，Y的上端
    _viewMatrix->SetScreenRect(left, right, bottom, top);
    
    float screenW = fabsf(left - right);
    _deviceToScreen->ScaleRelative(screenW / width, -screenW / width);
    _deviceToScreen->TranslateRelative(-width * 0.5f, -height * 0.5f);
    
    //设置显示范围
    _viewMatrix->SetMaxScale(ViewMaxScale); // 限界扩大率
    _viewMatrix->SetMinScale(ViewMinScale); // 限界縮小率
    
    // 最大可显示范围
    _viewMatrix->SetMaxScreenRect(
                                  ViewLogicalMaxLeft,
                                  ViewLogicalMaxRight,
                                  ViewLogicalMaxBottom,
                                  ViewLogicalMaxTop
                                  );
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    //時間更新
    LAppPal::UpdateTime();
    
    if(mOpenGLRun)
    {
        //清除缓冲区
        glClear(GL_COLOR_BUFFER_BIT); //表示实际完成了把整个窗口清除为黑色的任务
        /*      GL_COLOR_BUFFER_BIT:   当前可写的颜色缓冲
         GL_DEPTH_BUFFER_BIT:   深度缓冲
         GL_ACCUM_BUFFER_BIT:   累积缓冲
         　　    GL_STENCIL_BUFFER_BIT: 模板缓冲
         */
        
        [_back render:_vertexBufferId fragmentBufferID:_fragmentBufferId];
        
        [_gear render:_vertexBufferId fragmentBufferID:_fragmentBufferId];
        
        [[LAppLive2DManager getInstance] onUpdate];
        glClearColor(242 / 255.0, 242 / 255.0, 242 / 255.0, 1.0f); //清除颜色设为黑色
    }
    
    //    if (_mTextureOn){
    //        _mTextureOn = false;
    //
    //        [[LAppLive2DManager getInstance] setModelTextureWithNo:0];
    //    }
    
}

- (void)initializeSprite
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int width = screenRect.size.width;
    int height = screenRect.size.height;
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    LAppTextureManager* textureManager = [delegate getTextureManager];
    
    const string resourcesPath = ResourcesPath;//资源路径
    string imageName = BackImageName;//背景图片
    
    TextureInfo* backgroundTexture = [textureManager createTextureFromPngFile:resourcesPath+imageName];//图片路径
    
    float x = width * 0.5f;
    float y = height * 0.5f;
    float fWidth = width;
    float fHeight = height;
    fWidth = static_cast<float>(width * 1.0f);
    fHeight = static_cast<float>(height * 1.0f);
    
    _back = [[LAppSprite alloc] initWithMyVar:x Y:y Width:fWidth Height:fHeight TextureId:backgroundTexture->id];
    
    
    imageName = GearImageName;//齿轮图片
    
    TextureInfo* gearTexture = [textureManager createTextureFromPngFile:resourcesPath+imageName];
    x = static_cast<float>(width - gearTexture->width * 0.5f);
    y = static_cast<float>(height - 2 * gearTexture->height * 0.5f);
    fWidth = static_cast<float>(gearTexture->width);
    fHeight = static_cast<float>(gearTexture->height);
    _gear = [[LAppSprite alloc] initWithMyVar:x Y:y Width:fWidth Height:fHeight TextureId:gearTexture->id];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    [_touchManager touchesBegan:point.x DeciveY:point.y];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self.view];
    
    float viewX = [self transformViewX:[_touchManager getX]];
    float viewY = [self transformViewY:[_touchManager getY]];
    
    [_touchManager touchesMoved:point.x DeviceY:point.y];
    
    [[LAppLive2DManager getInstance] onDrag:viewX floatY:viewY];
    
    NSLog(@"动了,动了%f,%f",viewX,viewY);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSLog(@"%@", touch.view);
    
    CGPoint point = [touch locationInView:self.view];
    float pointY = [self transformTapY:point.y];
    
    //触摸结束
    LAppLive2DManager* live2DManager = [LAppLive2DManager getInstance];
    [live2DManager onDrag:0.0f floatY:0.0f];
    {
        //单击
        float getX = [_touchManager getX];// 在逻辑坐标转换后获取坐标。
        float getY = [_touchManager getY]; // 在逻辑坐标转换后获取坐标。
        float x = _deviceToScreen->TransformX(getX);
        float y = _deviceToScreen->TransformY(getY);
        
        if (DebugTouchLogEnable) //调试日志显示
        {
            LAppPal::PrintLog("[APP]touchesEnded x:%.2f y:%.2f", x, y);
        }
        
        //是否点击了 齿轮按钮
        if ([_gear isHit:point.x PointY:pointY])
        {
            //            [live2DManager nextScene];//下一个场景
            _mTextureOn = true;
            
            //            [live2DManager setModelActionWithNo:0];
            [live2DManager setModelTextureWithNo:0];
        }
        
        [live2DManager onTap:x floatY:y];
    }
}

- (float)transformViewX:(float)deviceX
{
    float screenX = _deviceToScreen->TransformX(deviceX); // 在逻辑坐标转换后获取坐标
    return _viewMatrix->InvertTransformX(screenX); // 拡大、縮小、移動後の値。
}

- (float)transformViewY:(float)deviceY
{
    float screenY = _deviceToScreen->TransformY(deviceY); // 在逻辑坐标转换后获取坐标
    return _viewMatrix->InvertTransformY(screenY); // 拡大、縮小、移動後の値。
}

- (float)transformScreenX:(float)deviceX
{
    return _deviceToScreen->TransformX(deviceX);
}

- (float)transformScreenY:(float)deviceY
{
    return _deviceToScreen->TransformY(deviceY);
}

- (float)transformTapY:(float)deviceY
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int height = screenRect.size.height;
    return deviceY * -1 + height;
}

@end

