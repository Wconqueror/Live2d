/*
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at http://live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#import <Foundation/Foundation.h>
#import "LAppDefine.h"

namespace LAppDefine {
    
    using namespace Csm;
    
    // 画面
    const csmFloat32 ViewMaxScale = 2.0f;
    const csmFloat32 ViewMinScale = 0.8f;
    
    const csmFloat32 ViewLogicalLeft = -1.0f;
    const csmFloat32 ViewLogicalRight = 1.0f;
    
    const csmFloat32 ViewLogicalMaxLeft = -2.0f;
    const csmFloat32 ViewLogicalMaxRight = 2.0f;
    const csmFloat32 ViewLogicalMaxBottom = -2.0f;
    const csmFloat32 ViewLogicalMaxTop = 2.0f;
    
    // 相対パス
    const csmChar* ResourcesPath = "Res/";
    
    // 模型背后的背景图像文件
    const csmChar* BackImageName = "back_class_normal.png";
    // 齿轮
    const csmChar* GearImageName = "icon_gear.png";
    // 退出按钮
    const csmChar* PowerImageName = "Close.png";
    
    // 模型定义
    // 放置模型的目录名称数组
    // 使目录名称和model3.json匹配的名称
    const csmChar* ModelDir[] = {
          "export",
          "export_example_PNG"
//        "Haru",
//        "Hiyori",
//        "Mark"
    };
    const csmInt32 ModelDirSize = sizeof(ModelDir) / sizeof(const csmChar*);
    
    // 外部定義ファイル(json)と合わせる
    const csmChar* MotionGroupIdle = "Idle"; // アイドリング
    const csmChar* MotionGroupTapBody = "TapBody"; // 体をタップしたとき
    
    // 外部定義ファイル(json)と合わせる
    const csmChar* HitAreaNameHead = "Head";
    const csmChar* HitAreaNameBody = "Body";
    
    // モーションの優先度定数
    const csmInt32 PriorityNone = 0;
    const csmInt32 PriorityIdle = 1;
    const csmInt32 PriorityNormal = 2;
    const csmInt32 PriorityForce = 3;
    
    // 调试日志显示选项
    const csmBool DebugLogEnable = true;
    const csmBool DebugTouchLogEnable = false;
    
    // Frameworkから出力するログのレベル設定
    const CubismFramework::Option::LogLevel CubismLoggingLevel = CubismFramework::Option::LogLevel_Verbose;
}
