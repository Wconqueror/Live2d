/*
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at http://live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#ifndef TouchManager_h
#define TouchManager_h

@interface TouchManager : NSObject

@property (nonatomic, readonly) float startX; // 触摸开始时x的值
@property (nonatomic, readonly) float startY; // タッチを開始した時のxの値
@property (nonatomic, readonly, getter=getX) float lastX; // シングルタッチ時のxの値
@property (nonatomic, readonly, getter=getY) float lastY; // タッチを開始した時のxの値
@property (nonatomic, readonly, getter=getX1) float lastX1; // シングルタッチ時のyの値
@property (nonatomic, readonly, getter=getY1) float lastY1; // ダブルタッチ時の一つ目のyの値
@property (nonatomic, readonly, getter=getX2) float lastX2; // 双触摸时x的第一个值
@property (nonatomic, readonly, getter=getY2) float lastY2; // ダブルタッチ時の一つ目のxの値
@property (nonatomic, readonly) float lastTouchDistance; // 用2个或更多触摸时的手指距离
@property (nonatomic, readonly) float deltaX; // 将x的距离从前一个值移动到当前值。
@property (nonatomic, readonly) float deltaY; // 将y的距离从前一个值移动到当前值。
@property (nonatomic, readonly) float scale; // 放大倍率在此帧中相乘。扩展操作期间除1以外。
@property (nonatomic, readonly) float touchSingle; // 单触即可
@property (nonatomic, readonly) float flipAvailable; // 翻转是否有效

/**
 * @brief 初期化
 */
- (id)init;

/**
 * @brief 解放処理
 */
- (void)dealloc;
    
/*
 * @brief タッチ開始時イベント
 *
 * @param[in] deviceY    您触摸的屏幕上的y值
 * @param[in] deviceX    您触摸的屏幕上的x值
 */
- (void)touchesBegan:(float)deviceX DeciveY:(float)deviceY;
    
/*
 * @brief ドラッグ時のイベント
 *
 * @param[in] deviceX    タッチした画面のyの値
 * @param[in] deviceY    タッチした画面のxの値
 */
- (void)touchesMoved:(float)deviceX DeviceY:(float)deviceY;

/*
 * @brief ドラッグ時のイベント
 *
 * @param[in] deviceX1   第一个触摸屏幕的x值
 * @param[in] deviceY1   1つめのタッチした画面のyの値
 * @param[in] deviceX2   第二个触摸屏的x值
 * @param[in] deviceY2   2つめのタッチした画面のyの値
 */
- (void)touchesMoved:(float)deviceX1 DeviceY1:(float)deviceY1 DeviceX2:(float) deviceX2 DeviceY2:(float)deviceY2;

/*
 * @brief 轻弹的距离测量
 *
 * @return フリック距離
 */
- (float)getFlickDistance;
    
/*
 * @brief 找到从第1点到第2点的距离
 *
 * @param[in] x1 1つめのタッチした画面のxの値
 * @param[in] y1 1つめのタッチした画面のyの値
 * @param[in] x2 2つめのタッチした画面のxの値
 * @param[in] y2 2つめのタッチした画面のyの値
 * @return   2点の距離
 */
- (float)calculateDistance:(float)x1 TouchY1:(float)y1 TouchX2:(float)x2 TouchY2:(float)y2;

/*
 * 从这两个值中，获得移动量。
 * 違う方向の場合は移動量０。同じ方向の場合は、絶対値が小さい方の値を参照する
 *
 * @param[in] v1    1つめの移動量
 * @param[in] v2    2つめの移動量
 *
 * @return   小さい方の移動量
 */
- (float)calculateMovingAmount:(float)v1 Vector2:(float)v2;

@end

#endif /* TouchManager_h */
