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
        return (visibleCardButtons.count+1)/2
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
    
    
    private var visibleCardButtons : [UIButton]!{
        return cardButtons?.filter{ !$0.superview!.isHidden}
    }
    /*
     But it still dont work as when we switch back and forth all those view get relayed out  (layout subviews happens )(but nothing ever cause them to reset them up for my model )(So they have all still got the buttons from  what they were before )(So what I need to do is every time I relayout my subview like this I need  to update my view from the model )(well view controller lifecycle comes to rescue here (viewDidLayoutSubviews))
     
     //it can come  in random location if buttons not connected in proper order in button outlet connection
 */
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViewFromModel()
    }
    
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount+=1
        
        if let cardNumber = visibleCardButtons.index(of:sender){
            
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
        if visibleCardButtons != nil {
            for index in visibleCardButtons.indices
            {
                let button = visibleCardButtons[index]
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

//selecting button in stack view that gonna hide they get hidden
//This is kinda of clucky UI  because we are using these outlet collections to gather  all these cards
// one thing that I could do really easily is go back to my code
//And just every where that I am doing card buttons looking at all cards buttons
//instead of looking at all cards buttons 24 cards buttons I am only  going to look for 20 visible card buttons  at any given time
