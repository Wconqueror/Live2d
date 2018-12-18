/*
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at http://live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#ifndef LAppDefine_h
#define LAppDefine_h

#import <Foundation/Foundation.h>
#import <CubismFramework.hpp>

/**
 * @brief  Sample Appで使用する定数
 *
 */
namespace LAppDefine {
    
    using namespace Csm;
    
    extern const csmFloat32 ViewMaxScale;           ///< 比例因子的最大值
    extern const csmFloat32 ViewMinScale;           ///< 拡大縮小率の最小値
    
    extern const csmFloat32 ViewLogicalLeft;        ///< 逻辑视图坐标系的左端值
    extern const csmFloat32 ViewLogicalRight;       ///< 論理的なビュー座標系の右端の値
    
    extern const csmFloat32 ViewLogicalMaxLeft;     ///< 逻辑视图坐标系左端的最大值
    extern const csmFloat32 ViewLogicalMaxRight;    ///< 論理的なビュー座標系の右端の最大値
    extern const csmFloat32 ViewLogicalMaxBottom;   ///< 論理的なビュー座標系の下端の最大値
    extern const csmFloat32 ViewLogicalMaxTop;      ///< 論理的なビュー座標系の上端の最大値
    
    extern const csmChar* ResourcesPath;            ///< 素材パス
    extern const csmChar* BackImageName;         ///< 背景画像ファイル
    extern const csmChar* GearImageName;         ///< 歯車画像ファイル
    extern const csmChar* PowerImageName;        ///< 終了ボタン画像ファイル
    
    // モデル定義--------------------------------------------
    extern const csmChar* ModelDir[];               ///< モデルを配置したディレクトリ名の配列. ディレクトリ名とmodel3.jsonの名前を一致させておく.
    extern const csmInt32 ModelDirSize;             ///< 模型目录数组的大小
    
    // 与外部定义文件（json）结合使用
    extern const csmChar* MotionGroupIdle;          ///< 在空闲时播放的动作列表
    extern const csmChar* MotionGroupTapBody;       ///< 点击身体时要进行的动作列表
    
    // 与外部定义文件（json）结合使用
    extern const csmChar* HitAreaNameHead;          ///< 击中判断的标题
    extern const csmChar* HitAreaNameBody;          ///< 当たり判定の[Body]タグ
    
    // 运动的优先级常数
    extern const csmInt32 PriorityNone;             ///< 运动的优先级常数: 0
    extern const csmInt32 PriorityIdle;             ///< 运动的优先级常数: 1
    extern const csmInt32 PriorityNormal;           ///< 运动的优先级常数: 2
    extern const csmInt32 PriorityForce;            ///< 运动的优先级常数: 3
    
    // 显示调试日志
    extern const csmBool DebugLogEnable;            ///< 启用/禁用调试日志显示
    extern const csmBool DebugTouchLogEnable;       ///< 启用/禁用触摸处理的调试日志显示
    
    // Framework 日志输出的级别设置
    extern const CubismFramework::Option::LogLevel CubismLoggingLevel;
}

#endif /* LAppDefine_h */
