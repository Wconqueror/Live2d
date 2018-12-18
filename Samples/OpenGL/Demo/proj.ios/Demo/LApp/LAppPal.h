/*
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at http://live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#ifndef LAppPal_h
#define LAppPal_h

#import <CubismFramework.hpp>
#import <string>

/**
 * @brief 抽象平台依赖函数 Cubism Platform Abstraction Layer.
 *
 * 平台相关功能，如文件读取和时间采集
 *
 */
class LAppPal
{
public:
    /**
     * @brief ファイルをバイトデータとして読み込む
     *
     * ファイルをバイトデータとして読み込む
     *
     * @param[in]   filePath    読み込み対象ファイルのパス
     * @param[out]  outSize     ファイルサイズ
     * @return                  バイトデータ
     */
    static Csm::csmByte* LoadFileAsBytes(const std::string filePath, Csm::csmSizeInt* outSize);
    
    
    /**
     * @brief バイトデータを解放する
     *
     * バイトデータを解放する
     *
     * @param[in]   byteData    解放したいバイトデータ
     */
    static void ReleaseBytes(Csm::csmByte* byteData);
    
    /**
     * @biref   デルタ時間（前回フレームとの差分）を取得する
     *
     * @return  デルタ時間[ms]
     *
     */
    static double GetDeltaTime() {return s_deltaTime;}
    
    /**
     * @brief 時間を更新する。
     */
    static void UpdateTime();
    
    /**
     * @brief ログを出力する
     *
     * ログを出力する
     *
     * @param[in]   format  書式付文字列
     * @param[in]   ...     (可変長引数)文字列
     *
     */
    static void PrintLog(const Csm::csmChar* format, ...);
    
    /**
     * @brief メッセージを出力する
     *
     * メッセージを出力する
     *
     * @param[in]   message  文字列
     *
     */
    static void PrintMessage(const Csm::csmChar* message);
    
private:
    static double s_currentFrame;
    static double s_lastFrame;
    static double s_deltaTime;
};

#endif /* LAppPal_h */
