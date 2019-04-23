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
    
    var ball = UIView()
    
    var motionManager = CMMotionManager()
    var timer = Timer()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if motionManager.isAccelerometerAvailable {
            
            motionManager.accelerometerUpdateInterval = 0.01
            
            motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
                guard let data = data, error == nil else { return }
                
                
                
                let currentX = (Double(self.view.frame.size.width) / 2)
                let currentY = (Double(self.view.frame.size.height) / 2)
                Model.ball.destX = currentX + (data.acceleration.x * 250)
                Model.ball.destY = currentY - (data.acceleration.y * 250)
                
                //                print("y - \(Model.ball.destY)")
                //                print("Frame is \((Double(self.view.frame.size.width)))")
                
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
                //                print("x - \(Model.ball.destX)")
                
                
                if Model.ball.destY > (Double(self.view.frame.size.width) - 50) {
                    if Model.ball.destX < 70 {
                        Model.ball.destY = 1
                    }
                    
                    if Model.ball.destX > 375 {
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
                
                print("y - \(Model.ball.destY)")

            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        let label = UILabel()
        label.frame = CGRect(x: 13, y:  0, width: 50, height: 50)
        label.text = "B"
        label.font = .systemFont(ofSize: 40)
        label.textColor = .white
//        label.layer.shadowColor = UIColor.black.cgColor
//        label.layer.shadowRadius = 0.5
//        label.layer.shadowOpacity = 0.5
//        label.layer.shadowOffset = CGSize(width: 1, height: 1)
//        label.layer.masksToBounds = false
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

