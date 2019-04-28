//
//  ViewController.swift
//  Concentration
//
//  Created by MB on 3/25/19.
//  Copyright © 2019 MB. All rights reserved.
//
// we call viewcontollers in storyboard "Scenes"
//everytime we have a viewcontroller it needs a viewcontroller subclass to control it
import UIKit

//Renaming class name to ConcentrationViewController from ViewController using cmd + click
class ConcentrationViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards : Int {
        return (cardButtons.count+1)/2
    }
    
    //when you initialize var it does not invoke didSet
    //only later setting some value invokes didset
    private(set) var flipCount : Int = 0 {
        didSet{
            updateFlipCountLabel()
        }
    }
    
    
    private func updateFlipCountLabel(){
        //creating NSAttribute
        let attributes : [NSAttributedString.Key: Any] = [ .strokeWidth : 5,.strokeColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
        
        //creating NSAttributedString
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        // flipCountLabel.text = "Flips: \(flipCount)"
        
        //setting NSAtrributedString
        flipCountLabel.attributedText = attributedString
    }
    @IBOutlet private var cardButtons: [UIButton]!
    
    //iOS makes connection with Label wehn we have IBOutlet so we can use didSet
    @IBOutlet private weak var flipCountLabel: UILabel!{
        //didSet gets called when Outlet gets connected by iOS
        didSet{
            updateFlipCountLabel()
        }
    }
    
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount+=1
        
        if let cardNumber = cardButtons.index(of:sender){
            
            game.chooseCard(at: cardNumber)
            // as view is out of sync with model we update View
            updateViewFromModel()
        }
        else{
            print("Chosen cards was not in the list")
        }
        
    }
    
    private func updateViewFromModel(){
        //po cardButtons on console to see number coming nil  //left side thread error is called "call stack"
       // cardButtons != nil to protect against accessing cardButton when its not set i.e. in segue
        if cardButtons != nil {
            for index in cardButtons.indices
            {
                let button = cardButtons[index]
                let card = game.cards[index]
                if card.isFaceUp{
                    button.setTitle(emoji(for: card), for: .normal)
                    button.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                }
                else{
                    button.setTitle("", for: .normal)
                    button.backgroundColor = card.isMatched ?  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) :  #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
                }
                
                // MARK:- Crash App
                //            if index > Int(arc4random_uniform(UInt32(100))){
                //                exit(-1)
                //            }
            }
        }
    }
    
    //for choosing theme
    var theme : String? {
        didSet{
            emojiChoices = theme ?? ""
            //resetting emoji that we have set so far because it might be from different theme
            emoji = [:] // [:] empty dictionary because swift would be able to infer the type from  [Card:String]()
            //finally what if someone sets my view and i am in middle of the game ? I think i better update the View . So that whatever is showing  if it's got a wrong theme will update to new theme
            updateViewFromModel()
        }
    }
    
    private var emojiChoices = "👻🎃😈🍭😱🙀🍎🦇"
    
    //private var emoji = [Int:String]()
    
    private var emoji = [Card:String]()
    
    private func emoji(for card : Card)-> String{
        
        if emoji[card] == nil, emojiChoices.count>0{
            
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        
        return emoji[card] ?? "?"
    }
    
}
//MARK:- extension
extension Int{
    var arc4random : Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }
        else if self < 0{
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }
        else{
            return 0
        }
    }
}
