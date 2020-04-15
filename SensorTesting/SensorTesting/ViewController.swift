//
//  ViewController.swift
//  SensorTesting
//
//  Created by Lia Kassardjian on 17/06/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
 
    let motionManager = MotionManager()
    
    
    var animator:UIDynamicAnimator? = nil
    
    var balls:[UIView] = []
    var yPositions:[CGPoint] = []
    let colors = [#colorLiteral(red: 1, green: 0.1367589235, blue: 0.2771877348, alpha: 1),#colorLiteral(red: 0.8382436633, green: 0, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 0.4022022188, blue: 0, alpha: 1),#colorLiteral(red: 0, green: 1, blue: 0.6779490709, alpha: 1),#colorLiteral(red: 0, green: 0.7733957171, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 0, blue: 0.6808319688, alpha: 1),#colorLiteral(red: 0.1454425454, green: 0.2908638716, blue: 1, alpha: 1),#colorLiteral(red: 0.4930205345, green: 0, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 0.7930418849, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0.5506727099, blue: 0, alpha: 1)]
    
    var ball: UIView?
   
    override func viewDidLoad() {
        super.viewDidLoad()
//        addBalls()
        motionManager.startDeviceMotion()
//        createAnimator()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        motionManager.motion.stopDeviceMotionUpdates()
    }
    
    func calculatePositions() {
        var height:CGFloat = 0
        var width:CGFloat = 0
        if let view = self.view {
            height = view.frame.height
            width = view.frame.width
        }
        
       for _ in 0..<colors.count {
            let randomX = CGFloat.random(in: 0..<width)
            let randomY = CGFloat.random(in: 0..<height)
            let p = CGPoint(x: randomX, y: randomY)
            yPositions.append(p)
        }
    }
    
    func addBalls() {
        calculatePositions()
        for i in 0..<colors.count {
            let ball = createBall(position: yPositions[i], color: colors[i])
            balls.append(ball)
        }
    }
    
    func addBall(at position: CGPoint) {
        ball = createBall(position: position, color: .red)
    }
    
    func createBall(position: CGPoint, color: UIColor) -> UIView {
        let ball = UIView(frame: CGRect(x: position.x, y: position.y, width: 60, height: 60))
        ball.layer.cornerRadius = ball.frame.height/2
        ball.backgroundColor = color
        
        self.view.insertSubview(ball, at: 0)
        
        motionManager.collider.addItem(ball)
        motionManager.gravity.addItem(ball)
        
        return ball
    }
    
    func createAnimator() {
        animator = UIDynamicAnimator(referenceView: self.view)
        
        // Permite que as bolas colidam com objetos
        motionManager.collider.translatesReferenceBoundsIntoBoundary = true
        animator?.addBehavior(motionManager.collider)
        
        // Permite que as bolas apresentem comportamento gravitacional
        animator?.addBehavior(motionManager.gravity)
    }

    
    // Ao tocar na tela, recoloca as bolas em suas posições iniciais
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self.view)
            print("Started at \(location)")
            addBall(at: location)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self.view)
            print("Moved to \(location)")
            ball?.center = location
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            print("Ended at \(t.location(in: self.view))")
            ball?.removeFromSuperview()
            ball = nil
        }
    }
    
    
    
}

