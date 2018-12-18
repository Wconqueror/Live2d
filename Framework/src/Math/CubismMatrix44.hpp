/*
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at http://live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#pragma once

#include "Type/CubismBasicType.hpp"

namespace Live2D { namespace Cubism { namespace Framework {

/**
 * @brief 4x4矩阵
 *
 * 方便的4x4矩阵类。
 */
class CubismMatrix44
{
public:
    /**
     * @brief 构造函数
     *
     * コンストラクタ。
     */
    CubismMatrix44();

    /**
     * @brief デストラクタ
     *
     * デストラクタ。
     */
    virtual ~CubismMatrix44();

    /**
     * @brief 乗算
     *
     * 执行两个接收矩阵的乘法运算。
     *
     * @param[in]   a   行列a
     * @param[in]   b   行列b
     * @param[out]  dst 目的地矩阵
     */
    static void Multiply(csmFloat32* a, csmFloat32* b, csmFloat32* dst);

    /**
     * @brief 初始化为单位矩阵
     *
     * 単位行列に初期化する。
     */
    void            LoadIdentity();

    /**
     * @brief 获取矩阵作为浮点数的数组
     *
     * 行列を浮動小数点数の配列で取得する。
     *
     * @return  由16个浮点数表示的4×4矩阵
     */
    csmFloat32*     GetArray();

    /**
     * @brief 行列を設定
     *
     * 行列を設定する。
     *
     * @param[in]   tr  由16个浮点数表示的4×4矩阵
     */
    void            SetMatrix(csmFloat32* tr);

    /**
     * @brief 获得X轴的放大率
     *
     * X軸の拡大率を取得する。
     *
     * @return  X軸の拡大率
     */
    csmFloat32      GetScaleX() const;

    /**
     * @brief 获得Y轴的放大率
     *
     * Y軸の拡大率を取得する。
     *
     * @return  Y軸の拡大率
     */
    csmFloat32      GetScaleY() const;

    /**
     * @brief 获取X轴移动量
     *
     * X軸の移動量を取得する。
     *
     * @return  X軸の移動量
     *
     */
    csmFloat32      GetTranslateX() const;

    /**
     * @brief 获取Y轴移动量
     *
     * Y軸の移動量を取得する。
     *
     * @return  Y軸の移動量
     */
    csmFloat32      GetTranslateY() const;

    /**
     * @brief 用当前矩阵计算X轴值
     *
     * X軸の値を現在の行列で計算する。
     *
     * @param[in]   src     X軸の値
     * @return  現在の行列で計算されたX軸の値
     */
    csmFloat32      TransformX(csmFloat32 src);

    /**
     * @brief 用当前矩阵计算Y轴值
     *
     * Y軸の値を現在の行列で計算する。
     *
     * @param[in]   src     Y軸の値
     * @return  現在の行列で計算されたY軸の値
     */
    csmFloat32      TransformY(csmFloat32 src);

    /**
     * @brief 用当前矩阵反演X轴值
     *
     * X軸の値を現在の行列で逆計算する。
     *
     * @param[in]   src     X軸の値
     * @return  現在の行列で逆計算されたX軸の値
     */
    csmFloat32      InvertTransformX(csmFloat32 src);

    /**
     * @brief Y軸の値を現在の行列で逆計算
     *
     * Y軸の値を現在の行列で逆計算する。
     *
     * @parain[in]  src     Y軸の値
     * @return  現在の行列で逆計算されたY軸の値
     */
    csmFloat32      InvertTransformY(csmFloat32 src);

    /**
     * @brief 从当前矩阵位置移动作为起点
     *
     * 現在の行列の位置を起点にして相対的に移動する。
     *
     * @param[in]   x   X軸の移動量
     * @param[in]   y   Y軸の移動量
     */
    void            TranslateRelative(csmFloat32 x, csmFloat32 y);

    /**
     * @brief 現在の行列の位置を移動
     *
     * 現在の行列の位置を指定した位置へ移動する。
     *
     * @param[in]   x   X軸の移動量
     * @param[in]   y   Y軸の移動量
     */
    void            Translate(csmFloat32 x, csmFloat32 y);

    /**
     * @brief 現在の行列のX軸の位置を移動
     *
     * 現在の行列のX軸の位置を指定した位置へ移動する。
     *
     * @param[in]  x    X軸の移動量
     */
    void            TranslateX(csmFloat32 x);

    /**
     * @brief 現在の行列のY軸の位置を移動
     *
     * 現在の行列のY軸の位置を指定した位置へ移動する。
     *
     * @param[in]   y   Y軸の移動量
     */
    void            TranslateY(csmFloat32 y);

    /**
     * @brief 現在の行列の拡大率を相対的に設定
     *
     * 現在の行列の拡大率を相対的に設定する。
     *
     * @param[in]   x   X軸の拡大率
     * @param[in]   y   Y軸の拡大率
     */
    void            ScaleRelative(csmFloat32 x, csmFloat32 y);

    /**
     * @brief 現在の行列の拡大率を設定
     *
     * 現在の行列の拡大率を指定した倍率に設定する。
     *
     * @param[in]   x   X軸の拡大率
     * @param[in]   y   Y軸の拡大率
     */
    void            Scale(csmFloat32 x, csmFloat32 y);

    /**
     * @brief 現在の行列に行列を乗算
     *
     * 現在の行列に行列を乗算する。
     *
     * @param[in]   m   行列
     */
    void            MultiplyByMatrix(CubismMatrix44* m);

protected:
    csmFloat32  _tr[16];     ///< 4x4行列データ
};

}}}
