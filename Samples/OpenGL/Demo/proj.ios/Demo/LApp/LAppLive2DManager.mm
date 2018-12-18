/*
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at http://live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "LAppLive2DManager.h"
#import "LAppModel.h"
#import "LAppDefine.h"
#import "LAppPal.h"

@interface LAppLive2DManager()

- (id)init;
- (void)dealloc;
@end

@implementation LAppLive2DManager

static LAppLive2DManager* s_instance = nil;

+ (LAppLive2DManager*)getInstance
{
    @synchronized(self)
    {
        if(s_instance == nil)
        {
            s_instance = [[LAppLive2DManager alloc] init];
        }
    }
    return s_instance;
}

+ (void)releaseInstance
{
    if(s_instance != nil)
    {
        [s_instance release];
        s_instance = nil;
    }
}

- (id)init
{
    self = [super init];
    if (self){
        _viewMatrix = nil;
        _sceneIndex = 0;
        
        [self changeScene:_sceneIndex];
    }
    return self;
}

- (void)dealloc
{
    [self releaseAllModel];
    [super dealloc];
}

- (void)releaseAllModel
{
    for (Csm::csmUint32 i = 0; i < _models.GetSize(); i++)
    {
        delete _models[i];
    }
    
    _models.Clear();
}

- (LAppModel*)getModel:(Csm::csmUint32)no
{
    if (no < _models.GetSize())
    {
        return _models[no];
    }
    return nil;
}

- (void)onDrag:(Csm::csmFloat32)x floatY:(Csm::csmFloat32)y
{
    //    for (Csm::csmUint32 i = 0; i < _models.GetSize(); i++)
    //    {
    Csm::CubismUserModel* model = static_cast<Csm::CubismUserModel*>([self getModel:0]);
    model->SetDragging(x,y);
    //    }
}

- (void)onTap:(Csm::csmFloat32)x floatY:(Csm::csmFloat32)y;
{
    if (LAppDefine::DebugLogEnable)//调试日志显示
    {
        LAppPal::PrintLog("[APP]tap point: {x:%.2f y:%.2f}", x, y);
    }
    
    for (Csm::csmUint32 i = 0; i < _models.GetSize(); i++)
    {
        if(_models[i]->HitTest(LAppDefine::HitAreaNameHead,x,y))
        {
            if (LAppDefine::DebugLogEnable)
            {
                LAppPal::PrintLog("[APP]hit area: [%s]", LAppDefine::HitAreaNameHead);
            }
            _models[i]->SetRandomExpression();//设计随机运动
        }
        else if (_models[i]->HitTest(LAppDefine::HitAreaNameBody, x, y))
        {
            if (LAppDefine::DebugLogEnable)
            {
                LAppPal::PrintLog("[APP]hit area: [%s]", LAppDefine::HitAreaNameBody);
            }
            _models[i]->StartRandomMotion(LAppDefine::MotionGroupTapBody, LAppDefine::PriorityNormal);
        }
    }
}

- (void)onUpdate;
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int width = screenRect.size.width;
    int height = screenRect.size.height;
    Csm::CubismMatrix44 projection;
    
    projection.Scale(2.0f, 2 *static_cast<float>(width) / static_cast<float>(height));
    
    if (_viewMatrix != nil)
    {
        projection.MultiplyByMatrix(_viewMatrix);
    }
    
    Csm::CubismMatrix44    saveProjection = projection;
    Csm::csmUint32 modelCount = _models.GetSize();
    for (Csm::csmUint32 i = 0; i < modelCount; ++i)
    {
        LAppModel* model = [self getModel:i];
        projection = saveProjection;
        
        if (i == 1){
            projection.Translate(-0.4, 0.4);//模型的位置 x,y
        }else{
            projection.Translate(0.5, -1.05);
        }
        
        model->Update();
        
        model->Draw(projection);///< 参照渡しなのでprojectionは変質する
    }
}

- (void)nextScene;
{
    Csm::csmInt32 no = (_sceneIndex + 1) % LAppDefine::ModelDirSize;
    [self changeScene:no];
}

- (void)changeScene:(Csm::csmInt32)index;
{
    _sceneIndex = index;
    if (LAppDefine::DebugLogEnable)
    {
        LAppPal::PrintLog("[APP]model index: %d", _sceneIndex);
    }
    
    // ModelDir[]に保持したディレクトリ名から
    // model3.jsonのパスを決定する.
    // ディレクトリ名とmodel3.jsonの名前を一致させておくこと.
    std::string model = LAppDefine::ModelDir[index]; //模型名称
    std::string modelPath = LAppDefine::ResourcesPath + model + "/"; //模型路径
    std::string modelJsonName = LAppDefine::ModelDir[index]; //json名称
    modelJsonName += ".model3.json"; //json 名称 和 格式
    
    [self releaseAllModel]; //清空容器,保证每次切换场景时,容器里面只有一个模型
    
    _models.PushBack(new LAppModel()); //压栈
    _models[0]->LoadAssets(modelPath.c_str(), modelJsonName.c_str());
    
    std::string model1 = LAppDefine::ModelDir[1]; //模型名称
    std::string modelPath1 = LAppDefine::ResourcesPath + model1 + "/"; //模型路径
    std::string modelJsonName1 = LAppDefine::ModelDir[1]; //json名称
    modelJsonName1 += ".model3.json"; //json 名称 和 格式

    _models.PushBack(new LAppModel()); //压栈
    _models[1]->LoadAssets(modelPath1.c_str(), modelJsonName1.c_str());
    
}

//设置某个小偶的 动作
-(void)setModelActionWithNo : (Csm::csmUint32) index actionNum : (Csm::csmUint32)actionNum;
{
    LAppModel *model = [self getModel:index];
    model -> StartMotion(LAppDefine::MotionGroupIdle,actionNum, LAppDefine::PriorityForce);
}

-(void)setModelTextureWithNo:(Csm::csmUint32)index;
{
    
    //样式 1
    //    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)lastObject];
    //
    //    NSString *homePath = [documentPath stringByAppendingString:@"/Res/export/export.model3.json"];
    //
    //    NSData *data = [NSData dataWithContentsOfFile:homePath];
    //
    //    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
    //    NSArray *textureArray = [dict objectForKey:@"Textures"];
    
    //样式2
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)lastObject];
    
    NSString *moreStr = [NSString stringWithFormat:@"/Res/%@/%@.model3.json",@"export",@"export"];
    
    moreStr= [moreStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *homePath = [documentPath stringByAppendingString:moreStr];
    
    NSData *data = [NSData dataWithContentsOfFile:homePath];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSMutableDictionary *fileDict = [dict objectForKey:@"FileReferences"];
    
    NSMutableArray *textureArray = [NSMutableArray array];
    
    textureArray = [fileDict objectForKey:@"Textures"];
    
    for (int i = 0; i < textureArray.count; i++){
        if ([textureArray[i] containsString:@"texture_19.png"]){
            NSString *replace = [NSString stringWithFormat:@"%@.1024/%@.png",@"export",@"texture_17"];
            [textureArray replaceObjectAtIndex:i withObject:replace];
        }
        textureArray[i] = [textureArray[i] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    
    [fileDict setObject:textureArray forKey:@"Textures"];
    
    [dict setObject:fileDict forKey:@"FileReferences"];
    
    //    BOOL isWriteable = [fileManage isWritableFileAtPath:homePath];
    
    NSData *changeData = [NSJSONSerialization dataWithJSONObject:dict options:(NSJSONReadingMutableLeaves) error:nil];
    
    BOOL isSuccess = [changeData writeToFile:homePath options:(NSDataWritingAtomic) error:nil];
    
    //样式3 文件句柄
    //    NSFileHandle *readAndWriteHandle = [NSFileHandle fileHandleForUpdatingAtPath:homePath];
    
    
    
    
}



-(void)setModelTextureWithNo:(Csm::csmUint32)index model:(NSString *)fileName beforeTexture:(NSString *)beforeTexture afterTexture:(NSString *)afterTexture{
    
    //    NSArray *main = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"Res/"];
    //
    //    NSString *path = [NSString stringWithFormat:@"%@/Res/",NSHomeDirectory()];
    //    NSString *bundlename = @"Model.bundle";
    //
    //    NSString *bundlePath = [path stringByAppendingString:bundlename];
    //    NSBundle *mainBundle = [NSBundle bundleWithPath:bundlePath];
    //
    //    NSString *jsonPath = [mainBundle pathForResource:@"export.model3.json" ofType:nil];
    
    //    NSFileManager *fileManage = [NSFileManager defaultManager];
    //
    //    NSArray *files = [fileManage subpathsAtPath:bundlePath];
    
    
    NSString *filePath = [NSString stringWithFormat:@"/Res/%@/%@.model3.json",fileName];
    NSString *homePath = [NSHomeDirectory() stringByAppendingPathComponent:filePath];
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:homePath];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
    
    [self onUpdate];
    
}




//修改 某个 小偶的x,y以及比例
- (void)onUpdateWithModelNum:(GLuint)num Varx:(CGFloat)x y:(CGFloat)y scale:(CGFloat)scale ;
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int width = screenRect.size.width;
    int height = screenRect.size.height;
    Csm::CubismMatrix44 projection;
    
    projection.Scale(scale, scale * static_cast<float>(width) / static_cast<float>(height));
    
    if (_viewMatrix != nil)
    {
        projection.MultiplyByMatrix(_viewMatrix);
    }
    
    Csm::CubismMatrix44    saveProjection = projection;
    Csm::csmUint32 modelCount = _models.GetSize();
    
    if (num > modelCount){ //确保修改的模型存在
        return;
    }
    
    for (Csm::csmUint32 i = 0; i < modelCount; ++i)
    {
        LAppModel* model = [self getModel:i];
        projection = saveProjection;
        if (i == num){
            projection.Translate(x,y);//模型的位置 x,y
        }
        model->Update();
        model->Draw(projection);///< 参照渡しなのでprojectionは変質する
    }
}




@end


