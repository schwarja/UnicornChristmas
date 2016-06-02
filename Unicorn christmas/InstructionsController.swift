//
//  InstructionsController.swift
//  Unicorn christmas
//
//  Created by Jan Schwarz on 18/12/15.
//  Copyright © 2015 STRV. All rights reserved.
//

import UIKit

class InstructionsController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onGotItTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
