//
//  GameOverController.swift
//  Unicorn christmas
//
//  Created by Jan Schwarz on 19/12/15.
//  Copyright © 2015 STRV. All rights reserved.
//

import UIKit

class GameOverController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var statisticsLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var points: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = 10
        txtName.layer.cornerRadius = 3
        txtName.backgroundColor = UIColor(white: 1, alpha: 0.1)
        statisticsLabel.text = "Points: \(points)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        txtName.becomeFirstResponder()
    }
    
    @IBAction func onDoneTapped(sender: AnyObject) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let winners = userDefaults.objectForKey("winners") as? [String] {
            
            var newTable = [String]()
            for var i = 0; i < winners.count; i++ {
                let result = winners[i].componentsSeparatedByString("#@#")
                if Int(result[1]) < points {
                    newTable.append(String(format: "%@#@#%i", txtName.text ?? "", points))
                    points = 0
                }
                newTable.append(winners[i])
            }
            
            userDefaults.setObject(newTable, forKey: "winners")
            userDefaults.synchronize()
        }

        dismissViewControllerAnimated(true, completion: nil)
    }

}

extension GameOverController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        txtName.resignFirstResponder()
        return true
    }
}
