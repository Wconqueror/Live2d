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
 * @brief 抽象内存分配的类
 *
 * 内存分配/释放处理在平台端实现
 * 从框架调用的接口。
 *
 */
class ICubismAllocator
{
public:
    /**
     * @brief デストラクタ
     *
     * デストラクタ。
     */
    virtual ~ICubismAllocator() {}

    /**
     * @brief アラインメント制約なしのヒープ・メモリーを確保します。
     *
     * @param[in]  size   確保するバイト数
     *
     * @return     成功すると割り当てられたメモリのアドレス。 そうでなければ '0'を返す。
     */
    virtual void* Allocate(const csmUint32 size) = 0;

    /**
     * @brief アラインメント制約なしのヒープ・メモリーを解放します。
     *
     * @param[in]  memory   解放するメモリのアドレス
     *
     */
    virtual void Deallocate(void* memory) = 0;


    /**
     * @brief 使用对齐约束保护堆内存。
     *
     * @param[in]  size       確保するバイト数
     * @param[in]  alignment  メモリーブロックのアラインメント幅
     *
     * @return     成功すると割り当てられたメモリのアドレス。 そうでなければ '0'を返す。
     */
    virtual void* AllocateAligned(const csmUint32 size, const csmUint32 alignment) = 0;

    /**
     * @brief アラインメント制約ありのヒープ・メモリーを解放します。
     *
     * @param[in]  alignedMemory       解放するメモリのアドレス
     *
     */
    virtual void DeallocateAligned(void* alignedMemory) = 0;

};
}}}
