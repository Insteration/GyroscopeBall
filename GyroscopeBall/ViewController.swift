//
//  ViewController.swift
//  GyroscopeBall
//
//  Created by Artem Karmaz on 4/23/19.
//  Copyright © 2019 Johansson Group. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var coordinatesLabel: UILabel!
    
    private let ball = UIView()
    private let label = UILabel()
    private var motionManager = CMMotionManager()
    private var timer = Timer()
    
    fileprivate func motionManagerAccelerometerMethod() {
        if motionManager.isAccelerometerAvailable {
            
            motionManager.accelerometerUpdateInterval = 0.01
            
            motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
                guard let data = data, error == nil else { return }

                let currentX = (Double(self.view.frame.size.width) / 2)
                let currentY = (Double(self.view.frame.size.height) / 2)
                
                Model.ball.destX = currentX + (data.acceleration.x * 250)
                Model.ball.destY = currentY - (data.acceleration.y * 250)
                
                if Model.ball.destX > (Double(self.view.frame.size.width) - 50) {
                    Model.ball.xReverse = -1
                } else if Model.ball.destX < 1 {
                    Model.ball.xReverse = 1
                }
                
                if Model.ball.xReverse > 0 {
                    Model.ball.destX += 1
                } else {
                    Model.ball.destX -= 1
                }
                
                if Model.ball.destY > (Double(self.view.frame.size.width) - 50) {
                    if Model.ball.destX > Double(self.view.frame.size.width) {
                        Model.ball.destY = 0
                    }
                    
                    Model.ball.yReverse = -1
                    
                } else if Model.ball.destY < 1 {
                    Model.ball.yReverse = 1
                }
                
                if Model.ball.yReverse > 0 {
                    Model.ball.destY += 1
                } else {
                    Model.ball.destY -= 1
                }
                
                self.coordinatesLabel.text = "X \(String(format: "%2.2f", Model.ball.destX)) , Y \(String(format: "%2.2f" , Model.ball.destY))"
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        motionManagerAccelerometerMethod()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createLabel()
        createTimer()
    }

    private func createViewBall(x: Double, y: Double) {
        ball.frame = CGRect(x: x, y: y, width: 50, height: 50)
        ball.layer.cornerRadius = 0.5 * ball.bounds.size.width
        ball.backgroundColor = .red
        ball.layer.borderColor = UIColor.black.cgColor
        ball.layer.borderWidth = 4
        ball.layer.shadowColor = UIColor.black.cgColor
        ball.layer.shadowOpacity = 1
        ball.layer.shadowOffset = CGSize.zero
        ball.layer.shadowRadius = 10
    }
    
    private func createLabel() {
        label.frame = CGRect(x: 13, y:  0, width: 50, height: 50)
        label.text = "B"
        label.font = .systemFont(ofSize: 40)
        label.textColor = .white
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 1
        label.layer.shadowOpacity = 1
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.masksToBounds = false
        ball.addSubview(label)
    }
    
    private func createTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(moveBallView), userInfo: nil, repeats: true)
    }
    
    @objc func moveBallView() {
        createViewBall(x: Model.ball.destX, y: Model.ball.destY)
        self.view.addSubview(ball)
    }
}

