//
//  ViewController.swift
//  MyLittleMonster
//
//  Created by Emanuel  Guerrero on 2/7/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var monsterImageView: MonsterImage!
    @IBOutlet weak var foodImageView: DragImage!
    @IBOutlet weak var heartImageView: DragImage!
    @IBOutlet weak var penalty1ImageView: UIImageView!
    @IBOutlet weak var penalty2ImageView: UIImageView!
    @IBOutlet weak var penalty3ImageView: UIImageView!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALITIES = 3
    
    var penalties = 0
    var timer: NSTimer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodImageView.dropTarget = monsterImageView
        heartImageView.dropTarget = monsterImageView
        
        penalty1ImageView.alpha = DIM_ALPHA
        penalty2ImageView.alpha = DIM_ALPHA
        penalty3ImageView.alpha = DIM_ALPHA
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        startTimer()
    }
    
    func itemDroppedOnCharacter(notification: AnyObject) {
        
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        penalties++
        
        if penalties == 1 {
            penalty1ImageView.alpha = OPAQUE
            penalty2ImageView.alpha = DIM_ALPHA
        } else if penalties == 2 {
            penalty2ImageView.alpha = OPAQUE
            penalty3ImageView.alpha = DIM_ALPHA
        } else if penalties >= 3 {
            penalty3ImageView.alpha = OPAQUE
        } else {
            penalty1ImageView.alpha = DIM_ALPHA
            penalty2ImageView.alpha = DIM_ALPHA
            penalty3ImageView.alpha = DIM_ALPHA
        }
        
        if penalties >= MAX_PENALITIES {
            timer.invalidate()
            gameOver()
        }
    }
    
    func gameOver() {
        timer.invalidate()
        monsterImageView.playDeathAnimation()
    }
}

