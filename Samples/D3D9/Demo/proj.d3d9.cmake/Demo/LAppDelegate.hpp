﻿/*
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at http://live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#pragma once

#include <Rendering/D3D9/CubismNativeInclude_D3D9.hpp>
#include "LAppAllocator.hpp"

class LAppView;
class LAppTextureManager;

/**
* @brief   アプリケーションクラス。
*   Cubism3の管理を行う。
*/
class LAppDelegate
{
public:

    /**
     * @brief   D3Dデバイスの取得
     */
    static LPDIRECT3DDEVICE9   GetD3dDevice();

    /**
     * @brief   ウィンドウクライアント領域取得
     */
    static void GetWindowRect(RECT& rect);

    /**
     * @brief   ウィンドウクライアント領域の幅、高さ取得
     */
    static void GetClientSize(int& rWidth, int& rHeight);

    /**
    * @brief   クラスのインスタンス（シングルトン）を返す。<br>
    *           インスタンスが生成されていない場合は内部でインスタンを生成する。
    *
    * @return  クラスのインスタンス
    */
    static LAppDelegate* GetInstance();

    /**
    * @brief   クラスのインスタンス（シングルトン）を解放する。
    *
    */
    static void ReleaseInstance();
    
    /**
    * @brief   APPに必要なものを初期化する。
    */
    bool Initialize();
    
    /**
    * @brief   解放する。
    */
    void Release();
    
    /**
    * @brief   実行処理。
    */
    void Run();

    /**
     * @brief   デバイス再作成 ウィンドウサイズ変更の時など
     *           ロスト対応の+α処理を行う
     */
    void RecreateDevice();

    /**
     * @brief   View情報を取得する。
     */
    LAppView* GetView() { return _view; }

    /**
    * @brief   アプリケーションを終了するかどうか。
    */
    bool GetIsEnd() { return _isEnd; }

    /**
    * @brief   アプリケーションを終了する。
    */
    void AppEnd() { _isEnd = true; }

    LAppTextureManager* GetTextureManager() { return _textureManager; }

    /**
     * @brief   フレーム最初の行動
     */
    void StartFrame();

    /**
     * @brief   フレーム最後の行動
     */
    void EndFrame();

    /**
     * @brief   スプライト描画用シェーダの作成と頂点宣言の作成を行う
     */
    bool CreateShader();

    /**
     * @brief   スプライト描画時、頂点宣言をセットするとともにシェーダエフェクトを返す
     */
    ID3DXEffect* SetupShader();

    /**
     * @brief   CreateShaderで確保したオブジェクトの開放
     */
    void ReleaseShader();


private:

    enum LostStep
    {
        LostStep_None,      ///< 平常 
        LostStep_Lost,      ///< ロスト中 
        LostStep_ReCreate,  ///< Deviceごと再作成 
    };

    /**
     * @brief   ウィンドウプロシージャ
     */
    static LRESULT WINAPI MsgProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

    /**
    * @brief   コンストラクタ
    */
    LAppDelegate();

    /**
    * @brief   デストラクタ
    */
    ~LAppDelegate();

    /**
    * @brief   Cubism3の初期化
    */
    void InitializeCubism();

    LAppAllocator _cubismAllocator;              ///< Cubism3 Allocator
    Csm::CubismFramework::Option _cubismOption;  ///< Cubism3 Option

    LAppView* _view;                             ///< View情報
    bool _captured;                              ///< クリックしているか
    float _mouseX;                               ///< マウスX座標
    float _mouseY;                               ///< マウスY座標
    bool _isEnd;                                 ///< APP終了しているか
    LAppTextureManager* _textureManager;         ///< テクスチャマネージャー

    HWND _windowHandle;                     ///< ウィンドウハンドル 
    LPDIRECT3D9             _direct3D;      ///< D3D 
    LPDIRECT3DDEVICE9       _device;        ///< D3Dデバイス 
    WNDCLASSEX              _windowClass;   ///< ウィンドウクラス 
    LostStep                _deviceLostStep;///< デバイス解放中 
    D3DPRESENT_PARAMETERS   _presentParameters;     ///< プレゼントパラメータ 

    ID3DXEffect*                    _shaderEffect;  ///< スプライト描画用シェーダ 
    IDirect3DVertexDeclaration9*    _vertexFormat;  ///< スプライト描画用型宣言 
};
