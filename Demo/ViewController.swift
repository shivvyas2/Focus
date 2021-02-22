//
//  ViewController.swift
//  Demo
//
//  Created by Shiv vyas on 20/02/21.
//

import UIKit
import AVFoundation
import AudioToolbox

class ViewController: UIViewController , CAAnimationDelegate {
    
    
   
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    let foreProgressLayer = CAShapeLayer()
    let backProgressLayer = CAShapeLayer()
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    
    var timer = Timer()
    var isTimerStarted = false
    var isAnimationStarted = false
    var time = 1800
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        drawBackLayer()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func startButtonTapped(_ sender: Any) {
        cancelButton.isEnabled = true
        cancelButton.alpha = 1.0
        
        
        if !isTimerStarted{
            drawForeLayer()
            
            startResumeAnimation()
            startTimer()
            isTimerStarted = true
            startButton.setTitle("Pause", for: .normal)
            startButton.setTitleColor(UIColor.systemGreen, for: .normal)
            
            
            
        }
        else{
            pauseAnimation()
            timer.invalidate()
            isTimerStarted = false
            startButton.setTitle("Resume", for: .normal)
            startButton.setTitleColor(UIColor.systemTeal, for: .normal)
            
            
        }
        
        
    }
    
    
    @IBAction func cancelButtonTaped(_ sender: Any) {
        
        stopAnimation()
        
        
        cancelButton .isEnabled = true
        cancelButton.alpha = 0.5
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(UIColor.systemGreen, for: .normal)
        timer.invalidate()
        time = 1800
        isTimerStarted = false
        timeLabel.text = "30:00"
        //reset
    }
    
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        
    }
    @objc func updateTimer(){
        if time < 1{
            AudioServicesPlaySystemSound(SystemSoundID(1000))
            cancelButton.isEnabled = false
            cancelButton.alpha = 0.5
            startButton.setTitle("Start", for: .normal)
            startButton.setTitleColor(UIColor.systemTeal, for: .normal)
            timer.invalidate()
            time = 1800
            isTimerStarted = false
            timeLabel.text = "30.00"
            
            
            
        }
        else{
        time -= 1
        timeLabel.text = formatTime()
          
        
        }
    }

    func formatTime()->String{
         let minutes = Int(time) / 60 % 60
        
        
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
  
  }
    //Background Layer for Timer
    func drawBackLayer(){
        backProgressLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y : view.frame.midY), radius: 150, startAngle: -90.degreeToRadians, endAngle: 270.degreeToRadians, clockwise: true).cgPath
        
        backProgressLayer.strokeColor = UIColor.systemGreen.cgColor
        backProgressLayer.fillColor = UIColor.clear.cgColor
        backProgressLayer.lineWidth = 30

        view.layer.addSublayer(backProgressLayer)
    }
    
    //Foreground Layer for Timer
    func drawForeLayer(){
        foreProgressLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y : view.frame.midY), radius: 110, startAngle: -90.degreeToRadians, endAngle: 270.degreeToRadians, clockwise: true).cgPath
        foreProgressLayer.strokeColor = UIColor.orange.cgColor
        foreProgressLayer.fillColor = UIColor.clear.cgColor
        foreProgressLayer.lineWidth = 25
        view.layer.addSublayer(foreProgressLayer)
    }
    
    func startResumeAnimation(){
        if !isAnimationStarted{
            startAnimation()
        }
        else{
            resumeAnimation()
            
        }
    }
  
    func startAnimation(){
        resetAnimation()
        foreProgressLayer.strokeEnd = 0.0
        animation.keyPath = "strokeEnd"
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1800
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.isAdditive = true
        animation.fillMode = CAMediaTimingFillMode.forwards
        foreProgressLayer.add(animation,forKey: "strokeEnd")
        isAnimationStarted = true
     
        
        
    }
    //Reset Progress Bar
    
    
    func resetAnimation(){
        
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        foreProgressLayer.strokeEnd = 0.0
        isAnimationStarted = false
        AudioServicesPlaySystemSound(SystemSoundID(1000))
        
        
    }
    
    func pauseAnimation(){
        let pausedTime = foreProgressLayer.convertTime(CACurrentMediaTime(), from: nil)
        foreProgressLayer.speed = 0.0
        foreProgressLayer.timeOffset = pausedTime
        
    }
    
    func resumeAnimation(){
        let pausedTime = foreProgressLayer.timeOffset
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        let timeSincePaused = foreProgressLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        foreProgressLayer.beginTime = timeSincePaused
    }
    
    func stopAnimation(){
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        foreProgressLayer.strokeEnd = 0.0
        foreProgressLayer.removeAllAnimations()
        isAnimationStarted = false
        
    }
    internal func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        stopAnimation()
    }
    
    
}// end of ViewController
extension Int{
    var degreeToRadians : CGFloat{
        return CGFloat(self) * .pi / 180
    }
}
