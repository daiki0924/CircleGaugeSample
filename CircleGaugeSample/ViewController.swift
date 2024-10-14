//
//  ViewController.swift
//  CircleGaugeSample
//
//  Created by Daiki Kobayashi on 2024/10/14.
//

import UIKit

//class ViewController: UIViewController {
//    private let shapeLayer = CAShapeLayer()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        drawCircle()
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        startAnimation()
//    }
//    
//    /// 円を描くlayer設定
//    private func drawCircle() {
//        // 円のパスを作成
//        let bezierPath = UIBezierPath(
//            // 円の中心を画面の中心にする
//            arcCenter: view.center,
//            // 円の半径を200に設定
//            radius: 100,
//            // 開始角度を0°に設定 (3時の方向が0°になります)
//            startAngle: radian(angle: 0),
//            // 終了角度を360°に設定
//            endAngle: radian(angle: 360),
//            // true: 時計回り, false: 反時計回り
//            clockwise: true
//        )
//        // 線の太さ
//        shapeLayer.lineWidth = 3
//        // 線のカラー
//        shapeLayer.strokeColor = UIColor.blue.cgColor
//        // 円の内側のカラー
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        // 作成したパスを設定する
//        shapeLayer.path = bezierPath.cgPath
//        // 円を描くlayerを設定する
//        view.layer.addSublayer(shapeLayer)
//    }
//    
//    /// 角度をラジアンに変換
//    /// - Parameter angle: 角度
//    /// - Returns: ラジアン
//    private func radian(angle: CGFloat) -> CGFloat {
//        Double.pi / 180 * angle
//    }
//    
//    /// アニメーションを開始する
//    func startAnimation() {
//        // ストロークアニメーションを指定してインスタンス化
//        let animation = CAKeyframeAnimation(keyPath: "strokeEnd")
//        // 今回は0°~360°の円を描くのでvaluesの0は0°になります。
//        // valuesの1は360°になります。
//        animation.values = [0, 1]
//        // 0°から360°まで描くアニメーションを3秒かけて行う
//        animation.duration = 3
//        // アニメーションを行いたいレイヤーに作成したアニメーションを設定する
//        shapeLayer.add(animation, forKey: nil)
//    }
//}

class ViewController: UIViewController {
    // アニメーション
    var animation: CAKeyframeAnimation {
        // ストロークアニメーションを指定してインスタンス化
        let animation = CAKeyframeAnimation(keyPath: "strokeEnd")
        // デリゲート設定
        animation.delegate = self
        // 今回は0°~360°の円を描くのでvaluesの0は0°になります。
        // valuesの1は360°になります。
        animation.values = [0, 1]
        // アニメーションのスピード設定
        animation.speed = 1
        return animation
    }
    
    /// ストロークの色ごとにShapeLayerを分けてこの配列で保持する
    private var shapeLayers: [CAShapeLayer] = []
    /// アニメーション対象の配列index
    private var nextAnimationIndex: Int = 0
    private var space: CGFloat = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        drawCircle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }
    
    /// 円を描くlayer設定
    private func drawCircle() {
        let cgColors = [
            UIColor.blue,
            UIColor.red,
            UIColor.green,
            UIColor.orange
        ].map { $0.cgColor }
        
        cgColors.enumerated().forEach { index, color in
            // 角度
            let angle = CGFloat(360) / CGFloat(cgColors.count)
            // 円のパスを作成
            let bezierPath = UIBezierPath(
                // 円の中心を画面の中心にする
                arcCenter: view.center,
                // 円の半径を100に設定
                radius: 100,
                // 開始角度を0°に設定 (3時の方向が0°になります)
                startAngle: radian(angle: (angle * CGFloat(index)) + space),
                // 終了角度を360°に設定
                endAngle: radian(angle: angle * CGFloat(index + 1) ),
                // true: 時計回り, false: 反時計回り
                clockwise: true
            )
            let shapeLayer = CAShapeLayer()
            // 線の太さ
            shapeLayer.lineWidth = 3
            // 線のカラー
            shapeLayer.strokeColor = color
            // 円の内側のカラー
            shapeLayer.fillColor = UIColor.clear.cgColor
            // 作成したパスを設定する
            shapeLayer.path = bezierPath.cgPath
            // アニメーションを開始するまで非表示にしておく
            shapeLayer.isHidden = true
            shapeLayer.shadowColor = UIColor.white.cgColor
            shapeLayer.shadowRadius = 4
            shapeLayer.shadowOpacity = 1
            shapeLayer.shadowOffset = .zero
            // インスタンス変数の配列に格納しておく
            shapeLayers.append(shapeLayer)
            // 円を描くlayerを設定する
            view.layer.addSublayer(shapeLayer)
        }
    }
    
    /// 角度をラジアンに変換
    /// - Parameter angle: 角度
    /// - Returns: ラジアン
    private func radian(angle: CGFloat) -> CGFloat {
        Double.pi / 180 * angle
    }
    
    /// アニメーションを開始する
    func startAnimation() {
        // アニメーションを行いたいレイヤーに作成したアニメーションを設定する
        let shapeLayer = shapeLayers[nextAnimationIndex]
        shapeLayer.isHidden = false
        shapeLayer.add(animation, forKey: nil)
    }
}


// MARK: - CAAnimationDelegate

extension ViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag else { return }
        if shapeLayers.indices.contains(nextAnimationIndex + 1) {
            nextAnimationIndex += 1
            startAnimation()
        } else {
            nextAnimationIndex = 0
        }
    }
}
