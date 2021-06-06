//
//  TrainingController.swift
//  Fit
//
//  Created by Irakli Grigolia on 5/25/21.
//  Copyright © 2021 Beka Japaridze. All rights reserved.
//

import UIKit

class TrainingController: UIViewController {
    
    var clickedButton: RoundButton?
    
  
    
    @IBOutlet weak var Legs: RoundButton!
    @IBOutlet weak var Shoulders: RoundButton!
    @IBOutlet weak var Biceps: RoundButton!
    @IBOutlet weak var Back: RoundButton!
    @IBOutlet weak var Triceps: RoundButton!
    @IBOutlet weak var Chest: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is NoteTableView {
            let vc = segue.destination as! NoteTableView
            vc.name = self.clickedButton?.currentTitle as! String
        }
    }
    
    
    @IBAction func buttonClicked(_ sender: RoundButton)
       {
            self.clickedButton = sender
           performSegue(withIdentifier: "toExerciseView", sender: self)
       }
}
