/*
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at http://live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#pragma once

#include "CubismModel.hpp"

namespace Live2D {  namespace Cubism {  namespace Framework {

/// 键入声明，指定用户数据的类型
typedef CubismIdHandle  ModelUserDataType;

/**
* @brief 用户数据管理类
*
* ユーザデータをロード、管理、検索インターフェイス、解放までを行う。
*/
class CubismModelUserData
{
public:
    /**
    * @brief 用户数据结构
    *
    * 记录从Json读取的用户数据的结构
    */
    struct CubismModelUserDataNode
    {
        ModelUserDataType   TargetType;     ///< 用户数据目标类型
        CubismIdHandle      TargetId;       ///< 用户数据目标ID
        csmString           Value;          ///< 用户数据
    };

    /**
    * @brief インスタンスの作成
    *
    * インスタンスを作成する。
    *
    * @param[in]   buffer      读取userdata3.json的缓冲区
    * @param[in]   size        缓冲区大小
    * @return      作成されたインスタンス
    */
    static CubismModelUserData* Create(const csmByte* buffer, csmSizeInt size);

    /**
    * @brief インスタンスの破棄
    *
    * インスタンスを破棄する。
    *
    * @param[in]   modelUserData      破棄するインスタンス
    */
    static void Delete(CubismModelUserData* modelUserData);

    /**
    * @brief デストラクタ
    *
    * ユーザーデータ構造体配列を解放する
    */
    virtual ~CubismModelUserData();

    /**
    * @brief ArtMeshのユーザデータのリストの取得
    *
    * ArtMeshのユーザデータのリストの取得する。
    *
    * @return      csmVectorのユーザデータリスト
    */
    const csmVector<const CubismModelUserDataNode*>& GetArtMeshUserDatas() const;

private:

    /**
    * @brief userdata3.jsonのパース
    *
    * userdata3.jsonをパースする。
    *
    * @param[in]   buffer          userdata3.jsonが読み込まれいるバッファ
    * @param[in]   size            バッファのサイズ
    */
    void ParseUserData(const csmByte* buffer, csmSizeInt size);

    csmVector<const CubismModelUserDataNode*>    _userDataNodes;        ///< ユーザデータ構造体配列
    csmVector<const CubismModelUserDataNode*>    _artMeshUserDataNodes; ///< 閲覧リスト保持
};
}}} //--------- LIVE2D NAMESPACE ------------
