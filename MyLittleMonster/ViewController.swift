//
//  ViewController.swift
//  MyLittleMonster
//
//  Created by Emanuel  Guerrero on 2/7/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var monsterImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var imageArray = [UIImage]()
        for var x = 1; x <= 4; x++ {
            let image = UIImage(named: "idle\(x).png")
            imageArray.append(image!)
        }
        
        monsterImageView.animationImages = imageArray
        monsterImageView.animationDuration = 0.8
        monsterImageView.animationRepeatCount = 0
        monsterImageView.startAnimating()
    }
}

