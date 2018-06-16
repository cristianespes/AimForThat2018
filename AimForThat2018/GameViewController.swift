//
//  ViewController.swift
//  AimForThat2018
//
//  Created by CRISTIAN ESPES on 2/4/18.
//  Copyright © 2018 CRISTIAN ESPES. All rights reserved.
//

import UIKit
import QuartzCore //

class GameViewController: UIViewController {
    
    var currentValue    : Int = 0
    var targetValue     : Int = 0
    var score           : Int = 0
    var round           : Int = 0
    var time            : Int = 0
    var timer           : Timer?
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var targetLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var roundLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var maxScoreLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetGame()
        updateLabels()
        
        setupSlider()
    }
    
    func setupSlider() {
        
        let thumImageNormal = UIImage(named: "SliderThumb-Normal")
        let thumbImageHighlighted = UIImage(named: "SliderThumb-Highlighted")
        let trackLeftImage = UIImage(named: "SliderTrackLeft")
        let trackRightImage = UIImage(named: "SliderTrackRight")
        
        self.slider.setThumbImage(thumImageNormal, for: .normal)
        self.slider.setThumbImage(thumbImageHighlighted, for: .highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        let trackLeftResizable = trackLeftImage?.resizableImage(withCapInsets: insets)
        let trackRightReizable = trackRightImage?.resizableImage(withCapInsets: insets)
        
        self.slider.setMinimumTrackImage(trackLeftResizable, for: .normal)
        self.slider.setMaximumTrackImage(trackRightReizable, for: .normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func showAlert() {
        
        let difference : Int = abs(self.currentValue - self.targetValue)
        
        // let points : Int = 100 - difference // Modelo lineal
        
        var points = 100 - difference
        
        let title : String
        
        switch difference {
        case 0:
            title = "¡¡¡Puntuación PERFECTA!!!"
            points = Int(5 * points)
        case 1...5:
            title = "¡Has estado a punto!"
            points = Int(1.5 * Float(points))
        case 6...12:
            title = "Ha faltado un poco..."
            points = Int(1.2 * Float(points))
        case 90...100:
            title = "¡Para el otro lado!"
        default:
            title = "Has ido lejos..."
        }
        
        self.score += points
        
        let message = """
        El valor del slider era: \(self.currentValue)
        Has marcado el valor: \(self.targetValue)
        ¡Has conseguido \(points) puntos!
        """
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler:
        { action in
            self.startNewRound()
            self.updateLabels()
        })
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        self.currentValue = Int(sender.value * 100)
    }
    
    func startNewRound(){
        self.targetValue = 1 + Int(arc4random_uniform(100))
        self.currentValue = 50
        self.slider.value = Float(self.currentValue) / 100
        self.round += 1
    }
    
    func updateLabels() {
        self.targetLabel.text = "\(self.targetValue)"
        self.scoreLabel.text = "\(self.score)"
        self.roundLabel.text = "\(self.round)"
        self.timeLabel.text = "\(self.time)"
    }
    
    @IBAction func startNewGame() {
        resetGame()
        updateLabels()
        
        
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        self.view.layer.add(transition, forKey: nil)
    }
    
    func resetGame() {
        
        var maxscore = UserDefaults.standard.integer(forKey: "maxscore")
        if maxscore < self.score {
            maxscore = self.score
            UserDefaults.standard.set(self.score, forKey: "maxscore")
        }
        self.maxScoreLabel.text = "\(maxscore)"
        
        self.score = 0
        self.round = 0
        self.time = 60
        
        if timer != nil {
            timer?.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        
        
        self.updateLabels()
        self.startNewRound()
    }
    
    @objc func tick(){
        self.time -= 1
        self.timeLabel.text = "\(self.time)"
        
        if self.time <= 0 {
            self.resetGame()
        }
    }
    
    
}

