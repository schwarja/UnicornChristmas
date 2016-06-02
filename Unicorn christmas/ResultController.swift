//
//  ResultController.swift
//  Unicorn christmas
//
//  Created by Jan Schwarz on 19/12/15.
//  Copyright © 2015 STRV. All rights reserved.
//

import UIKit

class ResultController: UIViewController {

    @IBOutlet weak var user1: UILabel!
    @IBOutlet weak var user2: UILabel!
    @IBOutlet weak var user3: UILabel!
    @IBOutlet weak var user4: UILabel!
    @IBOutlet weak var user5: UILabel!
   
    @IBOutlet weak var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let winners = userDefaults.objectForKey("winners") as? [String] {
            let result1 = winners[0].stringByReplacingOccurrencesOfString("#@#", withString: " - ")
            let result2 = winners[1].stringByReplacingOccurrencesOfString("#@#", withString: " - ")
            let result3 = winners[2].stringByReplacingOccurrencesOfString("#@#", withString: " - ")
            let result4 = winners[3].stringByReplacingOccurrencesOfString("#@#", withString: " - ")
            let result5 = winners[4].stringByReplacingOccurrencesOfString("#@#", withString: " - ")
            user1.text = result1 == " - 0" ? "" : result1
            user2.text = result2 == " - 0" ? "" : result2
            user3.text = result3 == " - 0" ? "" : result3
            user4.text = result4 == " - 0" ? "" : result4
            user5.text = result5 == " - 0" ? "" : result5
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onDoneTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
