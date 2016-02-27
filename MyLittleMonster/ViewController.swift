//
//  ViewController.swift
//  MyLittleMonster
//
//  Created by Emanuel  Guerrero on 2/7/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var monsterImageView: MonsterImage!
    @IBOutlet weak var foodImageView: DragImage!
    @IBOutlet weak var heartImageView: DragImage!
    @IBOutlet weak var penalty1ImageView: UIImageView!
    @IBOutlet weak var penalty2ImageView: UIImageView!
    @IBOutlet weak var penalty3ImageView: UIImageView!
    @IBOutlet weak var restartButton: UIButton!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALITIES = 3
    
    var penalties = 0
    var timer: NSTimer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var soundEffectBite: AVAudioPlayer!
    var soundEffectHeart: AVAudioPlayer!
    var soundEffectDeath: AVAudioPlayer!
    var soundEffectSkull: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodImageView.dropTarget = monsterImageView
        heartImageView.dropTarget = monsterImageView
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            try soundEffectBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try soundEffectHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            try soundEffectDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            try soundEffectSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            soundEffectBite.prepareToPlay()
            soundEffectHeart.prepareToPlay()
            soundEffectDeath.prepareToPlay()
            soundEffectSkull.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        startNewGame()
    }
    
    @IBAction func onRestartButtonTapped(sender: UIButton!) {
        restartButton.hidden = true
        penalties = 0
        monsterImageView.playIdleAnimation()
        startNewGame()
    }
    
    func startNewGame() {
        penalty1ImageView.alpha = DIM_ALPHA
        penalty2ImageView.alpha = DIM_ALPHA
        penalty3ImageView.alpha = DIM_ALPHA
        
        startTimer()
    }
    
    func itemDroppedOnCharacter(notification: AnyObject) {
        monsterHappy = true
        startTimer()
        
        foodImageView.alpha = DIM_ALPHA
        foodImageView.userInteractionEnabled = false
        heartImageView.alpha = DIM_ALPHA
        heartImageView.userInteractionEnabled = false
        
        if currentItem == 0 {
            soundEffectHeart.play()
        } else {
            soundEffectBite.play()
        }
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        if !monsterHappy {
            penalties++
            
            soundEffectSkull.play()
            
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
        
        let rand = arc4random_uniform(2)
        
        if rand == 0 {
            foodImageView.alpha = DIM_ALPHA
            foodImageView.userInteractionEnabled = false
            
            heartImageView.alpha = OPAQUE
            heartImageView.userInteractionEnabled = true
        } else {
            heartImageView.alpha = DIM_ALPHA
            heartImageView.userInteractionEnabled = false
            
            foodImageView.alpha = OPAQUE
            foodImageView.userInteractionEnabled = true
        }
        
        currentItem = rand
        monsterHappy = false
    }
    
    func gameOver() {
        timer.invalidate()
        monsterImageView.playDeathAnimation()
        soundEffectDeath.play()
        restartButton.hidden = false
    }
}

