//
//  ViewController.swift
//  Unicorn christmas
//
//  Created by Jan Schwarz on 16/12/15.
//  Copyright © 2015 STRV. All rights reserved.
//

import UIKit

class MyImageView: UIImageView {
    
    lazy var minPoint: CGPoint = {
        let minX = self.frame.origin.x
        let minY = self.frame.origin.y
        return CGPointMake(minX, minY)
    }()
    
    lazy var maxPoint: CGPoint = {
        let maxX = self.frame.origin.x + (self.frame.width*0.92)
        let maxY = self.frame.origin.y + (self.frame.height*0.88)
        return CGPointMake(maxX, maxY)
    }()
}

class ViewController: UIViewController {

    @IBOutlet weak var heartButton: UIButton! {
        didSet {
            heartButton.layer.cornerRadius = 10
            heartButton.backgroundColor = UIColor(white: 1, alpha: 0.2)
        }
    }
    @IBOutlet weak var unicornButton: UIButton! {
        didSet {
            unicornButton.layer.cornerRadius = 10
            unicornButton.backgroundColor = UIColor(white: 1, alpha: 0.2)
        }
    }
    
    var hearts = [MyImageView]()
    var unicorns = [UIImageView]()
    
    var heartsConsumed = 0
    var unicornsUsed = 0
    
    var reset = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if !userDefaults.boolForKey("instructionsShown") {
            
            onInstructionsTapped(self)
            
            userDefaults.setBool(true, forKey: "instructionsShown")
            userDefaults.synchronize()
        }
    }
    
    @IBAction func unicornButtonTapped(sender: AnyObject) {
        let y = Int(arc4random_uniform(1000)) % (Int(view.frame.height) - 104)

        let image = UIImageView(frame: CGRectMake(view.frame.width, CGFloat(y), 104, 104))
        image.image = UIImage(named: "icon-unicorn")
        
        view.insertSubview(image, belowSubview: heartButton)
        
        let speed = Double((Int(arc4random_uniform(1000)) % 5) + 1) / 100
        
        let animation = createAnimation((speed*5)+0.5)
        
        image.layer.addAnimation(animation, forKey: "runAnimation")
        
        unicorns.append(image)
        
        reset = false
        
        unicornsUsed++
        animateUnicorn(image, speed: speed)
    }
    
    func createAnimation(speed: Double) -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
        
        animation.values = [NSNumber(double: 0), NSNumber(double: -0.15*M_PI), NSNumber(double: 0.15*M_PI), NSNumber(double: 0)];
        animation.keyTimes = [NSNumber(double: 0.0), NSNumber(double: 0.25), NSNumber(double: 0.75), NSNumber(double: 1.0)];
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear);
        
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = false;
        animation.duration = speed;
        animation.repeatCount = HUGE;
        
        return animation
    }
    
    func animateUnicorn(unicorn: UIImageView, speed: Double) {
        
        self.destroyHearts(byUnicorn: unicorn)
        
        if (unicorn.frame.origin.x + unicorn.frame.width) >= 0 {
            let userInfo = ["unicorn": unicorn, "speed": speed]
            NSTimer.scheduledTimerWithTimeInterval(speed, target: self, selector: Selector("moveUnicorn:"), userInfo: userInfo, repeats: false)
        }
    }
    
    func moveUnicorn(timer: NSTimer) {
        if let unicorn = timer.userInfo?["unicorn"] as? UIImageView,
            let speed = timer.userInfo?["speed"] as? Double where unicorns.contains(unicorn) && (unicorn.frame.origin.x + unicorn.frame.width) > 0 {
                
                let frame = unicorn.frame
                unicorn.frame = CGRectMake(frame.origin.x - 1, frame.origin.y, frame.width, frame.height)
            
                animateUnicorn(unicorn, speed: speed)
        }
        else if let unicorn = timer.userInfo?["unicorn"] as? UIImageView, let index = unicorns.indexOf(unicorn) {
            unicorns.removeAtIndex(index)
        }

        if unicorns.count == 0 && hearts.count == 0 {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            if let winners = userDefaults.objectForKey("winners") as? [String] where !reset {
                
                let points = getPoints()
                
                var isWinner = false
                for var i = 0; i < winners.count; i++ {
                    let result = winners[i].componentsSeparatedByString("#@#")
                    if Int(result[1]) < points {
                        isWinner = true
                    }
                }
                
                if isWinner {
                    let controller = self.storyboard?.instantiateViewControllerWithIdentifier("GameOverController") as! GameOverController
                    controller.points = points
                    controller.modalPresentationStyle = .Custom
                    presentViewController(controller, animated: true, completion: nil)
                }
                
            }

            heartsConsumed = 0
            unicornsUsed = 0
        }
    }
    
    func getPoints() -> Int {
        let coeficient = 10 - ((heartsConsumed < 100 ? heartsConsumed : 99) / 10)
        return Int(ceilf( (Float(heartsConsumed) / Float(unicornsUsed)) * Float(coeficient) ))
    }
    
    func destroyHearts(byUnicorn unicorn: UIImageView) {
        let maxUnicornX = unicorn.frame.origin.x + unicorn.frame.width - 10
        let maxUnicornY = unicorn.frame.origin.y + unicorn.frame.height - 17
        let minUnicornX = unicorn.frame.origin.x + 10
        let minUnicornY = unicorn.frame.origin.y + 15
        
        for var i = hearts.count - 1; i >= 0; i-- {
            let heart = hearts[i]
            if heart.maxPoint.x > minUnicornX && heart.maxPoint.y > minUnicornY && heart.minPoint.x < maxUnicornX && heart.minPoint.y < maxUnicornY {
                hearts.removeAtIndex(i)
                heart.removeFromSuperview()
                heartsConsumed++
            }
        }
    }

    @IBAction func onHeartTapped(sender: AnyObject) {
        let width = (Int(arc4random_uniform(1000)) % 98) + 10
        let x = Int(arc4random_uniform(1000)) % (Int(view.frame.width) - width)
        let y = Int(arc4random_uniform(1000)) % (Int(view.frame.height) - width)
        
        let image = MyImageView(frame: CGRectMake(CGFloat(x), CGFloat(y), CGFloat(width), CGFloat(width)))
        image.image = UIImage(named: "icon-heart")
        
        view.insertSubview(image, belowSubview: heartButton)
        
        hearts.append(image)
    }

    @IBAction func onInstructionsTapped(sender: AnyObject) {
        let instructions = self.storyboard?.instantiateViewControllerWithIdentifier("InstructionsController")
        instructions?.modalPresentationStyle = .Custom
        presentViewController(instructions!, animated: true, completion: nil)
    }
    
    @IBAction func onResultsShow(sender: AnyObject) {
        let instructions = self.storyboard?.instantiateViewControllerWithIdentifier("ResultController")
        instructions?.modalPresentationStyle = .Custom
        presentViewController(instructions!, animated: true, completion: nil)
    }
    
    @IBAction func onNewGameTapped(sender: AnyObject) {
        for var i = unicorns.count-1; i >= 0; i-- {
            let unicorn = unicorns[i]
            unicorn.removeFromSuperview()
            unicorns.removeAtIndex(i)
        }
        
        for var i = hearts.count-1; i >= 0; i-- {
            let heart = hearts[i]
            heart.removeFromSuperview()
            hearts.removeAtIndex(i)
        }
        
        reset = true
    }
}

