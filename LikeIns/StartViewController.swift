//
//  StartViewController.swift
//  LikeIns
//
//  Created by Roy Li on 13/10/18.
//  Copyright © 2018 The Zero2Launch Team. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var getStartedButton: UIButton!
    
    @IBOutlet weak var accountLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let jeremyGif = UIImage.gifImageWithName("aurola")
        imageView.image = jeremyGif
    }
    
    @IBAction func getStarted(_ sender: UIButton) {
        performSegue(withIdentifier: "Register", sender: nil)
    }
    @IBAction func login(_ sender: UIButton) {
        performSegue(withIdentifier: "Login", sender: nil)
    }
    
}
